//
//  CountryViewStructs.swift
//  Country
//
//  Created by Charlie Pico on 29/06/24.
//

import SwiftUI

struct CountryDataStruct:Identifiable {
    let id = UUID()
    var countryCode:String
    var countryName:String
    var countryFlag:String
    var countryDetails:CountryDataDetailStruct?
    
    init(countryCode: String, countryName: String, countryFlag: String, countryDetails:CountryDataDetailStruct?) {
        self.countryCode = countryCode
        self.countryName = countryName
        self.countryFlag = countryFlag
        self.countryDetails = countryDetails
    }
    
    init(_ dictionary:[String:Any]) {
        countryCode = dictionary["cca3"] as? String ?? ""
        countryName = (dictionary["name"] as? [String:Any])?["common"] as? String ?? ""
        countryFlag = (dictionary["flags"] as? [String:Any])?["png"] as? String ?? ""
        countryDetails = dictionary["countryDetails"] as? CountryDataDetailStruct ?? nil
    }
}

struct CountryDataStructMap {
    let countriesList:[CountryDataStruct]
    init?(_ data:Data) {
        guard let array = (try? JSONSerialization.jsonObject(with: data)) as? [[String:Any]] else {return nil}
        countriesList = array.map(CountryDataStruct.init)
    }
}
