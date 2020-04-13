//
//  ViewController.swift
//  TestApp
//
//  Created by lee su rim on 2020/04/11.
//  Copyright © 2020 lee su rim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// TopViewControllerクラス
class TopViewController: UIViewController, AddDelegate {
    // TableView
    @IBOutlet private weak var tableView: UITableView!
    // ActivityIndicatorView
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    // Rxリソース解放用
    private let disposeBag = DisposeBag()
    // PostViewModel
    private let postViewModel = PostViewModel()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("TopViewController#viewDidLoad")
        // 戻るの文言を非表示
        navigationController?.navigationBar.topItem?.title = " "
        
        // Postのリスト情報を取得
        postViewModel.getPosts()
        
        // 一覧データをUITableViewに設定する処理
        postViewModel.posts.asObservable().bind(to: tableView.rx.items) { (tableView, row, post) in
            print("bind post: ", post)
            let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
            tableViewCell.setCell(post)
            tableViewCell.delete.tag = row
            return tableViewCell
        }.disposed(by: disposeBag)
        
        // 読み込み状態が更新された場合の処理
        postViewModel.isLoading.asDriver().drive(onNext: { [weak self] in
            if $0 == true {
                self?.activityIndicatorView.isHidden = false
            } else {
                self?.activityIndicatorView.isHidden = true
            }
        }).disposed(by: disposeBag)
        
        // エラー状態が更新された場合の処理
        postViewModel.isError.asDriver().drive(onNext: { [weak self] in
            if $0 == true {
                DialogManager.shared.showAlert(
                    viewController: self!,
                    title: NSLocalizedString("error_title", comment: ""),
                    message: NSLocalizedString("error_message", comment: "")
                )
            }
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Storyboard
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("TopViewController#prepare")
        if segue.identifier == "add" {
            let addViewController: AddViewController = segue.destination as! AddViewController
            addViewController.addDelegate = self
        }
    }
    
    // MARK: - Event

    // 削除ボタン押下時、呼ばれるCallBack
    @IBAction func deleteButtonPushed(_ sender: UIButton) {
        print("TopViewController#deleteButtonPushed: ", sender.tag)
        postViewModel.posts.remove(at: sender.tag)
    }
    
    // MARK: - AppDelegate
    
    // 「投稿する」ボタン押下時、呼ばれるCallBack
    public func postAdded(post: Post) {
        print("TopViewController#postAdded: ", post)
        postViewModel.posts.insert(post, at: 0)
    }
}
