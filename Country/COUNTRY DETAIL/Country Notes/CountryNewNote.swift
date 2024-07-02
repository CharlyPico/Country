//
//  CountryNewNote.swift
//  Country
//
//  Created by Charlie Pico on 30/06/24.
//

import SwiftUI

struct CountryNewNote: View {
    @EnvironmentObject var notesObserved:NotesObservable
    
    @Binding var selectedCountry:CountryDataStruct
    
    //This variable helps the view to dismiss when the note has finished updating/being created.
    @Binding var createNewNote:Bool
    @Binding var newNoteError:Bool
    @Binding var showAlert:Bool
    @Binding var deleteError:Bool
    
    //This variables help the App detect if the user is updating an existing note or creating a new one.
    @Binding var editingNote:Bool
    @Binding var selectedNote:CountryNotesDataStruct?
    
    @Binding var serverInfo:CountryNotesServer
    @Binding var webInfo:WebInformation
    
    @State var noteText = "Write your new note here...".localized
    @State var dateFormatter = DateFormatter()
    @State var selectedNoteID:Int = 0
    
    //Here I created this variable that helps us hide items while posting/updating a new note.
    @State var postingNote = false
    
    var body: some View {
        VStack {
            //Here I separated the NewNoteButtons item to an external View. This helps keeping things understandable, easy to navigate and organized.
            NewNoteButtons
                .padding(15)
            List {
                //Here I separated the NewNoteTextEditor item to an external View. This helps keeping things understandable, easy to navigate and organized.
                NewNoteTextEditor
            }
        }
        .onAppear {
            deleteError = false
            dateFormatter.timeZone = NSTimeZone.local
            dateFormatter.locale = Locale.init(identifier: "en_US")
            dateFormatter.dateFormat = "yyyy-MM-dd"
        }
    }
    
    //Here are the 'Cancel' 'Top Title' 'Update/Create' buttons.
    var NewNoteButtons:some View {
        HStack(alignment: .center) {
            Button(action: {createNewNote = false}, label: {
                Text(postingNote ? "":"Cancel")
                    .foregroundStyle(.red)
            })
            .disabled(postingNote)
            Spacer()
            Text("New Note")
                .foregroundStyle(.primary)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            Spacer()
            Button(action: {postNewNote()}, label: {
                if postingNote {
                    ProgressView()
                        .progressViewStyle(.circular)
                }else{
                    Text(editingNote ? "Update":"Register")
                        .fontWeight(.semibold)
                        .foregroundStyle(.accent)
                        .opacity((noteText.count == 0 || noteText == "Write your new note here...".localized) ? 0.5:1.0)
                }
            })
            .disabled((postingNote || noteText.count == 0 || noteText == "Write your new note here...".localized) ? true:false)
        }
    }
    
    //This is a 'TextEditor' that allows the user update/write a note with multiple lines.
    var NewNoteTextEditor:some View {
        TextEditor(text: $noteText)
            .frame(minHeight: 50)
            .padding(10)
            .foregroundStyle(noteText == "Write your new note here...".localized ? .secondary:.primary)
            .tint(.primary)
            .scrollContentBackground(.hidden)
            .listRowSeparator(.hidden)
            .onTapGesture {
                //I desided to add this 'if' because the TextEditor has no 'Placeholder', so this mimics a placeholder text by removing the "placeholder" text when starting to edit the field.
                if noteText == "Write your new note here...".localized {
                    noteText = ""
                }
            }
            .onAppear {
                //Here I check if the optional 'selectedNote' variable is not nil. If it is, then it means that the user is creating a new note.
                if let selNote = selectedNote {
                    noteText = selNote.noteDescription
                    selectedNoteID = selNote.noteServerID
                }else{
                    noteText = "Write your new note here...".localized
                }
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
    
    func postNewNote()
    {
        //Here we update/create a new note in the server. I send the values ('columnAndValues') of the note as 'httpBody' because the 'httpHeader' messes around with multiline texts and 'httpBody' respects them.
        postingNote = true
        let columnAndValues = editingNote ? "\(noteText)":"(\(0),'\(selectedCountry.countryCode)','\(noteText)','\(dateFormatter.string(from: Date()))')"
        var request = URLRequest(url: URL(string: serverInfo.mainURL.appending(editingNote ? serverInfo.updateNote:serverInfo.insertNewNote))!)
        request.httpMethod = "POST"
        /*
         Here I add the '.allHTTPHeaderFields' needed to connect to the server's API and receive information. I ask for an authentication key which is encrypted on device and compares to the encrypted 'String' on the server, if it matches, then the connection is created and allows the App to retreive information from the API. If it doesn't, it gives a server error.
        
         TO UPDATE
         I use the keys:
            - "Authentication": To send the encrypted key and compare it with the one at the server.
            - "Id": To send the selectedNote's server id.
         
         TO CREATE
         I use the keys:
            - "Authentication": To send the encrypted key and compare it with the one at the server.
         */
        request.allHTTPHeaderFields = editingNote ? ["Authentication":"Basic \(serverInfo.getKey())","Id":"\(selectedNoteID)"]:["Authentication":"Basic \(serverInfo.getKey())"]
        request.httpBody = columnAndValues.data(using: .utf8)
        
        let session = URLSession(configuration: webInfo.generalUrlSessionConfiguration)
        session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Error")
                return
            }
            let responseString = NSString.init(string: String.init(data: data, encoding: .utf8)!)
            if responseString != "error" {
                newNoteError = false
                dateFormatter.dateFormat = "dd MMM yyyy"
                DispatchQueue.main.async {
                    //Here I compare if the user is editing a note or not. If it is, then we just update the note's value with the new text. If not, then we create the new note, add it to the notes array and the sort it by 'noteServerID' so the newest is always on top.
                    if editingNote {
                        if let index = notesObserved.notesArray.firstIndex(where: {$0.noteServerID == selectedNoteID}) {
                            notesObserved.notesArray[index].noteDescription = noteText
                        }
                    }else{
                        //In here I have to use a '.replacingOccurrences' because the 'serverID' response from the PHP file was also returning a \r line break (cause I am not a PHP savy so I'm not sure why).
                        notesObserved.notesArray.append(CountryNotesDataStruct(noteServerID: NSString(string: responseString.replacingOccurrences(of: "\\r", with: "")).integerValue, noteCountryCode: selectedCountry.countryCode, noteDescription: noteText, noteDate: dateFormatter.string(from: Date())))
                        notesObserved.notesArray.sort{
                            $0.noteServerID > $1.noteServerID
                        }
                    }
                }
                haptic(type: .success)
                createNewNote = false
            }else{
                createNewNote = false
                newNoteError = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    haptic(type: .error)
                    showAlert = true
                }
            }
        }.resume()
    }
}
