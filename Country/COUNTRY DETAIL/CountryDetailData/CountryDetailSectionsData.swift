//
//  CountryDetailSectionsData.swift
//  Country
//
//  Created by Charlie Pico on 29/06/24.
//

import SwiftUI
import SDWebImageSwiftUI

//This enum separates each CountryDetail item into a section type, so it gets the right design.
enum SectionsType {
    case Image
    case Text
    case TextSpecialIcon
}

//This is the CountryDetailSectionsClass which adds the current Note items in place with it's corresponding section to a 'CountryDetailSectionsData' array. We use the 'withAnimation' function to give it a smooth fade in animation.
struct CountryDetailSectionsClass {
    @Binding var selectedCountry:CountryDataStruct
    @Binding var sectionsArray:[CountryDetailSectionsData]
    
    func addListSections()
    {
        withAnimation {
            sectionsArray = [
                CountryDetailSectionsData(sectionName: "", sectionItems:
                                            [
                                                CountryDetailSubSectionsData(
                                                    subsectionTitle: "",
                                                    subsectionDescription: selectedCountry.countryDetails?.countryFlagDescription ?? "No flag information".localized,
                                                    subsectionIcon: selectedCountry.countryFlag,
                                                    iconSize: 25,
                                                    iconExtraPadding: 0,
                                                    subsectionType: .Image
                                                )
                                            ]),
                CountryDetailSectionsData(sectionName: "Basic Information".localized, sectionItems:
                                            [
                                                CountryDetailSubSectionsData(
                                                    subsectionTitle: selectedCountry.countryName,
                                                    subsectionDescription: "Common Name".localized,
                                                    subsectionIcon: "abc",
                                                    iconSize: 25,
                                                    iconExtraPadding: 0,
                                                    subsectionType: .Text
                                                ),
                                                CountryDetailSubSectionsData(
                                                    subsectionTitle: selectedCountry.countryName,
                                                    subsectionDescription: "Official Name".localized,
                                                    subsectionIcon: "abc",
                                                    iconSize: 25,
                                                    iconExtraPadding: 0,
                                                    subsectionType: .Text
                                                ),
                                                CountryDetailSubSectionsData(
                                                    subsectionTitle: selectedCountry.countryName,
                                                    subsectionDescription: "Capital City".localized,
                                                    subsectionIcon: "mappin.and.ellipse",
                                                    iconSize: 16,
                                                    iconExtraPadding: 4.5,
                                                    subsectionType: .Text
                                                )
                                            ]),
                CountryDetailSectionsData(sectionName: "More Details".localized, sectionItems:
                                            [
                                                CountryDetailSubSectionsData(
                                                    subsectionTitle: selectedCountry.countryDetails?.countryRegion ?? "No region".localized,
                                                    subsectionDescription: "Region".localized,
                                                    subsectionIcon: "map.fill",
                                                    iconSize: 16,
                                                    iconExtraPadding: 4.5,
                                                    subsectionType: .Text
                                                ),
                                                CountryDetailSubSectionsData(
                                                    subsectionTitle: selectedCountry.countryDetails?.countrySubRegion ?? "No subregion".localized,
                                                    subsectionDescription: "Subregion".localized,
                                                    subsectionIcon: "map.fill",
                                                    iconSize: 16,
                                                    iconExtraPadding: 4.5,
                                                    subsectionType: .Text
                                                ),
                                                CountryDetailSubSectionsData(
                                                    subsectionTitle: selectedCountry.countryDetails?.countryLanguagesString as? String ?? "",
                                                    subsectionDescription: "Main Language".localized,
                                                    subsectionIcon: "waveform.and.person.filled",
                                                    iconSize: 19,
                                                    iconExtraPadding: 3,
                                                    subsectionType: .Text
                                                ),
                                                CountryDetailSubSectionsData(
                                                    subsectionTitle: selectedCountry.countryDetails?.countryMainCurrency["name"] as? String ?? "No currency".localized,
                                                    subsectionDescription: "Main Currency".localized,
                                                    subsectionIcon: selectedCountry.countryDetails?.countryMainCurrency["symbol"] as? String ?? "$",
                                                    iconSize: 25,
                                                    iconExtraPadding: 0,
                                                    subsectionType: .TextSpecialIcon
                                                )
                                            ]),
                CountryDetailSectionsData(sectionName: "Extra Details".localized, sectionItems:
                                            [
                                                CountryDetailSubSectionsData(
                                                    subsectionTitle: selectedCountry.countryDetails?.countryTotalPopulation.formattedWithSeparatorNoDecimals ?? "No population".localized,
                                                    subsectionDescription: "Population".localized,
                                                    subsectionIcon: "person.3.fill",
                                                    iconSize: 25,
                                                    iconExtraPadding: 0,
                                                    subsectionType: .Text
                                                ),
                                                CountryDetailSubSectionsData(
                                                    subsectionTitle: selectedCountry.countryCode,
                                                    subsectionDescription: "Country Code".localized,
                                                    subsectionIcon: "number",
                                                    iconSize: 20,
                                                    iconExtraPadding: 2.5,
                                                    subsectionType: .Text
                                                ),
                                                CountryDetailSubSectionsData(
                                                    subsectionTitle: selectedCountry.countryDetails?.countryCallingCode ?? "No calling code".localized,
                                                    subsectionDescription: "Calling Code".localized,
                                                    subsectionIcon: "number",
                                                    iconSize: 20,
                                                    iconExtraPadding: 2.5,
                                                    subsectionType: .Text
                                                ),
                                                CountryDetailSubSectionsData(
                                                    subsectionTitle: !(selectedCountry.countryDetails?.countryClosestBorders.isEmpty)! ? (selectedCountry.countryDetails?.countryClosestBorders.joined(separator: ", ") as? String ?? ""):"No borders".localized,
                                                    subsectionDescription: "Closest Borders".localized,
                                                    subsectionIcon: "person.line.dotted.person.fill",
                                                    iconSize: 25,
                                                    iconExtraPadding: 0,
                                                    subsectionType: .Text
                                                )
                                            ])
            ]
        }
    }
}

