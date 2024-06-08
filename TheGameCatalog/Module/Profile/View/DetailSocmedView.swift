//
//  DetailSocmedView.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 07/06/24.
//

import SwiftUI
import WebKit

struct DetailSocmedView: View {
    let url: String?
    var body: some View {
        WebView(url: URL(string: url!)!)
    }
}

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
