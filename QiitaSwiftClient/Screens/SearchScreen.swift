//
//  SearchScreen.swift
//  QiitaSwiftClient
//
//  Created by erika yoshikawa on 2024/08/20.
//

import SwiftUI

struct SearchScreen: View {
    @State private var title: String = ""
    @State private var stockNumber: Int = 0
    @State private var createdDate = Date.now
    @State private var isLoading: Bool = false
    @State private var searchItems: Items = []

    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 6) {
                    TextField("",
                              text: $title,
                              prompt: Text("記事のタイトル").foregroundStyle(Color.gray))
                        .padding()
                        .background(Color("Brand"))
                        .foregroundStyle(.black)
                        .cornerRadius(4)
                    TextField("",
                              value: $stockNumber,
                              format: .number,
                              prompt: Text("ストック数（以上検索）").foregroundStyle(Color.gray))
                        .padding()
                        .background(Color("Brand"))
                        .foregroundStyle(.black)
                        .cornerRadius(4)
                        .keyboardType(.numberPad)
                    DatePicker(selection: $createdDate, in: ...Date.now, displayedComponents: .date) {
                        Text("投稿された以降の日付")
                    }
                    Button(action: {
                        isLoading = true
                        Task {
                            try await searchItems(title: title)
                            isLoading = false
                        }
                    }) {
                        Label("記事を検索", systemImage: "magnifyingglass")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(4)
                }
                .padding()
                .background(Color.gray)
                .cornerRadius(4)
                ZStack {
                    if !searchItems.isEmpty {
                        ScrollView {
                            LazyVStack(spacing: 6) {
                                ForEach(searchItems, id: \.id) { item in
                                    NavigationLink {
                                        ItemScreen(id: item.id, title: item.title)
                                    } label: {
                                        ListItem(item: item)
                                    }
                                }
                            }
                        }
                    }
                    if isLoading {
                        Color.gray.opacity(0.5)
                        ProgressView()
                            .padding()
                    }
                }
                Spacer()
            }
            .padding()
            .navigationTitle("記事検索")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func searchItems(title: String) async throws {
        do {
            let fetchedItems = try await QiitaService().searchItems(
                title: title, stocks: stockNumber, created: createdDate
            )
            searchItems = fetchedItems
        } catch {
            print("items not found")
        }
    }
}

//
// #Preview {
//    SearchScreen()
// }
