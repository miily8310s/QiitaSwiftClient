//
//  QiitaModel.swift
//  QiitaSwiftClient
//
//  Created by erika yoshikawa on 2024/07/28.
//

import Foundation

// MARK: - AuthenticatedUser

struct AuthenticatedUser: Codable {
    let id: String
    let profileImageURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case profileImageURL = "profile_image_url"
    }
}

// MARK: - Item

struct Item: Codable {
    let renderedBody, body: String
    let createdAt: String
    let id: String
    let likesCount: Int
    let tags: [Tag]
    let title: String
    let updatedAt: String
    let url: String
    let user: User

    enum CodingKeys: String, CodingKey {
        case renderedBody = "rendered_body"
        case body
        case createdAt = "created_at"
        case id
        case likesCount = "likes_count"
        case tags, title
        case updatedAt = "updated_at"
        case url, user
    }
}

// MARK: - Tag

struct Tag: Codable {
    let name: String
    let versions: [String]
}

// MARK: - User

struct User: Codable {
    let id, name: String
    let organization: String?
    let profileImageURL: String

    enum CodingKeys: String, CodingKey {
        case id, name, organization
        case profileImageURL = "profile_image_url"
    }
}

typealias Items = [Item]
