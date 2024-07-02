//
//  CountryDetail.swift
//  Country
//
//  Created by Charlie Pico on 29/06/24.
//

import SwiftUI
import SDWebImageSwiftUI
import SafariServices

/*Here is the CountryDetail view, which shows the selected country's detail data. In here I've chosen to present:
        Section 1
        - Country Flag
        - Country Flag's description
 
        Section 2
        - Country Common name
        - Country Official name
        - Country Capital city
 
        Section 3
        - Country Region
        - Country Subregion
        - Country Languages
        - Country Currencies
        
        Section 4
        - Country Population
        - Country Code
        - Country Calling code
        - Country Closest borders
 
 I also added a Map button to the top, and as an extra I've implemented a custom server service that allows the user to create, edit or delete notes per Country.
 */
struct CountryDetail: View {
    let notesObserved = NotesObservable()
    @EnvironmentObject var countryObservable:CountryObservable
    
    @Binding var selectedCountry:CountryDataStruct
    @Binding var showTopMessage:Bool
    @Binding var webInfo:WebInformation
    @Binding var device:UIUserInterfaceIdiom
    
    @State var showTopTips = false
    @State var showAlert = false
    @State var sessionErrorResponse = ""
    
    //This variable is our sections array. In here we created each section with it's items (for more info head to the CountryDetailSectionsData file).
    @State var sectionsArray:[CountryDetailSectionsData] = []
    
