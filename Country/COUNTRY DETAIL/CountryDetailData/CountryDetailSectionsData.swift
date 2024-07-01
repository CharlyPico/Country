//
//  CountryDetailSectionsData.swift
//  Country
//
//  Created by Charlie Pico on 29/06/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct CountryDetailSectionsClass {
    @Binding var selectedCountry:CountryDataStruct
    @Binding var sectionsArray:[CountryDetailSectionsData]
    
    func addListSections()
    {
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
                                                subsectionDescription: "Sub Region".localized,
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

enum SectionsType {
    case Image
    case Text
    case TextSpecialIcon
}

struct ListTextSection: View{
    let sectItem:CountryDetailSubSectionsData
    var body:some View {
        HStack(spacing: 10){
            Image(systemName: sectItem.subsectionIcon)
                .resizable()
                .scaledToFit()
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

struct ListTextSpecialIconSection: View{
    let sectItem:CountryDetailSubSectionsData
    var body:some View {
        HStack(spacing: 10){
            Text(sectItem.subsectionIcon)
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

struct ListImageSection: View{
    let sectItem:CountryDetailSubSectionsData
    @Binding var device:UIUserInterfaceIdiom
    var body:some View {
        VStack {
            WebImage(url: URL(string: sectItem.subsectionIcon)) { image in
                image.resizable()
                image.scaledToFill()
            } placeholder: {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .foregroundStyle(Color(.darkGray))
            }
            .resizable()
            .scaledToFit()
            .frame(minWidth: device == .pad ? 500:300, maxWidth: device == .pad ? 500:300, minHeight: device == .pad ? 400:200, maxHeight: device == .pad ? 400:200)
            .padding(1)
            Text(sectItem.subsectionDescription)
                .listRowSeparator(.hidden)
        }
    }
}

struct CountryDetailSectionsData:Identifiable {
    let id = UUID()
    var sectionName:String
    var sectionItems:[CountryDetailSubSectionsData]
    
    init(sectionName: String, sectionItems: [CountryDetailSubSectionsData]) {
        self.sectionName = sectionName
        self.sectionItems = sectionItems
    }
}

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
