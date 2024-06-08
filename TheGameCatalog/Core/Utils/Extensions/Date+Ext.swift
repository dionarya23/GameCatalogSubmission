//
//  Date+Ext.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 06/06/24.
//

import Foundation

func formatDateString(_ dateString: String?) -> String {
    guard let dateString = dateString else {
        return "tgl tdk diketahui"
    }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    guard let date = dateFormatter.date(from: dateString) else {
        return "tgl tdk diketahui"
    }

    dateFormatter.dateFormat = "dd MMM yyyy"
    return dateFormatter.string(from: date)
}
