//
//  CountryNotesServer.swift
//  Country
//
//  Created by Charlie Pico on 30/06/24.
//

//Here are stored all the custom server endpoints and variables.
struct CountryNotesServer {
    private let iosUsername = "USERNAME"
    private let iosPassword = "PASSWORD"
    let mainURL = "https://www.barbapps.co/projects/countries"
    let loadNotes = "/load_notes.php"
    let insertNewNote = "/insert_note.php"
    let deleteNote = "/delete_note.php"
    let updateNote = "/update_note.php"
    
    //In here I encode the 'iosUsername' and 'iosPassword' together as data to get an encrypted result and use it as a key for the server to verify and allow access to the API.
    func getKey() -> String {
        let loginData = "\(iosUsername):\(iosPassword)".data(using: String.Encoding.utf8)!
        let serverKey = loginData.base64EncodedString()
        
        return serverKey
    }
}
