//
//  AddViewController.swift
//  TestApp
//
//  Created by lee su rim on 2020/04/11.
//  Copyright © 2020 lee su rim. All rights reserved.
//

import UIKit

// AddDelegate
protocol AddDelegate {
    //「投稿する」ボタン押下時、呼ばれるCallBack
    func postAdded(post: Post)
}

// AddViewControllerクラス
class AddViewController: UIViewController {
    // ユーザー名
    @IBOutlet private weak var name: UITextField!
    // メッセージ
    @IBOutlet private weak var message: UITextView!
    // ScrollView
    @IBOutlet weak var scrollView: UIScrollView!
    // 投稿
    @IBOutlet weak var addBtn: UIButton!
    // Bottom制約
    @IBOutlet weak var bottomConstraints: NSLayoutConstraint!
    // AddDelegate
    public var addDelegate: AddDelegate?
    // ScrollViewのOffset
    var saveOffset:CGFloat?

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AddViewController#viewDidLoad")
        // Keyboard Notification追加
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Keyboard Notification削除
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Event
    
    //「投稿する」ボタン押下時、呼ばれるCallBack
    @IBAction func postButtonPushed() {
        print("AddViewController#postButtonPushed")
        let post: Post = Post(id: 0,
                              user: User(login: name.text ?? "", avatar_url: ""),
                              body: message.text,
                              created_at: DateUtil.stringFromDate(date: Date(), format: "yyyy-MM-dd HH:mm:ss"),
                              updated_at: DateUtil.stringFromDate(date: Date(), format: "yyyy-MM-dd HH:mm:ss"))
        addDelegate?.postAdded(post: post)
        self.navigationController?.popViewController(animated: true)
    }
    
    // キーボード表示時、呼ばれるCallBack
    @objc func keyboardWillShow(_ notification: Notification) {
        print("AddViewController#keyboardWillShow")
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        guard let btn = addBtn else { return }

        let keyboardHeight: CGFloat = keyboardFrame.cgRectValue.height
        let keyboardTopLine: CGFloat = view.frame.height - keyboardHeight

        let bottomLine: CGFloat = btn.frame.origin.y + btn.frame.height
        let displayBottom: CGFloat = bottomLine - scrollView.contentOffset.y

        if displayBottom > keyboardTopLine {
            let sub = displayBottom - keyboardTopLine
            saveOffset = sub
            let offset = CGPoint(x: scrollView.contentOffset.x, y: self.scrollView.contentOffset.y + sub)

            scrollView.setContentOffset(offset, animated: true)
            bottomConstraints.constant = keyboardHeight
        }
    }
    
    // 画面のタップ時、キーボードを閉じる。
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        print("AddViewController#onTap")
        var offset: CGPoint = CGPoint(x: 0, y: 0)
        if scrollView.contentOffset.y - (saveOffset ?? 0) < 0 {
            offset = CGPoint(x: self.scrollView.contentOffset.x, y: 0)
        } else if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height - bottomConstraints.constant) {
            offset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y)
        } else {
            offset = CGPoint(x: scrollView.contentOffset.x, y: self.scrollView.contentOffset.y - (saveOffset ?? 0))
        }

        saveOffset = nil
        bottomConstraints.constant = 0
        scrollView.setContentOffset(offset, animated: true)
        
        view.endEditing(true)
    }
}
