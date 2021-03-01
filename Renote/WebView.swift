//
//  WebView.swift
//  Renote
//
//  Created by Raheel Sayeed on 19/02/21.
//  Copyright © 2021 Medical Gear. All rights reserved.
//

import WebKit
import SwiftUI


/// View created as a workaround implementation of UIWebView for SwiftUI
struct WebView: UIViewRepresentable {

	/// String representation of the URL you want to open in the WebView.
	let urlString: String?

	func makeUIView(context: Context) -> WKWebView {
		return WKWebView()
	}

	func updateUIView(_ uiView: WKWebView, context: Context) {
		if let safeString = urlString, let url = URL(string: safeString) {
			let request = URLRequest(url: url)
			uiView.load(request)
		}
	}

}
