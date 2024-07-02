//
//  CountryObservable.swift
//  Country
//
//  Created by Charlie Pico on 29/06/24.
//

import SwiftUI

//This is our observableObject which is used through the entire App. It stores the Countries' data.
class CountryObservable:ObservableObject {
    @Published var countriesArray:[CountryDataStruct] = []
}
