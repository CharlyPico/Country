//
//  CountryDetailDataStructs.swift
//  Country
//
//  Created by Charlie Pico on 29/06/24.
//

import SwiftUI

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
    
    init(countryOfficialName: String, countryFlagDescription: String, countryCapitalCity: [String], countryRegion: String, countrySubRegion:String, countryLanguages: [String:Any], countryLanguagesString:String, countryMainCurrency: [String:Any], countryTotalPopulation: Int64, countryCallingCode: String, countryClosestBorders: [String]) {
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
    }
    
    init(_ dictionary:[String:Any]) {
        countryOfficialName = (dictionary["name"] as? [String:Any])?["official"] as? String ?? "No name".localized
        countryFlagDescription = (dictionary["flags"] as? [String:Any])?["alt"] as? String ?? "No flag information".localized
        countryCapitalCity = dictionary["capital"] as? [String] ?? []
        countryRegion = dictionary["region"] as? String ?? "No region".localized
        countrySubRegion = dictionary["subregion"] as? String ?? "No subregion".localized
        countryLanguages = dictionary["languages"] as? [String:Any] ?? ["":""]
        countryLanguagesString = "No language".localized
        countryMainCurrency = dictionary["currencies"] as? [String:Any] ?? ["":""]
        countryTotalPopulation = dictionary["population"] as? Int64 ?? 0
        countryCallingCode = (dictionary["idd"] as? [String:Any])?["root"] as? String ?? "No calling code".localized
        countryClosestBorders = dictionary["borders"] as? [String] ?? []
    }
}

struct CountryDetailStructMap {
    let countryDetailArray:[CountryDataDetailStruct]
    init?(_ data:Data) {
        guard let array = (try? JSONSerialization.jsonObject(with: data)) as? [[String:Any]] else {return nil}
        countryDetailArray = array.map(CountryDataDetailStruct.init)
    }
}
