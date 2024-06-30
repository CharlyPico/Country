//
//  CountryView.swift
//  Country
//
//  Created by Charlie Pico on 29/06/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct CountryView: View {
    @EnvironmentObject var countryObservable:CountryObservable
    
    let listGrid = [
        GridItem(.adaptive(minimum: UIDevice.current.userInterfaceIdiom == .pad ? 100:300)),
        GridItem(.adaptive(minimum: UIDevice.current.userInterfaceIdiom == .pad ? 100:300))
    ]
    
    @State var webInfo = WebInformation()
    @State var device = UIDevice.current.userInterfaceIdiom
    @State var showAlert = false
    @State var showTopMessage = true
    @State var sessionErrorResponse = ""
    @State var searchCountry = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.vertical) {
                    if showTopMessage { TopMessage }
                    LazyVGrid(columns: listGrid) {
                        ForEach(searchCountry.replacingOccurrences(of: " ", with: "") != "" ? $countryObservable.countriesArray.filter({$0.countryName.wrappedValue.lowercased().contains(searchCountry.lowercased())}):Array($countryObservable.countriesArray), id: \.id) { country in
                            NavigationLink {
                                CountryDetail(selectedCountry: country, showTopMessage: $showTopMessage, webInfo: $webInfo, device: $device).environmentObject(countryObservable)
                            } label: {
                                VStack(spacing: 10){
                                    WebImage(url: URL(string: country.countryFlag.wrappedValue)) { image in
                                        image.resizable()
                                    } placeholder: {
                                        RoundedRectangle(cornerRadius: 10, style: .continuous).foregroundStyle(Color(.darkGray))
                                    }
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 31)
                                    .padding(.horizontal, 5)
                                    Text(country.countryName.wrappedValue.lowercased().capitalized)
                                        .padding(.horizontal, 5)
                                        .font(.title2)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(3)
                                        .minimumScaleFactor(0.5)
                                }
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .frame(minHeight: 100)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundStyle(.tertiary)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 15)
                }
            }
            .navigationTitle("Countries")
        }
        .searchable(text: $searchCountry)
        .alert(isPresented: $showAlert) {
            if sessionErrorResponse != "" {
                return Alert(title: Text("Error".localized), message: Text(sessionErrorResponse), dismissButton: Alert.Button.default(Text("Ok".localized)))
            }else{
                return Alert(title: Text("Internet".localized), message: Text("Please connect to the internet and try again".localized), dismissButton: Alert.Button.default(Text("Ok".localized)))
            }
        }
        .onAppear {
            loadCountriesMainData()
        }
    }
    
    var TopMessage:some View {
        VStack {
            Text("Welcome to Country Search, please tap any desired country to get more information".localized)
                .padding(10)
        }
        .frame(maxWidth: .infinity)
        .padding(5)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.tertiary)
        )
        .padding(.horizontal, 15)
    }
    
    func loadCountriesMainData() {
        sessionErrorResponse = ""
        var request = URLRequest(url: webInfo.urlToLoad("/all"))
        request.httpMethod = "GET"
        let urlSession = URLSession(configuration: webInfo.generalUrlSessionConfiguration)
        urlSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                sessionErrorResponse = error?.localizedDescription ?? "Unable to load Country data, please try again".localized
                showAlert = true
                return
            }
            
            if let countries = CountryDataStructMap(data) {
                DispatchQueue.main.async {
                    countryObservable.countriesArray.append(contentsOf: countries.countriesList)
                    
                    countryObservable.countriesArray.sort{
                        $0.countryName < $1.countryName
                    }
                }
            }
        }.resume()
    }
}
