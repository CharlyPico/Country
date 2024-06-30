//
//  CountryObservable.swift
//  Country
//
//  Created by Charlie Pico on 29/06/24.
//

import SwiftUI

class CountryObservable:ObservableObject {
    @Published var countriesArray:[CountryDataStruct] = []
}
