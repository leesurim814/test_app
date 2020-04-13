//
//  Util.swift
//  TestApp
//
//  Created by lee su rim on 2020/04/13.
//  Copyright © 2020 lee su rim. All rights reserved.
//

import Foundation

// DateUtilのクラス
class DateUtil {
    // StringからDateに変換
    class func dateFromString(string: String, format: String) -> Date {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)!
    }

    // DateからStringに変換
    class func stringFromDate(date: Date, format: String) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
