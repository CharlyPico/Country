//
//  CountryMapRepresentable.swift
//  Country
//
//  Created by Charlie Pico on 30/06/24.
//

import SwiftUI
import WebKit

struct MapViewRepresentable: UIViewRepresentable {
    let urlToLoad:URL
    @Binding var showLoader:Bool
    
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
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent:MapViewRepresentable
        
        init(parent: MapViewRepresentable) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("End loading")
            withAnimation {
                self.parent.showLoader = false
            }
        }
    }
}
