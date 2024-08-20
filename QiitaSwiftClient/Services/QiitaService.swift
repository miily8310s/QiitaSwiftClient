//
//  QiitaService.swift
//  QiitaSwiftClient
//
//  Created by erika yoshikawa on 2024/07/28.
//

import Foundation

struct QiitaService {
    func getAuthenticatedUser() async throws -> AuthenticatedUser {
        guard let url = URL(string: "https://qiita.com/api/v2/authenticated_user") else {
            throw URLError(.badURL)
        }
        guard let token = UserDefaults.standard.value(forKey: "AccessToken") else {
            print("not found token")
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        let user = try JSONDecoder().decode(AuthenticatedUser.self, from: data)
        return user
    }

    func getRecentItems() async throws -> Items {
        guard let url = URL(string: "https://qiita.com/api/v2/items?page=1&per_page=20") else {
            throw URLError(.badURL)
        }
        guard let token = UserDefaults.standard.value(forKey: "AccessToken") else {
            print("not found token")
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        let items = try JSONDecoder().decode(Items.self, from: data)
        return items
    }

    func deleteAccessToken(token: String) async throws {
        guard let url = URL(string: "https://qiita.com/api/v2/access_tokens/\(token)") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        _ = try await URLSession.shared.data(for: request)
    }

    func getUser(userId: String) async throws -> CurrentUser {
        guard let url = URL(string: "https://qiita.com/api/v2/users/\(userId)") else {
            throw URLError(.badURL)
        }
        guard let token = UserDefaults.standard.value(forKey: "AccessToken") else {
            print("not found token")
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        let currentUser = try JSONDecoder().decode(CurrentUser.self, from: data)
        return currentUser
    }

    func getItem(itemId: String) async throws -> Item {
        guard let url = URL(string: "https://qiita.com/api/v2/items/\(itemId)") else {
            throw URLError(.badURL)
        }
        guard let token = UserDefaults.standard.value(forKey: "AccessToken") else {
            print("not found token")
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        let item = try JSONDecoder().decode(Item.self, from: data)
        return item
    }

    func getUserItems(userId: String) async throws -> [UserItem] {
        guard let url = URL(string: "https://qiita.com/api/v2/users/\(userId)/items?page=1&per_page=20") else {
            throw URLError(.badURL)
        }
        guard let token = UserDefaults.standard.value(forKey: "AccessToken") else {
            print("not found token")
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        let items = try JSONDecoder().decode([UserItem].self, from: data)
        return items
    }
}
