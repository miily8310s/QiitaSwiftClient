//
//  PostAccessTokensModel.swift
//  QiitaSwiftClient
//
//  Created by erika yoshikawa on 2024/07/21.
//

import Foundation

struct PostAccessTokens: Codable {
    let clientId: String?
    let scopes: [String]
    let token: String

    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case scopes
        case token
    }
}
