//
//  CountryNotes.swift
//  Country
//
//  Created by Charlie Pico on 30/06/24.
//

import SwiftUI

struct CountryNotes: View {
    let countryServer = CountryNotesServer()
    var body: some View {
        List {
            Text("To create a new note, tap the navigation + icon.")
        }
        .navigationTitle("County Notes")
        .toolbar {
            Button(action: {
                createNewNote = true
            }, label: {
                Image(systemName: "")
            })
        }
    }
}
