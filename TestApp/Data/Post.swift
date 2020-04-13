//
//  UserInfo.swift
//  TestApp
//
//  Created by lee su rim on 2020/04/11.
//  Copyright © 2020 lee su rim. All rights reserved.
//

import Foundation

// PostのModelクラス
struct Post: Codable {
    // id
    let id: Int
    // User情報
    let user: User
    // メッセージ
    let body: String
    // 登録日
    let created_at: String
    // 更新日
    let updated_at: String
}

// UserのModelクラス
struct User: Codable {
    // ログインユーザー名
    let login: String
    // ユーザー画像
    let avatar_url: String
}
