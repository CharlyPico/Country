//
//  NumbersInfo.swift
//  Country
//
//  Created by Charlie Pico on 29/06/24.
//

import Foundation

//I created this NumbersExtensions file to separate large numbers with a thousands separator (here in México we use the , symbol).
extension Formatter {
    static let withSeparatorNoDecimals: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Numeric {
    var formattedWithSeparatorNoDecimals: String {
        return Formatter.withSeparatorNoDecimals.string(for: self) ?? ""
    }
}
