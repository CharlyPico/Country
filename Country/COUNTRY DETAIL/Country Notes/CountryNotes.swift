//
//  CountryNotes.swift
//  Country
//
//  Created by Charlie Pico on 30/06/24.
//

import SwiftUI

struct CountryNotes: View {
    //Here I implemented the '.presentationMode' that allows the App to go to the previous view if the Map doesn't load.
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    //We call this environmentObject to store our notes into an array.
    @EnvironmentObject var notesObserved:NotesObservable
    
    @State var editingNote = false
    @State var createNewNote = false
    @State var gettingNotes = true
    @State var newNoteError = false
    @State var showAlert = false
    @State var deleteError = false
    @State var showNoteOptions = false
    @State var deleteAction = false
    @State var loadingMoreNotes = false
    
    //This 'selectedNote' variable helps us understand if the user selected to edit a note or not.
    @State var selectedNote:CountryNotesDataStruct?
    
    //This 2 variables helps the App load just 10 Notes from the server and loads 5 more as the user progresses through the List.
    @State var currentNoteStart = 0
    @State var currentNoteLimit = 10
    
    //With this variable we get our custom server endpoints.
    @State var serverInfo = CountryNotesServer()
    
    //Here the App gets the previous view's 'selectedCountry' so it loads only the selected country's notes.
    @Binding var selectedCountry:CountryDataStruct
    @Binding var webInfo:WebInformation
    
    var body: some View {
        List {
            //Here I check if the observedObject's '.notesArray' has items inside or not. This is for the App to show a "Loading" state to the user.
            if notesObserved.notesArray.isEmpty {
                if gettingNotes {
                    Text("Loading notes, please wait...")
                }else{
                    //We present the 'NoNotesView' if there are no notes for the selected country.
                    NoNotesView
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            ForEach($notesObserved.notesArray, id: \.id) { note in
                Section {
                    //Here I separated the NoteViewCell item to an external struct. This helps keeping things understandable, easy to navigate and organized (for more info please go to the CountryNotesItems file).
                    NoteViewCell(note: note, selectedNote: $selectedNote, showNoteOptions: $showNoteOptions, deleteAction: $deleteAction, deleteError: $deleteError, showAlert: $showAlert, editingNote: $editingNote, createNewNote: $createNewNote, serverInfo: $serverInfo, webInfo: $webInfo)
                        .environmentObject(notesObserved)
                    .onAppear{
                        //In here, I check if the last item has loaded and calls the 'getNotes' function to load 5 more notes.
                        if let lastItem = notesObserved.notesArray.last {
                            if lastItem.noteServerID == note.noteServerID.wrappedValue && !loadingMoreNotes{
                                //Up here, I use the '!loadingMoreNotes' so the App doesn't call the 'getNotes' function like crazy.
                                print("Loading More notes")
                                loadingMoreNotes = true
                                currentNoteStart = notesObserved.notesArray.count
                                currentNoteLimit = notesObserved.notesArray.count + 5
                                getNotes()
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Country Notes")
        .toolbar {
            Button(action: {
                editingNote = false
                selectedNote = nil
                createNewNote = true
            }, label: {
                if gettingNotes {
                    ProgressView()
                        .progressViewStyle(.circular)
                }else{
                    Image(systemName: "plus")
                }
            })
            //Here we disable the new note toolbar button until the App finishes loading the notes.
            .disabled(gettingNotes)
        }
        //Here a '.fullScreenCover' presents the 'CountryNewNote' view to create new notes.
        .fullScreenCover(isPresented: $createNewNote, content: {
            CountryNewNote(selectedCountry: $selectedCountry, createNewNote: $createNewNote, newNoteError: $newNoteError, showAlert: $showAlert, deleteError: $deleteError, editingNote: $editingNote, selectedNote: $selectedNote, serverInfo: $serverInfo, webInfo: $webInfo)
                .environmentObject(notesObserved)
        })
        .alert(isPresented: $showAlert) {
            if deleteError {
                return Alert(title: Text("Deletion Error"), message: Text("Unable to delete note, please try again"), dismissButton: Alert.Button.default(Text("Ok")))
            }else if !webInfo.isInternetAvailable() {
                return Alert(title: Text("Internet"), message: Text("Please connect to the internet and try again"), dismissButton: Alert.Button.default(Text("Retry"), action: {getNotes()}))
            }else{
                return Alert(title: Text("Connection"), message: Text("Unable to retreive notes, please try again"), dismissButton: Alert.Button.default(Text("Retry"), action: {getNotes()}))
            }
        }
        .onAppear {
            getNotes()
        }
    }
    
    var NoNotesView:some View {
        VStack {
            (Text("You haven't created any notes. To Create a new note, tap the") + Text(" + ") + Text("icon."))
                .fontWeight(.semibold)
                .padding(10)
                .foregroundStyle(Color(.white))
        }
        .frame(maxWidth: .infinity)
        .padding(5)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color(.accent))
        )
    }
    
    func getNotes()
    {
        //Here I call the custom server's API to load the user's notes per selected country.
        if !webInfo.isInternetAvailable() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                haptic(type: .error)
                showAlert = true
            }
            return
        }
        var request = URLRequest(url: URL(string: serverInfo.mainURL.appending(serverInfo.loadNotes))!)
        request.httpMethod = "GET"
        /*
         Here I add the '.allHTTPHeaderFields' needed to connect to the server's API and receive information. I ask for an authentication key which is encrypted on device and compares to the encrypted 'String' on the server, if it matches, then the connection is created and allows the App to retreive information from the API. If it doesn't, it gives a server error.
        
         Here I use the keys:
            - "Authentication": To send the encrypted key and compare it with the one at the server.
            - "Ccode": To send the Country Code and retreive only it's corresponding notes.
            - "Start": This sets the start item in server, so it doesn't load more items than needed.
            - "Limit": This sets the limit item in server, so it doesn't load more items than needed.
         */
        request.allHTTPHeaderFields = ["Authentication":"Basic \(serverInfo.getKey())","Ccode":"\(selectedCountry.countryCode.uppercased())","Start":"\(currentNoteStart)","Limit":"\(currentNoteLimit)"]
        
        let session = URLSession(configuration: webInfo.generalUrlSessionConfiguration)
        session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Error")
                return
            }
            
            if let notes = CountryNotesMap(data) {
                DispatchQueue.main.async {
                    withAnimation {
                        if !notes.notesArray.isEmpty {
                            notesObserved.notesArray.append(contentsOf: notes.notesArray)
                            loadingMoreNotes = false
                        }
                        
                        //In here we do not set 'loadingMoreNotes' to TRUE so it doesn't keep calling the 'getNotes' when showing the final note in the List and trying to load 5 more notes from the server.
                        gettingNotes = false
                    }
                }
            }else{
                deleteError = false
                withAnimation {
                    gettingNotes = false
                }
                haptic(type: .error)
                showAlert = true
            }
        }.resume()
    }
}
