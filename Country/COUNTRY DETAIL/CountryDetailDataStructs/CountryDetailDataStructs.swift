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
    var countryCapitalCity:String
    var countryRegion:String
    var countryLanguage:String
    var countryMainCurrency:[String:Any]
    var countryTotalPopulation:Int64
    var countryCode:String
    var countryCallingCode:String
    var countryClosestBorders:[String]
    
    init(countryOfficialName: String, countryFlagDescription: String, countryCapitalCity: String, countryRegion: String, countryLanguage: String, countryMainCurrency: [String:Any], countryTotalPopulation: Int64, countryCode: String, countryCallingCode: String, countryClosestBorders: [String]) {
        self.countryOfficialName = countryOfficialName
        self.countryFlagDescription = countryFlagDescription
        self.countryCapitalCity = countryCapitalCity
        self.countryRegion = countryRegion
        self.countryLanguage = countryLanguage
        self.countryMainCurrency = countryMainCurrency
        self.countryTotalPopulation = countryTotalPopulation
        self.countryCode = countryCode
        self.countryCallingCode = countryCallingCode
        self.countryClosestBorders = countryClosestBorders
    }
    
    init?(array:[Any]) {
        guard array.count == 10 else {return nil}
        
        countryOfficialName = array[0] as? String ?? ""
        countryFlagDescription = array[1] as? String ?? ""
        countryCapitalCity = array[2] as? String ?? ""
        countryRegion = array[3] as? String ?? ""
        countryLanguage = array[4] as? String ?? ""
        countryMainCurrency = array[5] as? [String:Any] ?? ["":""]
        countryTotalPopulation = array[6] as? Int64 ?? 0
        countryCode = array[7] as? String ?? ""
        countryCallingCode = array[8] as? String ?? ""
        countryClosestBorders = array[9] as? [String] ?? []
    }
}
