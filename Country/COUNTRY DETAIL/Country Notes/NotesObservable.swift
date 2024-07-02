//
//  NotesObservable.swift
//  Country
//
//  Created by Charlie Pico on 30/06/24.
//

import SwiftUI

//This is our observableObject which is used when creating, deleting or updating notes. It stores the Notes' data.
class NotesObservable:ObservableObject {
    @Published var notesArray:[CountryNotesDataStruct] = []
}
