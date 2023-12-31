//
//  ContentView.swift
//  ExamplePDF
//
//  Created by Deirdre Saoirse Moen on 7/14/23.
//

import AppKit
import SwiftUI
import TPPDF

struct ContentView: View {
	// search and sort stuff (if one's on macOS 12 or later, sigh, useful with Table, also macOS 12 or later)
//	@State var selection = Set<ReleaseInfo.ID>()
//	@Binding var searchText: String
//	@State var sortOrder: [KeyPathComparator<ReleaseInfo>] = [.init(\.releaseDate, order: SortOrder.forward)]

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .foregroundColor(.accentColor)
				.font(.system(size: 48))
				.padding(.bottom, 5)
            Text("Big List of macOS Releases!")
				.font(.largeTitle)
			TableView()

			Button(
				action: {
					buttonPressed()
				},
				label: {
					Text("Click for PDF")
						.padding()
				}
			)
        }
        .padding()
		.frame(minWidth: 300, idealWidth: 300, maxWidth: 400,
			   minHeight: 400, idealHeight: 400, maxHeight: 500,
			   alignment: .center)

		// Window height: On macOS 11, if you want to constrain
		// the window, easist to do it with NSWindow.
    }

	func buttonPressed() {
		// You can simplify this in later versions of SwiftUI.

		// don't forget to add magic to the entitlements file!
		// https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_files_user-selected_read-write

		// ask user to pick where PDF file goes
		let panel = NSOpenPanel()
		panel.allowsMultipleSelection = false
		panel.canChooseFiles = false
		panel.canChooseDirectories = true
		panel.canCreateDirectories = true

		// in a real-world situation, you'll likely want to security scope this.
		if panel.runModal() == .OK {
			if let url = panel.url {
				let outputComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)

				pdf(components: outputComponents!)
			}
		}
	}

}

struct TableView: View {
	var body: some View {
		VStack {
			ForEach(ReleaseInfo.sortedReleases, id: \.self) { release in

				// You can do List with an HStack on macOS 11.
				// It just needs alignment guides to look nice,
				// and this is a quick example.
				HStack {
					Text(release.osName)
					Text(release.osVersion)
				}
			}
		}
		.padding()
	}
}

struct ContentView_Previews: PreviewProvider {
	@State static var searchText: String = ""
    static var previews: some View {
		ContentView()
    }
}
