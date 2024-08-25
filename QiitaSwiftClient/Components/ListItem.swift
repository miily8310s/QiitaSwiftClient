//
//  ListItem.swift
//  QiitaSwiftClient
//
//  Created by erika yoshikawa on 2024/08/21.
//

import SwiftUI

struct ListItem: View {
    let columns = [GridItem(.fixed(50)), GridItem(.flexible()), GridItem(.fixed(42))]

    let item: Item

    var body: some View {
        LazyVGrid(columns: columns) {
            UserImage(urlPath: item.user.profileImageURL, height: 50)
            VStack(alignment: .leading, spacing: 0) {
                Text(item.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .bold()
                HStack {
                    Text(item.user.name == "" ? item.user.id : item.user.name)
                        .font(.caption2)
                        .frame(maxWidth: 200, alignment: .leading)
                        .bold()
                    Spacer()
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

//
// #Preview {
//    ListItem()
// }
