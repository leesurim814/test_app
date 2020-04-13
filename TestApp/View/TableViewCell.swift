//
//  TableViewCell.swift
//  TestApp
//
//  Created by lee su rim on 2020/04/12.
//  Copyright © 2020 lee su rim. All rights reserved.
//

import UIKit

// TableViewCellクラス
class TableViewCell: UITableViewCell {
    // ユーザー画像
    @IBOutlet private weak var userImage: UIImageView!
    // ユーザー名
    @IBOutlet private weak var name: UILabel!
    // 登録日
    @IBOutlet private weak var date: UILabel!
    // メッセージ
    @IBOutlet private weak var message: UILabel!
    // 削除ボタン
    @IBOutlet public weak var delete: UIButton!
        
    // 初期化
    override func awakeFromNib() {
        super.awakeFromNib()
        print("TableViewCell#awakeFromNib")
        // Initialization code
        self.accessoryType  = .none
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state.
    }
    
    // MARK: - Method
    
    // Cellデーターを設定
    func setCell(_ model: Post)  {
        print("TableViewCell#setCell")
        name.text = model.user.login
        message.text = model.body
        if model.id != 0 {
            let createdAt: Date = DateUtil.dateFromString(string: model.created_at, format: "yyyy-MM-dd'T'HH:mm:ssZZZ")
            print("createdAt: ", createdAt)
            let createdAtString: String = DateUtil.stringFromDate(date: createdAt, format: "yyyy-MM-dd HH:mm:ss")
            print("createdAtString: ", createdAtString)
            date.text = createdAtString
        } else {
            date.text = model.created_at
        }
        
        userImage.image = getImageByUrl(url: model.user.avatar_url)
        if model.id == 0 {
            delete.isHidden = false
        } else {
            delete.isHidden = true
        }
    }
    
    // Urlからイメージを取得
    func getImageByUrl(url: String) -> UIImage {
        print("TableViewCell#getImageByUrl: ", url)
        if url == "" {
            return UIImage(named: "user_image")!
        } else {
            let url: URL = URL(string: url)!
            do {
                let data: Data = try Data(contentsOf: url)
                return UIImage(data: data)!
            } catch let error {
                print("Error : \(error.localizedDescription)")
            }
        }
        return UIImage(named: "user_image")!
    }
}
