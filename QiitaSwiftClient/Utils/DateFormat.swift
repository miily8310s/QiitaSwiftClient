//
//  DateFormat.swift
//  QiitaSwiftClient
//
//  Created by erika yoshikawa on 2024/08/17.
//

import Foundation

// ref: https://qiita.com/antk/items/74ebd6110f94b6843f6a
func formatDateString(isoString: String) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

    guard let date = formatter.date(from: isoString) else {
        return "日付なし"
    }
    formatter.dateFormat = "yyyy年MM月dd日"
    return formatter.string(from: date)
}
