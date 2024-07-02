//
//  CountryView.swift
//  Country
//
//  Created by Charlie Pico on 29/06/24.
//

import SwiftUI

//This is our main view, in here we load our initial Country data and display it in a Grid layout of 2 items per row.
struct CountryView: View {
    @EnvironmentObject var countryObservable:CountryObservable
    
    let listGrid = [
        GridItem(.adaptive(minimum: 300))
    ]
    
    @State var webInfo = WebInformation()
    @State var device = UIDevice.current.userInterfaceIdiom
    @State var showAlert = false
    @State var showTopMessage = false
    @State var sessionErrorResponse = ""
    @State var searchCountry = ""
    @State var loadingCountries = true
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.vertical) {
                    if showTopMessage {
                        //Here I separated the TopMessage item to an external View. This helps keeping things understandable, easy to navigate and organized.
                        TopMessage
                        .opacity(loadingCountries ? 0.0:1.0)
                    }
                    LazyVGrid(columns: listGrid) {
                        //As I have implemented a Search bar, filtering the information from our Countries array is important, this way we always get the right results for the searched parameters.
                        ForEach(searchCountry.replacingOccurrences(of: " ", with: "") != "" ? $countryObservable.countriesArray.filter({$0.countryName.wrappedValue.lowercased().contains(searchCountry.lowercased())}):Array($countryObservable.countriesArray), id: \.id) { country in
                            NavigationLink {
                                CountryDetail(selectedCountry: country, showTopMessage: $showTopMessage, webInfo: $webInfo, device: $device).environmentObject(countryObservable)
                            } label: {
                                //Here I separated the "cell" item to an external struct (more info at the CountryCellStruct file). This helps keeping things understandable, easy to navigate and organized.
                                CountryCellStruct(country: country, device: $device)
                                    .frame(maxWidth: .infinity, maxHeight: 300)
                                    .frame(minHeight: 100)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundStyle(Color(.secondarySystemGroupedBackground))
                                    )
                            }
                            .simultaneousGesture(
                                //I added a simultaneousGesture to the Navigation to set the TopMessage UserDefaults so it doesn't show every time the user opens the App.
                                TapGesture()
                                    .onEnded({ _ in
                                        impact(style: .soft)
                                        UserDefaults.standard.setValue(false, forKey: "topMessage")
                                    })
                            )
                            .buttonStyle(.plain)
                        }
                    }
                    .opacity(loadingCountries ? 0.0:1.0)
                    .padding(.horizontal, 15)
                }
                .overlay(
                    VStack{
                        ProgressView()
                            .progressViewStyle(.circular)
                            .opacity(countryObservable.countriesArray.isEmpty ? 1.0:0.0)
                            .padding(.top, 15)
                        Spacer()
                    }
                )
            }
            .navigationTitle("Countries")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color(.systemGroupedBackground)
            )
        }
        .searchable(text: $searchCountry)
        .alert(isPresented: $showAlert) {
            //In here, alerts are shown and they reload the Countries data from the API when tapping the "Retry" button.
            if sessionErrorResponse != "" {
                return Alert(title: Text("Error"), message: Text(sessionErrorResponse), dismissButton: Alert.Button.default(Text("Retry"), action: {loadCountriesMainData()}))
            }else{
                return Alert(title: Text("Internet"), message: Text("Please connect to the internet and try again"), dismissButton: Alert.Button.default(Text("Retry"), action: {loadCountriesMainData()}))
            }
        }
        .onAppear {
            //Here I show the TopMessage only if our UserDefaults item is nil. If not, then it means that the user already knows it's functionality.
            if UserDefaults.standard.object(forKey: "topMessage") == nil {
                withAnimation {
                    showTopMessage = true
                }
            }
            loadCountriesMainData()
        }
    }
    
    //This is the TopMessage View.
    var TopMessage:some View {
        VStack {
            Text("Welcome to Jiffy, please tap any desired country to get more information")
                .fontWeight(.semibold)
                .padding(10)
                .foregroundStyle(Color(.white))
        }
        .frame(maxWidth: .infinity)
        .padding(5)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color(.accent))
        )
        .padding(.horizontal, 15)
    }
    
    func loadCountriesMainData() {
        /*In here the Countries main data is loaded, which includes:
         - "Country Code"
         - "Country Name"
         - "Country Flag URL"
         */
        sessionErrorResponse = ""
        var request = URLRequest(url: webInfo.urlToLoad("/all"))
        request.httpMethod = "GET"
        let urlSession = URLSession(configuration: webInfo.generalUrlSessionConfiguration)
        urlSession.dataTask(with: request) { data, response, error in
            //Inside here we check that the URLSession returns data, otherwise we show an alert.
            guard let data = data, error == nil else {
                showErrorData(errorString: error?.localizedDescription)
                return
            }
            
            //Here we add the Data to our CountryDataStructMap. (For more info go to the CountryDataStructs file).
            if let countries = CountryDataStructMap(data) {
                DispatchQueue.main.async {
                    //We check that the array isn't empty. If it is, then we present an error alert. If not empty, then we continue and add our countries.
                    if !countries.countriesList.isEmpty {
                        countryObservable.countriesArray.append(contentsOf: countries.countriesList)
                        //Here I sort the countries by A-Z.
                        countryObservable.countriesArray.sort{
                            $0.countryName < $1.countryName
                        }
                        withAnimation {
                            loadingCountries = false
                        }
                    }else{
                        showErrorData(errorString: error?.localizedDescription)
                    }
                }
            }else{
                showErrorData(errorString: error?.localizedDescription)
            }
        }.resume()
    }
    
    func showErrorData(errorString:String?) {
        sessionErrorResponse = errorString ?? "Unable to load Country data, please try again"
        haptic(type: .error)
        showAlert = true
    }
}
