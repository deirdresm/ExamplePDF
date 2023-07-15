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

	func pdf(components: URLComponents) {
		let pathString = "file://\(components.path)releases.pdf"
		let pdfOutURL = URL(string: pathString)

		guard let pdfOutURLUnwrapped = pdfOutURL else {
			print("Failed to unwrap PDF file path")
			return
		}

		let document = PDFDocument(format: .usLetter)
		document.info.author = "ExamplePDF"
		document.info.title = "Big List of macOS Releases"

		// build the PDF contents by hand

		let nsImage = NSImage(systemSymbolName: "globe", accessibilityDescription: "")
		let imageElement = PDFImage(image: nsImage!, quality: 1, options: [.none])
		document.add(image: imageElement)

		document.add(attributedText: getAttributedString("Big List of MacOS Releases", size: 18.0))

		document.add(space: 20.0)

		// now for the table
		let releaseTable = PDFTable(rows: ReleaseInfo.sortedReleases.count + 1, columns: 5)
		releaseTable.style = tableStyle
		releaseTable.widths = [0.25, 0.1, 0.25, 0.2, 0.2] // should add up to 1.0

		var tableContent = [
			["Release Name", "Version", "Architectures", "Released On", "Last Release"]
		]

		for i in 0 ..< ReleaseInfo.sortedReleases.count {
			let release = ReleaseInfo.sortedReleases[i]
			let archs = release.chipsets.joined(separator: ", ")
			tableContent.append([release.osName,
								release.osVersion,
								archs,
								 release.releaseDateString,
								 release.latestReleaseDateString])
		}
		releaseTable.content = tableContent
		document.add(table: releaseTable)

		// now let's generate a PDF
		let generator = PDFGenerator(document: document)
		let data = try! generator.generateData()
		try? data.write(to: pdfOutURLUnwrapped)

		// you should now have a saved PDF. w00t!
	}

	var tableStyle: PDFTableStyle {
		return PDFTableStyle(
			rowHeaderCount: 0,
			columnHeaderCount: 1,
			footerCount: 0,

			outline: PDFLineStyle(type: .full, color: .black, width: 1.5),
			columnHeaderStyle: PDFTableCellStyle(
				colors: (fill: .white, text: .black),
				borders: PDFTableCellBorders(bottom: PDFLineStyle(
					type: .full,
					color: .lightGray,
					width: 0.5
				)),
				font: Font.systemFont(ofSize: 10.0, weight: .bold)
			),
			contentStyle: PDFTableCellStyle(
				colors: (
					fill: Color(red: 246.0 / 255.0, green: 246.0 / 255.0, blue: 246.0 / 255.0, alpha: 0.9),
					text: .black
				),
				borders: PDFTableCellBorders(bottom: PDFLineStyle(
					type: .full,
					color: .lightGray,
					width: 0.5
				)),
				font: Font.systemFont(ofSize: 10)
			),
			alternatingContentStyle: PDFTableCellStyle(
				colors: (
					fill: Color(red: 233.0 / 255.0, green: 233.0 / 255.0, blue: 233.0 / 255.0, alpha: 0.9),
					text: .black
				),
				borders: PDFTableCellBorders(bottom: PDFLineStyle(
					type: .full,
					color: .lightGray,
					width: 0.5
				)),
				font: Font.systemFont(ofSize: 10)
			)
		)
	}

	func getAttributedString(_ string: String,
							 size: CGFloat,
							 color: NSColor = .black,
							 alignment: NSTextAlignment = .center) -> NSAttributedString {
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = alignment

		let attributedString = NSMutableAttributedString(string: string, attributes: [
			.font: NSFont.systemFont(ofSize: size),
			.foregroundColor: color,
			.paragraphStyle: paragraphStyle
		])
		return attributedString
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
