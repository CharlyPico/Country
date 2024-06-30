//
//  CountryDetail.swift
//  Country
//
//  Created by Charlie Pico on 29/06/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct CountryDetail: View {
    @EnvironmentObject var countryObservable:CountryObservable
    @Binding var selectedCountry:CountryDataStruct
    @Binding var showTopMessage:Bool
    @Binding var webInfo:WebInformation
    @Binding var device:UIUserInterfaceIdiom
    
    @State var showAlert = false
    @State var sessionErrorResponse = ""
    
    @State var sectionsArray:[CountryDetailSectionsData] = []
    
    var body:some View {
        ZStack {
            if !sectionsArray.isEmpty {
                List {
                    ForEach(sectionsArray, id: \.id) { indSection in
                        Section {
                            ForEach(indSection.sectionItems, id: \.id) { sectItem in
                                switch sectItem.subsectionType {
                                case .Image:
                                    ListImageSection(sectItem: sectItem, device: $device)
                                case .Text:
                                    ListTextSection(sectItem: sectItem)
                                case .TextSpecialIcon:
                                    ListTextSpecialIconSection(sectItem: sectItem)
                                }
                            }
                        }header: {
                            if indSection.sectionName != "" {
                                Text(indSection.sectionName)
                            }
                        }
                    }
                }
            }else{
                if sessionErrorResponse != "" {
                    VStack(spacing: 5){
                        Text("Unable to load Country data, please try again".localized)
                        Button(action: {
                            loadDetailInformation()
                        }, label: {
                            Text("Reload".localized)
                                .padding(5)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(.secondary)
                                )
                        })
                    }
                }else{
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
        }
        .navigationTitle(selectedCountry.countryName)
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showAlert) {
            if sessionErrorResponse != "" {
                return Alert(title: Text("Error".localized), message: Text(sessionErrorResponse), dismissButton: Alert.Button.default(Text("Ok".localized)))
            }else{
                return Alert(title: Text("Internet".localized), message: Text("Please connect to the internet and try again".localized), dismissButton: Alert.Button.default(Text("Ok".localized)))
            }
        }
        .onAppear {
            showTopMessage = false
            guard let _ = selectedCountry.countryDetails else {
                print("Load detail")
                loadDetailInformation()
                return
            }
            print("Info already downloaded")
            setDetailList()
            return
        }
    }
    
    func loadDetailInformation()
    {
        sessionErrorResponse = ""
        var request = URLRequest(url: webInfo.urlToLoad("/alpha?codes=\(selectedCountry.countryCode)"))
        request.httpMethod = "GET"
        let urlSession = URLSession(configuration: webInfo.generalUrlSessionConfiguration)
        urlSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                showErrorData(errorString: error?.localizedDescription)
                return
            }
            if let detailData = CountryDetailStructMap(data) {
                DispatchQueue.main.async {
                    if !detailData.countryDetailArray.isEmpty {
                        selectedCountry.countryDetails = detailData.countryDetailArray.first
                        if let details = selectedCountry.countryDetails {
                            var provArr:[String] = []
                            for(_, value) in details.countryLanguages {
                                provArr.append(value as? String ?? "")
                            }
                            selectedCountry.countryDetails?.countryLanguagesString = provArr.joined(separator: ", ")
                            
                            for(_, value) in details.countryMainCurrency {
                                selectedCountry.countryDetails?.countryMainCurrency = value as? [String:Any] ?? ["":""]
                                break
                            }
                            
                            for (index, border) in details.countryClosestBorders.enumerated() {
                                if let borderCountryName = countryObservable.countriesArray.first(where: {$0.countryCode == border})?.countryName {
                                    selectedCountry.countryDetails?.countryClosestBorders[index] = borderCountryName
                                }
                            }
                            
                            setDetailList()
                        }else{
                            showErrorData(errorString: error?.localizedDescription)
                        }
                    }else{
                        showErrorData(errorString: error?.localizedDescription)
                        return
                    }
                }
            }
        }.resume()
    }
    
    func setDetailList() {
        let detailSection = CountryDetailSectionsClass(selectedCountry: $selectedCountry, sectionsArray: $sectionsArray)
        detailSection.addListSections()
    }
    
    func showErrorData(errorString:String?) {
        sessionErrorResponse = errorString ?? "Unable to load Country data, please try again".localized
        showAlert = true
    }
}
