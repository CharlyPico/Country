//
//  CountryMapRepresentable.swift
//  Country
//
//  Created by Charlie Pico on 30/06/24.
//

import SwiftUI
import WebKit

//Here I created the 'UIViewRepresentable' that holds a 'WKWebView' that presents our map.
struct MapViewRepresentable: UIViewRepresentable {
    let urlToLoad:URL
    
    //Here is important to call the 'CountryMap' view's variables. This way we let know the previous view that the map successfully loaded or that it failed to load.
    @Binding var showLoader:Bool
    @Binding var mapError:Error?
    @Binding var showAlert:Bool
    
    typealias UIViewType = WKWebView
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MapViewRepresentable>) -> WKWebView {
        let web = WKWebView()
        web.navigationDelegate = context.coordinator
        web.load(URLRequest(url: urlToLoad))
        return web
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<MapViewRepresentable>) {}
    
    //The coordinator here helps us call the 'WKNavigationDelegate's functions.
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent:MapViewRepresentable
        
        init(parent: MapViewRepresentable) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            withAnimation {
                self.parent.showLoader = false
            }
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
            withAnimation {
                self.parent.showLoader = false
            }
            //If an error occurs, then we set the parent's 'mapError' and 'showAlert' to true for it to display the alert to the user.
            haptic(type: .error)
            self.parent.mapError = error
            self.parent.showAlert = true
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
            withAnimation {
                self.parent.showLoader = false
            }
            //If an error occurs, then we set the parent's 'mapError' and 'showAlert' to true for it to display the alert to the user.
            haptic(type: .error)
            self.parent.mapError = error
            self.parent.showAlert = true
        }
    }
}
