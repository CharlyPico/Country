//
//  CountryApp.swift
//  Country
//
//  Created by Charlie Pico on 29/06/24.
//

import SwiftUI

@main
struct CountryApp: App {
    let countryObservable = CountryObservable()
    var body: some Scene {
        WindowGroup {
            CountryView()
                .environmentObject(countryObservable)
        }
    }
}
