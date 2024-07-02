//
//  CountryDetailDataStructs.swift
//  Country
//
//  Created by Charlie Pico on 29/06/24.
//

import SwiftUI
import SafariServices
import WebKit

//Here is the CountryDataDetailStruct that organizes the main Countries' Detail API data. By creating this struct, the CountryDetail's code is cleaner and easier to navigate.
struct CountryDataDetailStruct:Identifiable {
    let id = UUID()
    var countryOfficialName:String
    var countryFlagDescription:String
    var countryCapitalCity:[String]
    var countryRegion:String
    var countrySubRegion:String
    var countryLanguages:[String:Any]
    var countryLanguagesString:String
    var countryMainCurrency:[String:Any]
    var countryTotalPopulation:Int64
    var countryCallingCode:String
    var countryClosestBorders:[String]
    var countryGoogleMapsURLString:String
    
    init(countryOfficialName: String, countryFlagDescription: String, countryCapitalCity: [String], countryRegion: String, countrySubRegion:String, countryLanguages: [String:Any], countryLanguagesString:String, countryMainCurrency: [String:Any], countryTotalPopulation: Int64, countryCallingCode: String, countryClosestBorders: [String], countryGoogleMapsURLString:String) {
        self.countryOfficialName = countryOfficialName
        self.countryFlagDescription = countryFlagDescription
        self.countryCapitalCity = countryCapitalCity
        self.countryRegion = countryRegion
        self.countrySubRegion = countrySubRegion
        self.countryLanguages = countryLanguages
        self.countryLanguagesString = countryLanguagesString
        self.countryMainCurrency = countryMainCurrency
        self.countryTotalPopulation = countryTotalPopulation
        self.countryCallingCode = countryCallingCode
        self.countryClosestBorders = countryClosestBorders
        self.countryGoogleMapsURLString = countryGoogleMapsURLString
    }
    
    //In this init dictionary, the API data is organized between our variables depending on the API JSON response's key we receive.
    init(_ dictionary:[String:Any]) {
        countryOfficialName = (dictionary["name"] as? [String:Any])?["official"] as? String ?? "No name"
        countryFlagDescription = (dictionary["flags"] as? [String:Any])?["alt"] as? String ?? "No flag information"
        countryCapitalCity = dictionary["capital"] as? [String] ?? []
        countryRegion = dictionary["region"] as? String ?? "No region"
        countrySubRegion = dictionary["subregion"] as? String ?? "No subregion"
        countryLanguages = dictionary["languages"] as? [String:Any] ?? ["":""]
        countryLanguagesString = "No language"
        countryMainCurrency = dictionary["currencies"] as? [String:Any] ?? ["":""]
        countryTotalPopulation = dictionary["population"] as? Int64 ?? 0
        countryCallingCode = (dictionary["idd"] as? [String:Any])?["root"] as? String ?? "No calling code"
        countryClosestBorders = dictionary["borders"] as? [String] ?? []
        countryGoogleMapsURLString = (dictionary["maps"] as? [String:Any])?["googleMaps"] as? String ?? ""
    }
}

//This is the CountryDetailStructMap, which helps getting the API info stored as a CountryDataDetailStruct object and stores it inside an array for the App to pass to the observableObject's main Array.
struct CountryDetailStructMap {
    let countryDetailArray:[CountryDataDetailStruct]
    init?(_ data:Data) {
        guard let array = (try? JSONSerialization.jsonObject(with: data)) as? [[String:Any]] else {return nil}
        countryDetailArray = array.map(CountryDataDetailStruct.init)
    }
}
