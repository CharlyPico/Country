//
//  CountryApp.swift
//  Country
//
//  Created by Charlie Pico on 29/06/24.
//

import SwiftUI

@main
struct CountryApp: App {
    //Here I created the ObservableObject used as an environmentObject for our countries array. This way any change made to any country, is applied through the entire App.
    let countryObservable = CountryObservable()
    var body: some Scene {
        WindowGroup {
            Splashscreen()
                .environmentObject(countryObservable)
                //Here I attach the observableObject to the splash screen.
                .onAppear{
                    addWindowSizeHandlerForMacOS()
                }
        }
    }
    
    func addWindowSizeHandlerForMacOS() {
        UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
            windowScene.sizeRestrictions?.minimumSize = CGSize(width: 1200, height: 840)
            windowScene.sizeRestrictions?.maximumSize = CGSize(width: 1200, height: 840)
        }
    }
}
