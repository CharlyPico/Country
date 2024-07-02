//
//  CountryDataStructs.swift
//  Country
//
//  Created by Charlie Pico on 29/06/24.
//

import SwiftUI

//Here is the main CountryDataStruct that organizes the main Countries API data. By creating this struct, the main CountryView code is cleaner and easier to navigate.
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
    
    //In this init dictionary, the API data is organized between our variables depending on the API JSON response's key we receive.
    init(_ dictionary:[String:Any]) {
        countryCode = dictionary["cca3"] as? String ?? ""
        countryName = (dictionary["name"] as? [String:Any])?["common"] as? String ?? ""
        countryFlag = (dictionary["flags"] as? [String:Any])?["png"] as? String ?? ""
        countryDetails = dictionary["countryDetails"] as? CountryDataDetailStruct ?? nil
    }
}

//This is the CountryDataStructMap, which helps getting the API info stored as a CountryDataStruct object and stores it inside an array for the App to pass to the observableObject's main Array.
struct CountryDataStructMap {
    let countriesList:[CountryDataStruct]
    init?(_ data:Data) {
        guard let array = (try? JSONSerialization.jsonObject(with: data)) as? [[String:Any]] else {return nil}
        countriesList = array.map(CountryDataStruct.init)
    }
}
