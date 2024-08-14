//
//  UserImage.swift
//  QiitaSwiftClient
//
//  Created by erika yoshikawa on 2024/07/28.
//

import SwiftUI

struct UserImage: View {
    let urlPath: String
    var height: Int?

    var body: some View {
        AsyncImage(url: URL(string: urlPath)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } else if phase.error != nil {
                Text("No image")
            } else {
                ProgressView()
            }
        }
        .frame(height: CGFloat(height ?? 200))
    }
}
