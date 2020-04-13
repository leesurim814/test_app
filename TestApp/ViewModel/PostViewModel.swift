//
//  ViewModel.swift
//  TestApp
//
//  Created by lee su rim on 2020/04/11.
//  Copyright © 2020 lee su rim. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

// PostのViewModel
class PostViewModel {
    // Rxリソース解放用
    private var disposeBag = DisposeBag()
    // ローディング中判定
    let isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    // エラー判定
    let isError: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    // Postリストデーター
    let posts: BehaviorRelay<[Post]> = BehaviorRelay<[Post]>(value: [])
    // PostのModel
    let postModel: PostModel = PostModel()
    
    // Postのリスト情報を取得
    public func getPosts() {
        print("PostViewModel#getPosts")
        isLoading.accept(true)
        isError.accept(false)
        
        postModel.getPostList().subscribe(
            onSuccess: { posts in
                debugPrint(posts)
                self.posts.accept(posts)
                print("posts value", self.posts.value)
                self.isLoading.accept(false)
                self.isError.accept(false)
            },
           onError: { error in
                self.isLoading.accept(false)
                self.isError.accept(true)
                print("error: ", error.localizedDescription)
            }
        ).disposed(by: disposeBag)
    }
}
