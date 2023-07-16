//
//  PDFGeneration.swift
//  ExamplePDF
//
//  Created by Deirdre Saoirse Moen on 7/15/23.
//

import SwiftUI
import TPPDF

// Moved all the PDF generation into an extension so I can share it with the macOS 12 target.
// In a fuller app, pressing the button would yell at a ViewModel, then the ViewModel would
// launch something that generated the PDF. This shouldn't be in the view since it has zero
// to do with views, but this is a simple example.

extension ContentView { // ideally, break this out, obviously. :P
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
			tableContent.append([release.osName,
								release.osVersion,
								release.chipsetsString,
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