//This is the ListTextSection type which is filtered inside the enum 'SectionsType' and presented when the type '.Text' is called.
struct ListTextSection: View{
    let sectItem:CountryDetailSubSectionsData
    var body:some View {
        HStack(spacing: 10){
            Image(systemName: sectItem.subsectionIcon)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .frame(width: sectItem.iconSize, height: sectItem.iconSize)
                .padding(5)
                .padding(.all, sectItem.iconExtraPadding)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.secondary)
                )
            VStack(alignment: .leading) {
                Text(sectItem.subsectionTitle)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                Text(sectItem.subsectionDescription)
                    .foregroundStyle(.secondary)
                    .font(.caption.weight(.medium))
                    .lineLimit(1)
            }
        }
    }
}

//This is the ListTextSpecialIconSection type which is filtered inside the enum 'SectionsType' and presented when the type '.TextSpecialIcon' is called. The thing that differs this struct form the ListTextSection, is that we show the custom currency icon as Text and not an image.
struct ListTextSpecialIconSection: View{
    let sectItem:CountryDetailSubSectionsData
    var body:some View {
        HStack(spacing: 10){
            Text(sectItem.subsectionIcon)
                .foregroundStyle(.white)
                .frame(width: sectItem.iconSize,height: sectItem.iconSize)
                .padding(5)
                .padding(.all, sectItem.iconExtraPadding)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.secondary)
                )
            VStack(alignment: .leading) {
                Text(sectItem.subsectionTitle)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                Text(sectItem.subsectionDescription)
                    .foregroundStyle(.secondary)
                    .font(.caption.weight(.medium))
            }
        }
    }
}

//This is the ListImageSection type which is filtered inside the enum 'SectionsType' and presented when the type '.Image' is called.
struct ListImageSection: View{
    let sectItem:CountryDetailSubSectionsData
    @Binding var device:UIUserInterfaceIdiom
    var body:some View {
        VStack(alignment: .center) {
            WebImage(url: URL(string: sectItem.subsectionIcon)) { image in
                image.resizable()
                image.scaledToFill()
            } placeholder: {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .foregroundStyle(Color(.darkGray))
            }
            .resizable()
            .scaledToFit()
            .frame(maxWidth: device == .pad ? 500:300)
            .padding(5)
            Text(sectItem.subsectionDescription)
                .listRowSeparator(.hidden)
        }
        .frame(maxWidth: .infinity)
    }
}

//This is the CountryDetailSectionsData which defines each section displayed at the CountryDetail view.
struct CountryDetailSectionsData:Identifiable {
    let id = UUID()
    var sectionName:String
    var sectionItems:[CountryDetailSubSectionsData]
    
    init(sectionName: String, sectionItems: [CountryDetailSubSectionsData]) {
        self.sectionName = sectionName
        self.sectionItems = sectionItems
    }
}

//This is the CountryDetailSubSectionsData which defines each item displayed in each section at the CountryDetail view.
struct CountryDetailSubSectionsData:Identifiable {
    let id = UUID()
    var subsectionTitle:String
    var subsectionDescription:String
    var subsectionIcon:String
    var iconSize:CGFloat
    var iconExtraPadding:CGFloat
    var subsectionType:SectionsType
    
    init(subsectionTitle: String, subsectionDescription: String, subsectionIcon: String, iconSize:CGFloat, iconExtraPadding:CGFloat , subsectionType: SectionsType) {
        self.subsectionTitle = subsectionTitle
        self.subsectionDescription = subsectionDescription
        self.subsectionIcon = subsectionIcon
        self.iconSize = iconSize
        self.iconExtraPadding = iconExtraPadding
        self.subsectionType = subsectionType
    }
}
