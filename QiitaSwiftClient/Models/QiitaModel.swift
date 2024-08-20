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

// MARK: - CurrentUser

struct CurrentUser: Codable {
    let id, name: String
    let itemsCount: Int
    let followersCount: Int
    let description: String?
    let organization: String?
    let profileImageURL: String

    enum CodingKeys: String, CodingKey {
        case id, name, description, organization
        case itemsCount = "items_count"
        case followersCount = "followers_count"
        case profileImageURL = "profile_image_url"
    }
}

// MARK: - CurrentUser

struct UserItem: Codable {
    let id, title: String
    let likesCount: Int
    let stocksCount: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, title
        case likesCount = "likes_count"
        case stocksCount = "stocks_count"
        case createdAt = "created_at"
    }
}
