//
//  UserScreen.swift
//  QiitaSwiftClient
//
//  Created by erika yoshikawa on 2024/08/14.
//

import SwiftUI

struct UserScreen: View {
    let id: String

    @State private var user: CurrentUser? = nil
    @State private var items: [UserItem] = []

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                if user == nil {
                    Text("ユーザーが見つかりません")
                } else {
                    VStack {
                        UserImage(urlPath: user!.profileImageURL, height: 50)
                        Text("@\(user!.id)")
                            .fontWeight(.semibold)
                        Text(user!.description ?? "ユーザー説明がありません")
                            .padding()
                        HStack {
                            Text("\(user!.itemsCount)投稿")
                            Text("\(user!.followersCount)フォロワー")
                        }
                    }
                    .padding(6)
                    .background(
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(.gray.opacity(0.3))
                    )
                    Divider()
                    VStack {
                        Text("最新の投稿一覧")
                        ScrollView {
                            LazyVStack(spacing: 6) {
                                ForEach(items, id: \.id) { item in
                                    NavigationLink(destination: {
                                        ItemScreen(id: item.id, title: item.title)
                                    }, label: {
                                        VStack(alignment: .leading) {
                                            Text(item.title)
                                                .fontWeight(.bold)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .multilineTextAlignment(.leading)
                                            Text(formatDateString(isoString: item.createdAt))
                                                .font(.footnote)
                                            HStack {
                                                HStack {
                                                    Label("\(item.likesCount)", systemImage: "heart.fill")
                                                    Label("\(item.stocksCount)", systemImage: "tray.fill")
                                                }
                                                Spacer()
                                            }
                                        }
                                        .frame(minHeight: 50)
                                    })
                                    .tint(Color.primary)
                                    .padding(6)
                                    .background(.gray)
                                }
                            }
                        }
                    }
                    .padding(6)
                    .background(
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(.gray.opacity(0.3))
                    )
                }
            }
            .task {
                do {
                    let fetchedUser = try await QiitaService().getUser(userId: id)
                    user = fetchedUser
                    let fetchedItems = try await QiitaService().getUserItems(userId: id)
                    items = fetchedItems
                } catch {
                    print("user not found")
                }
            }
        }
    }
}

//
// #Preview {
//    UserScreen()
// }
