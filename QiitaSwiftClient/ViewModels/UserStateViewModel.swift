//
//  UserStateViewModel.swift
//  QiitaSwiftClient
//
//  Created by erika yoshikawa on 2024/07/15.
//

import AuthenticationServices
import Combine
import Foundation

class UserStateViewModel: NSObject, ObservableObject {
    // viewmodelでいうアットマークStateのようなもの。view側に値の変化を伝えられる。
    @Published var isLoggined = false

    init(isLoggined _: Bool = false, cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        isLoggined = UserDefaults.standard.value(forKey: "AccessToken") != nil
        self.cancellables = cancellables
    }

    private var cancellables = Set<AnyCancellable>()

    private static var authURL: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "qiita.com"
        components.path = "/api/v2/oauth/authorize"
        components.queryItems = [
            "client_id": "b06390e5f2574b3881e361f3da396af1f3040688",
            "client_secret": "0bcf388c0848d576a261fbe5c40ecc4f922666df",
            "scope": "read_qiita write_qiita"
        ].map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }

    func signIn() {
        let signInPromise = Future<URL, Error> { completion in
            let authSession = ASWebAuthenticationSession(
                url: UserStateViewModel.authURL,
                callbackURLScheme: "qiita-swift-client"
            ) { url, error in
                if let error {
                    completion(.failure(error))
                } else if let url {
                    completion(.success(url))
                }
            }

            authSession.presentationContextProvider = self
            authSession.prefersEphemeralWebBrowserSession = true
            authSession.start()
        }

        signInPromise.sink(receiveCompletion: { completion in
            switch completion {
            case let .failure(error):
                print("error \(error)")
            default:
                break
            }
        }, receiveValue: { [self] url in
            print("url \(url)")
            guard let code = retrieveCode(url) else {
                return
            }
            Task {
                do {
                    let accessToken = try await createAccessToken(code)
                    let defaults = UserDefaults.standard
                    defaults.set(accessToken, forKey: "AccessToken")
                } catch {
                    print("retrieve accessToken error")
                }
            }
        })
        .store(in: &cancellables)
    }

    private func retrieveCode(_ url: URL) -> String? {
        let components: NSURLComponents? = getURLComonents(url)
        for item in components?.queryItems ?? [] where item.name == "code" {
            return item.value?.removingPercentEncoding
        }
        return nil
    }

    private func getURLComonents(_ url: URL) -> NSURLComponents? {
        NSURLComponents(url: url, resolvingAgainstBaseURL: true)
    }

    private func createAccessToken(_ code: String) async throws -> String {
        let accessTokenURL: URL = {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "qiita.com"
            components.path = "/api/v2/access_tokens"
            components.queryItems = [
                "client_id": "b06390e5f2574b3881e361f3da396af1f3040688",
                "client_secret": "0bcf388c0848d576a261fbe5c40ecc4f922666df",
                "code": code
            ].map { URLQueryItem(name: $0, value: $1) }
            return components.url!
        }()
        var request = URLRequest(url: accessTokenURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(PostAccessTokens.self, from: data)
        return response.token
    }

    func signOut() {
        Task {
            do {
                guard let accessToken = UserDefaults.standard.string(forKey: "AccessToken") else {
                    return print("not found accesstoken")
                }
                try await QiitaService().deleteAccessToken(token: accessToken)
                UserDefaults.standard.removeObject(forKey: "AccessToken")
            } catch {
                print("delete accessToken error")
            }
        }
    }
}

extension UserStateViewModel: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for _: ASWebAuthenticationSession) -> ASPresentationAnchor {
        ASPresentationAnchor()
    }
}
