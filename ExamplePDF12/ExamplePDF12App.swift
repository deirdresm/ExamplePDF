//
//  ExamplePDF12App.swift
//  ExamplePDF12
//
//  Created by Deirdre Saoirse Moen on 7/15/23.
//

import SwiftUI

@main
struct ExamplePDF12App: App {
	@State var searchText: String = ""
    var body: some Scene {
        WindowGroup {
            ContentView(searchText: $searchText)
        }
    }
}
