//
//  CountryMap.swift
//  Country
//
//  Created by Charlie Pico on 30/06/24.
//

import SwiftUI

struct CountryMap: View {
    //Here I implemented the '.presentationMode' that allows the App to go to the previous view if the Map doesn't load.
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Binding var selectedCountry:CountryDataStruct
    
    @State var showLoader = true
    @State var mapError:Error?
    @State var showAlert = false
    
    var body: some View {
        ZStack {
            VStack {
                ProgressView()
                    .progressViewStyle(.circular)
                    .opacity(showLoader ? 1.0:0.0)
                    .padding(.top, 15)
                Spacer()
            }
            //In here we call a 'UIViewRepresentable' because I use a 'WKWebView' to load the Google Maps' map (For more info go to the CountryMapRepresentable file).
            MapViewRepresentable(urlToLoad: URL(string: selectedCountry.countryDetails?.countryGoogleMapsURLString ?? "https://www.apple.com")!, showLoader: $showLoader, mapError: $mapError, showAlert: $showAlert)
                .opacity(showLoader ? 0.0:1.0)
        }
        .navigationTitle("Country Map")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showAlert) {
            //If the map presents an error while loading, we present an error alert to the user.
            return Alert(title: Text("Map Error"), message: Text(mapError?.localizedDescription ?? "Unable to load Google Maps, please try again"), dismissButton: Alert.Button.default(Text("Ok"), action: {
                presentationMode.wrappedValue.dismiss()
            }))
        }
    }
}
