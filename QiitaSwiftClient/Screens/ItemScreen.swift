//
//  ItemScreen.swift
//  QiitaSwiftClient
//
//  Created by erika yoshikawa on 2024/08/16.
//

import SwiftUI

struct HtmlRender: View {
    let htmlText: String

    var body: some View {
        if let nsAttributedString = try? NSAttributedString(
            data: htmlText.data(using: .utf16)!,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        ),
            let attributedString = try? AttributedString(nsAttributedString, including: \.uiKit)
        {
            Text(attributedString)
        } else {
            Text(htmlText)
        }
    }
}

struct ItemScreen: View {
    let id: String
    let title: String

    @State private var item: Item? = nil
    @State private var itemBody: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                if item != nil {
                    HStack {
                        NavigationLink {
                            UserScreen(id: item!.user.id)
                        } label: {
                            HStack {
                                UserImage(urlPath: item!.user.profileImageURL, height: 25)
                                Text("@\(item!.user.name == "" ? item!.user.id : item!.user.name)")
                            }
                        }
                        Spacer()
                        Text(formatDateString(isoString: item!.createdAt))
                    }
                    .padding()
                    Text(item!.title)
                        .font(.title)
                        .fontWeight(.bold)
                    if item!.tags.isEmpty != true {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(item!.tags, id: \.name) { tag in
                                    Text(tag.name)
                                        .font(.footnote)
                                        .padding()
                                        .background(RoundedRectangle(cornerRadius: 25).fill(.green))
                                }
                            }
                            .padding()
                        }
                    }
                    HtmlRender(htmlText:
                        """
                        <html>
                        <style>
                          h1, h2, h3 {
                            margin-bottom: 12px;
                        }
                          h1, h2, h3, p {
                            line-height: 2.5;
                          }
                        </style>
                        <body>
                        \(item!.renderedBody)
                        </body>
                        </html>
                        """)
                        .padding(12)
                        .background(Color.green)

                } else {
                    VStack {
                        ProgressView()
                    }
                }
            }
            .task {
                do {
                    let fetchedItem = try await QiitaService().getItem(itemId: id)
                    item = fetchedItem
                } catch {
                    print("items not found")
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//
// #Preview {
//    ItemScreen()
// }