    var body:some View {
        VStack {
            if sectionsArray.isEmpty {
                ProgressView()
                    .progressViewStyle(.circular)
                    .padding(.top, 15)
                Spacer()
            }else{
                List {
                    if showTopTips {
                        //Here I separated the TopTips item to an external View. This helps keeping things understandable, easy to navigate and organized.
                        TopTips
                            .opacity(sectionsArray.isEmpty ? 0.0:1.0)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                    
                    //Here we call a ForEach to handle and present every section we created that displays the country's information.
                    ForEach(sectionsArray, id: \.id) { indSection in
                        Section {
                            //Here we call again a ForEach, but this time is to get each item inside each section we retrieved earlier. Then I categorize them inside a switch using our SectionsType enum (for more info head to the CountryDetailSectionsData file). I also separated each item into external structs.
                            ForEach(indSection.sectionItems, id: \.id) { sectItem in
                                switch sectItem.subsectionType {
                                case .Image:
                                    ListImageSection(sectItem: sectItem, device: $device)
                                case .Text:
                                    ListTextSection(sectItem: sectItem)
                                case .TextSpecialIcon:
                                    ListTextSpecialIconSection(sectItem: sectItem)
                                }
                            }
                        }header: {
                            //Here we set our section's title name, I implemented this 'if' because the first section doesn't have a title. So we don't need to add a 'Text' to our section's header.
                            if indSection.sectionName != "" {
                                Text(indSection.sectionName)
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color(.systemGroupedBackground)
        )
        .navigationTitle(selectedCountry.countryName)
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showAlert) {
            //In here, alerts are shown and they reload the Countrie's detail data from the API when tapping the "Retry" button.
            if sessionErrorResponse != "" {
                return Alert(title: Text("Error"), message: Text(sessionErrorResponse), dismissButton: Alert.Button.default(Text("Retry"), action: {loadDetailInformation()}))
            }else{
                return Alert(title: Text("Internet"), message: Text("Please connect to the internet and try again"), dismissButton: Alert.Button.default(Text("Retry"), action: {loadDetailInformation()}))
            }
        }
        .toolbar {
            //Here we display our toolbar items only if the sections array are ready to present. This way we don't add any unusable buttons when we don't have the Country's detail information.
            if !sectionsArray.isEmpty {
                NavigationLink {
                    CountryMap(selectedCountry: $selectedCountry)
                } label: {
                    Image(systemName: "map.fill")
                }
                .simultaneousGesture(
                    //I added a simultaneousGesture to the Navigation to set the TopTips UserDefaults so it doesn't show every time the user navigates to this section.
                    TapGesture()
                        .onEnded({ _ in
                            showTopTips = false
                            UserDefaults.standard.setValue(false, forKey: "topTips")
                        })
                )
                NavigationLink {
                    CountryNotes(selectedCountry: $selectedCountry, webInfo: $webInfo)
                        .environmentObject(notesObserved)
                } label: {
                    Image(systemName: "note.text")
                }
                .simultaneousGesture(
                    //I added a simultaneousGesture to the Navigation to set the TopTips UserDefaults so it doesn't show every time the user navigates to this section.
                    TapGesture()
                        .onEnded({ _ in
                            showTopTips = false
                            UserDefaults.standard.setValue(false, forKey: "topTips")
                        })
                )
            }
        }
        .onAppear {
            //Here I remove all our notesArray's notes, so when the user navigates to the Notes section again, all notes are loaded.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                notesObserved.notesArray.removeAll()
            }
            //Here I show the TopTips only if our UserDefaults item is nil. If not, then it means that the user already knows it's functionality.
            if UserDefaults.standard.object(forKey: "topTips") == nil {
                withAnimation {
                    showTopTips = true
                }
            }
            showTopMessage = false
            //In here, I check if the selected country has been selected before. This way it doesn't use the user's network to reload the same information and makes the App load faster. If the info is already loaded, then we just set our List's information. If not, it loads the 'loadDetailInformation()'.
            guard let _ = selectedCountry.countryDetails else {
                print("Load detail")
                loadDetailInformation()
                return
            }
            
            if sectionsArray.isEmpty {
                setDetailList()
            }
            return
        }
    }
    
    var TopTips:some View {
        VStack {
            (Text("Access the Google Maps map ") + Text(Image(systemName: "map.fill")) + Text(" and Notes ") + Text(Image(systemName: "note.text")) + Text(" by tapping the navigation buttons."))
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
    
    func loadDetailInformation()
    {
        //Here I load all the information that corresponds to the selected Country. I use the "country code" to load the information from the API.
        sessionErrorResponse = ""
        var request = URLRequest(url: webInfo.urlToLoad("/alpha?codes=\(selectedCountry.countryCode)"))
        request.httpMethod = "GET"
        let urlSession = URLSession(configuration: webInfo.generalUrlSessionConfiguration)
        urlSession.dataTask(with: request) { data, response, error in
            //Inside here we check that the URLSession returns data, otherwise we show an alert.
            guard let data = data, error == nil else {
                showErrorData(errorString: error?.localizedDescription)
                return
            }
            
            //Here we add the Data to our CountryDetailStructMap. (For more info go to the CountryDetailDataStructs file).
            if let detailData = CountryDetailStructMap(data) {
                DispatchQueue.main.async {
                    //We check that the array isn't empty. If it is, then we present an error alert. If not empty, then we continue and add our countries.
                    if !detailData.countryDetailArray.isEmpty {
                        //As I learned from the API that the country's details are stored as a single element inside an Array, I called '.first' on the array to obtain it's first element's data and set it as our country's details.
                        selectedCountry.countryDetails = detailData.countryDetailArray.first
                        
                        //We remove the 'optional' state of our country details.
                        if let details = selectedCountry.countryDetails {
                            //Now, this part is important to understand. As the API doesn't provide a KEY information about the country's 'languages' and 'currencies' key's for me to compare, I had to get the dictionary's elements and store the values into '.countruLanguages' and '.countryMainCurrency' arrays.
                            var provArr:[String] = []
                            for(_, value) in details.countryLanguages {
                                provArr.append(value as? String ?? "")
                            }
                            selectedCountry.countryDetails?.countryLanguagesString = provArr.joined(separator: ", ")
                            
                            for(_, value) in details.countryMainCurrency {
                                selectedCountry.countryDetails?.countryMainCurrency = value as? [String:Any] ?? ["":""]
                                break
                            }
                            //Here ends the previous mentioned iteration.
                            
                            //In this next 'for' we compare the '.countryClosestBorders' items with our main Countries array (because the Country's API gives us the closest country code and not the name) to obtain the countrie's name, this way we present to the user the country name and not the country code inside "Closest Borders" at the 4th section of our List.
                            for (index, border) in details.countryClosestBorders.enumerated() {
                                if let borderCountryName = countryObservable.countriesArray.first(where: {$0.countryCode == border})?.countryName {
                                    selectedCountry.countryDetails?.countryClosestBorders[index] = borderCountryName
                                }
                            }
                            
                            //We call this function to organize our information in the right section.
                            setDetailList()
                        }else{
                            showErrorData(errorString: error?.localizedDescription)
                        }
                    }else{
                        showErrorData(errorString: error?.localizedDescription)
                        return
                    }
                }
            }
        }.resume()
    }
    
    func setDetailList() {
        //This calls the 'CountryDetailSectionsClass.addListSections()' to organize our information in the right section (For more info go to the CountryDetailDataStructs file).
        let detailSection = CountryDetailSectionsClass(selectedCountry: $selectedCountry, sectionsArray: $sectionsArray)
        detailSection.addListSections()
    }
    
    func showErrorData(errorString:String?) {
        haptic(type: .error)
        sessionErrorResponse = errorString ?? "Unable to load Country data, please try again"
        showAlert = true
    }
}
