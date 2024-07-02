//
//  Splashscreen.swift
//  Country
//
//  Created by Charlie Pico on 02/07/24.
//

import SwiftUI

struct Splashscreen: View {
    @EnvironmentObject var countryObservable:CountryObservable
    @State var showSplash = false
    
    var body: some View {
        ZStack {
            if showSplash {
                CountryView()
                    .environmentObject(countryObservable)
            }else{
                Image("jiffy_splash")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color(.systemGroupedBackground)
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showSplash = true
                }
            }
        }
    }
        
}
