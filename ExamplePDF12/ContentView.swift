//
//  ContentView.swift
//  ExamplePDF12
//
//  Created by Deirdre Saoirse Moen on 7/15/23.
//

import SwiftUI

struct ContentView: View {
	@State var selection = Set<ReleaseInfo.ID>()
	@Binding var searchText: String

	// note that even though we passed in the unsorted releases,
	// passing this into Table ensures sorting.
	@State var sortOrder: [KeyPathComparator<ReleaseInfo>] = [.init(\.releaseDate, order: SortOrder.forward)]

	var releases: [ReleaseInfo] {
		return ReleaseInfo.releases
			.filter {
				searchText.isEmpty ? true : $0.osName.localizedCaseInsensitiveContains(searchText)
			}
			.sorted(using: sortOrder)
	}


	var body: some View {
		VStack {

			Image(systemName: "globe")
				.foregroundColor(.accentColor)
				.font(.system(size: 48))
				.padding(.bottom, 5)
			Text("Big List of macOS Releases!")
				.font(.largeTitle)
			Table(releases, selection: $selection, sortOrder: $sortOrder) {
				TableColumn("Release Name") {
					Text($0.osName)
						.padding(3)
						.layoutPriority(1)
				}
				.width(120) // you can get better column widths with alignment guides
				TableColumn("Version") {
					Text($0.osVersion)
						.padding(3)
				}
				.width(60)
				TableColumn("Chipsets") {
					Text($0.chipsetsString)
						.padding(3)
				}
				.width(180)
				TableColumn("Release Date") {
					Text($0.releaseDateString)
						.padding(3)
				}
				.width(100)
				TableColumn("Latest Release") {
					Text($0.latestReleaseDateString)
						.padding(3)
				}
				.width(100)
			}
			.searchable(text: $searchText, prompt: "Search releases")

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
		.frame(minWidth: 400, idealWidth: 500, maxWidth: 600,
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
		ContentView(searchText: $searchText)
	}
}
