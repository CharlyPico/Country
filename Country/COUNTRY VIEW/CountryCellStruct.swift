//
//  CountryCellStruct.swift
//  Country
//
//  Created by Charlie Pico on 02/07/24.
//

import SwiftUI
import SDWebImageSwiftUI

//Here we have our main CountryView cell struct design. I implemented the SDWebImageSwiftUI package for server image loading. I decided to implement this Package bacause it is specifically built for server image loading, and this also helps reducing time when coding. It can also load as Data to an Image.
struct CountryCellStruct: View {
    @Binding var country:CountryDataStruct
    @Binding var device:UIUserInterfaceIdiom
    var body: some View {
        VStack(spacing: 10){
            WebImage(url: URL(string: country.countryFlag)) { image in
                image.resizable()
            } placeholder: {
                RoundedRectangle(cornerRadius: 10, style: .continuous).foregroundStyle(Color(.darkGray))
            }
            .resizable()
            .scaledToFit()
            .frame(width: device == .pad ? 100:80, height: device == .pad ? 62:49)
            .padding(.horizontal, 5)
            Text(country.countryName.lowercased().capitalized)
                .padding(.horizontal, 5)
                .font(.title2)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .minimumScaleFactor(0.5)
        }
    }
}
