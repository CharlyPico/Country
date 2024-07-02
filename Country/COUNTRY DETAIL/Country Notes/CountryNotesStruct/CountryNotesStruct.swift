//
//  CountryNotesStruct.swift
//  Country
//
//  Created by Charlie Pico on 30/06/24.
//

import Foundation

//Here is the CountryNotesDataStruct that organizes the additional Custom Server (Notes) API data. By creating this struct, the CountryNotes code is cleaner and easier to navigate.
struct CountryNotesDataStruct:Identifiable {
    let id = UUID()
    var noteServerID:Int
    var noteCountryCode:String
    var noteDescription:String
    var noteDate:String
    
    init(noteServerID: Int, noteCountryCode: String, noteDescription: String, noteDate: String) {
        self.noteServerID = noteServerID
        self.noteCountryCode = noteCountryCode
        self.noteDescription = noteDescription
        self.noteDate = noteDate
    }
    
    //In this init dictionary, the API data is organized between our variables depending on the API JSON response's key we receive.
    init(_ dictionary:[String:Any]) {
        //As the Note's date is stored with yyyy-MM-dd date format, we receive the Data's date and change it to a more pleasing one, storing it in 'noteDate'.
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.locale = Locale.init(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd"//"dd MMM yyyy"
        
        let dateFormatterEnd = DateFormatter()
        dateFormatterEnd.timeZone = NSTimeZone.local
        dateFormatterEnd.locale = Locale.init(identifier: "en_US")
        dateFormatterEnd.dateFormat = "dd MMM yyyy"
        
        noteServerID = (dictionary["note_id"] as? NSString)?.integerValue ?? 0
        noteCountryCode = dictionary["note_country_code"] as? String ?? ""
        noteDescription = dictionary["note_description"] as? String ?? ""
        noteDate = dateFormatterEnd.string(from: dateFormatter.date(from: dictionary["note_date"] as? String ?? "1995-02-25")!)
    }
}

//This is the CountryNotesMap, which helps getting the API info stored as a CountryNotesDataStruct object and stores it inside an array for the App to pass to the Note's observableObject Array.
struct CountryNotesMap {
    let notesArray:[CountryNotesDataStruct]
    init?(_ data:Data) {
        guard let array = (try? JSONSerialization.jsonObject(with: data)) as? [[String:Any]] else {return nil}
        notesArray = array.map(CountryNotesDataStruct.init)
    }
}
