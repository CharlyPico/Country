//
//  WebInformation.swift
//  Country
//
//  Created by Charlie Pico on 29/06/24.
//

import SystemConfiguration
import Foundation

//In here I created the WebInformation struct. This includes the main API URL and default URLSessionConfiguration used through the App.

struct WebInformation {
    let countryAPIMainURL = "https://restcountries.com/v3.1"

    var generalUrlSessionConfiguration:URLSessionConfiguration {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.urlCache = .none
        sessionConfig.httpCookieStorage = .none
        sessionConfig.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        sessionConfig.timeoutIntervalForRequest = 5000
        
        return sessionConfig
    }

    //This function is to check if the device is connected to the internet or not. This helps to show the user an alert that an internet connection is required.
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

    //This function returns the default URL that is used to get all countries data.
    func urlToLoad(_ urlAppending:String) -> URL {
       return URL(string: countryAPIMainURL.appending(urlAppending)) ?? URL(string: "https://www.apple.com")!
    }
}
