//
//  CountryNotesItems.swift
//  Country
//
//  Created by Charlie Pico on 01/07/24.
//

import SwiftUI

//This is the 'NoteViewCell' that displays the note's design and the delete note function.
struct NoteViewCell: View {
    @EnvironmentObject var notesObserved:NotesObservable
    @Binding var note:CountryNotesDataStruct
    @Binding var selectedNote:CountryNotesDataStruct?
    @Binding var showNoteOptions:Bool
    @Binding var deleteAction:Bool
    @Binding var deleteError:Bool
    @Binding var showAlert:Bool
    @Binding var editingNote:Bool
    @Binding var createNewNote:Bool
    @Binding var serverInfo:CountryNotesServer
    @Binding var webInfo:WebInformation
    
    var body:some View {
        VStack(alignment: .leading){
            Text(note.noteDescription)
                .multilineTextAlignment(.leading)
            HStack {
                Text(note.noteDate)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.trailing)
                Spacer()
                Button(action: {
                    impact(style: .soft)
                    selectedNote = note
                    showNoteOptions = true
                }, label: {
                    Image(systemName: "ellipsis.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                    //In here I present the user a '.confirmationDialog' to give the option to 'edit' or 'delete' a note.
                    .confirmationDialog("Please select an option".localized, isPresented: $showNoteOptions, actions: {
                        Button(action: {
                            editingNote = true
                            createNewNote = true
                        }) {
                            Text("Edit".localized)
                        }
                        Button(role: .destructive, action: {
                            haptic(type: .warning)
                            deleteAction = true
                        }) {
                            Text("Delete".localized)
                        }
                        Button(role: .cancel, action: {}) {
                            Text("Cancel".localized)
                        }
                    })
                })
                .buttonStyle(.borderless)
                .alert(isPresented: $deleteAction, content: {
                    return Alert(title: Text("Delete Note".localized), message: Text("Are you sure you want to delete this note?".localized), primaryButton: Alert.Button.destructive(Text("Yes".localized), action: {
                        //Here I remove the optional value of the note and send it's 'noteServerID' to the delete function. If not, an error is is shown (I use '.asyncAfter' to give the alert time to update, otherwise the error alert won't display).
                        guard let selNote = selectedNote else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                haptic(type: .error)
                                deleteError = true
                                showAlert = true
                            }
                            return
                        }
                        deleteNoteFunction(withID: selNote.noteServerID)
                    }), secondaryButton: Alert.Button.default(Text("No".localized)))
                })
            }
        }
    }
    
    func deleteNoteFunction(withID: Int) {
        var request = URLRequest(url: URL(string: serverInfo.mainURL.appending(serverInfo.deleteNote))!)
        
        /*
         Here I add the '.allHTTPHeaderFields' needed to connect to the server's API and receive information. I ask for an authentication key which is encrypted on device and compares to the encrypted 'String' on the server, if it matches, then the connection is created and allows the App to retreive information from the API. If it doesn't, it gives a server error.
         
         I use the keys:
            - "Authentication": To send the encrypted key and compare it with the one at the server.
            - "Id": To send the selectedNote's server id and delete it.
         */
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Authentication":"Basic \(serverInfo.getKey())","Id":"\(withID)"]
        
        let session = URLSession(configuration: webInfo.generalUrlSessionConfiguration)
        session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Error")
                return
            }
            
            let responseString = NSString.init(string: String.init(data: data, encoding: .utf8)!)
            if responseString.contains("deleted") {
                //In here I get the current note's index and use it to remove the note from the '.notesArray'.
                if let index = notesObserved.notesArray.firstIndex(where: {$0.noteServerID == withID}) {
                    DispatchQueue.main.async{
                        notesObserved.notesArray.remove(at: index)
                    }
                }
            }else{
                haptic(type: .error)
                deleteError = true
                showAlert = true
            }
        }.resume()
    }
}
