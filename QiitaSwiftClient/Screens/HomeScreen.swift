//
//  HomeScreen.swift
//  QiitaSwiftClient
//
//  Created by erika yoshikawa on 2024/07/15.
//

import SwiftUI

struct HomeScreen: View {
    @State private var items: Items = []
    @State private var authenticatedUser: AuthenticatedUser? = nil
    @StateObject private var viewModel = UserStateViewModel()

    let columns = [GridItem(.fixed(50)), GridItem(.flexible()), GridItem(.fixed(42))]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 6) {
                    ForEach(items, id: \.id) { item in
                        LazyVGrid(columns: columns) {
                            UserImage(urlPath: item.user.profileImageURL, height: 50)
                            VStack(alignment: .leading, spacing: 0) {
                                Text(item.title)
                                    .lineLimit(2)
                                    .bold()
                                HStack {
                                    Text(item.user.name == "" ? item.user.id : item.user.name)
                                        .font(.caption2)
                                        .bold()
                                    Text(item.createdAt.prefix(10))
                                        .font(.footnote)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Image(systemName: "greaterthan.circle.fill")
                                .frame(width: 42, height: 42)
                        }
                    }
                }
                .padding()
                .background(Color("Brand"))
            }
            .task {
                do {
                    let fetchedItems = try await QiitaService().getRecentItems()
                    let fetchedUser = try await QiitaService().getAuthenticatedUser()
                    items = fetchedItems
                    authenticatedUser = fetchedUser
                } catch {
                    print("items not found")
                }
            }
            .navigationTitle("Qiita Client")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if authenticatedUser != nil {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("Qiita Client")
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            NavigationLink("ユーザーページ") {
                                //                                TODO: 後ほど作成
                                //                                UserScreen(id: authenticatedUser?.id)
                            }
                            Button("ログアウト", role: .destructive) {
                                viewModel.signOut()
                            }
                        } label: {
                            UserImage(urlPath: authenticatedUser!.profileImageURL, height: 30)
                        }
                    }
                }
            }
        }
    }
}

//
// #Preview {
//    HomeScreen()
// }
