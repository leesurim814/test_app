//
//  Model.swift
//  TestApp
//
//  Created by lee su rim on 2020/04/11.
//  Copyright © 2020 lee su rim. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

// Postのモデル
class PostModel {
    // GitHub API URL
    private let url: String = "https://api.github.com/repos/tristanhimmelman/ObjectMapper/issues/comments?sort=created&direction=desc"
    
    // コメントリスト取得
    public func getPostList() -> Single<[Post]> {
        print("PostModel#getPostList")
        return Single<[Post]>.create(subscribe: { singleEvent in
            AF.request(self.url, method: .get).response { response in
                debugPrint(response)
                switch response.result {
                    // 成功時
                    case .success(let response):
                        let posts: [Post]? = try? JSONDecoder().decode([Post].self, from: response!)
                        singleEvent(.success(posts!))
                    // 失敗時
                    case .failure(let error):
                        singleEvent(.error(error))
                }
            }
            return Disposables.create()
        })
    }
}
