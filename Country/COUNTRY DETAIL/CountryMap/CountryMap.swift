//
//  CountryMap.swift
//  Country
//
//  Created by Charlie Pico on 30/06/24.
//

import SwiftUI

struct CountryMap: View {
    @Binding var selectedCountry:CountryDataStruct
    @State var showLoader = true
    var body: some View {
        ZStack {
            ProgressView()
                .progressViewStyle(.circular)
                .opacity(showLoader ? 1.0:0.0)
            MapViewRepresentable(urlToLoad: URL(string: selectedCountry.countryDetails?.countryGoogleMapsURLString ?? "https://www.apple.com")!, showLoader: $showLoader)
                .opacity(showLoader ? 0.0:1.0)
        }
    }
}
