//
//  NumbersInfo.swift
//  Country
//
//  Created by Charlie Pico on 29/06/24.
//

import Foundation

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
