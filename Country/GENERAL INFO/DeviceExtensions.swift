//
//  AppInfo.swift
//  Country
//
//  Created by Charlie Pico on 29/06/24.
//

import Foundation

extension Bundle {
    func localizedString(forKey key: String) -> String {
        self.localizedString(forKey: key, value: nil, table: nil)
    }
}

extension String {
    var localized: String {
        Bundle.main.localizedString(forKey: self)
    }
}
