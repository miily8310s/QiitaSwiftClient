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
                        NavigationLink {
                            ItemScreen(id: item.id, title: item.title)
                        } label: {
                            ListItem(item: item)
                        }
                    }
                }
                .padding()
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
                            .fontWeight(.bold)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            NavigationLink("ユーザーページ") {
                                UserScreen(id: authenticatedUser!.id)
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
            .toolbarBackground(Color("Brand"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

//
// #Preview {
//    HomeScreen()
// }
