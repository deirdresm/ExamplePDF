//
//  PageData.swift
//  ExamplePDF
//
//  Created by Deirdre Saoirse Moen on 7/14/23.
//

import SwiftUI

/// Make some tabular data type to show tables off.
struct ReleaseInfo: Identifiable {
	let id: UUID = UUID()
	let osName: String
	let osVersion: String
	let chipsets: [String]
	let releaseDate: Date
	let latestReleaseDate: Date
}

extension ReleaseInfo: Comparable, Equatable, Hashable {
	static func < (lhs: ReleaseInfo, rhs: ReleaseInfo) -> Bool {
		return lhs.releaseDate < rhs.releaseDate
	}

	static func == (lhs: ReleaseInfo, rhs: ReleaseInfo) -> Bool {
		return (lhs.osVersion == rhs.osVersion) && (lhs.releaseDate == rhs.releaseDate)
	}
}

extension ReleaseInfo {
	static var dateFormatter: DateFormatter {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "YYYY-mm-dd"
		return dateFormatter
	}

	var releaseDateString: String {
		return ReleaseInfo.dateFormatter.string(from: releaseDate)
	}

	var latestReleaseDateString: String {
		return ReleaseInfo.dateFormatter.string(from: latestReleaseDate)
	}

	var chipsetsString: String {
		return chipsets.joined(separator: ", ")
	}

	static var cheetah = ReleaseInfo(osName: "Cheetah",
									 osVersion: "10",
									 chipsets: ["PowerPC"],
									 releaseDate: dateFormatter.date(from: "2001-03-24")!,
									 latestReleaseDate: dateFormatter.date(from: "2001-06-22")!)
	static var puma = ReleaseInfo(osName: "Puma",
									 osVersion: "10.1",
									 chipsets: ["PowerPC"],
									 releaseDate: dateFormatter.date(from: "2001-09-29")!,
									 latestReleaseDate: dateFormatter.date(from: "2002-06-06")!)
	static var jaguar = ReleaseInfo(osName: "Jaguar",
									 osVersion: "10.2",
									 chipsets: ["PowerPC"],
									 releaseDate: dateFormatter.date(from: "2002-08-23")!,
									 latestReleaseDate: dateFormatter.date(from: "2003-10-03")!)
	static var panther = ReleaseInfo(osName: "Panther",
									 osVersion: "10.3",
									 chipsets: ["PowerPC"],
									 releaseDate: dateFormatter.date(from: "2003-10-24")!,
									 latestReleaseDate: dateFormatter.date(from: "2005-04-15")!)
	static var tiger = ReleaseInfo(osName: "Tiger",
									 osVersion: "10.4",
									 chipsets: ["PowerPC", "Intel (IA-32)"],
									 releaseDate: dateFormatter.date(from: "2005-04-29")!,
									 latestReleaseDate: dateFormatter.date(from: "2007-11-14")!)
	static var leopard = ReleaseInfo(osName: "Leopard",
									 osVersion: "10.5",
									 chipsets: ["PowerPC", "IA-32", "x86-64)"],
									 releaseDate: dateFormatter.date(from: "2007-10-26")!,
									 latestReleaseDate: dateFormatter.date(from: "2009-08-13")!)
	static var snowLeopard = ReleaseInfo(osName: "Snow Leopard",
									 osVersion: "10.6",
									 chipsets: ["IA-32, x86-64"],
									 releaseDate: dateFormatter.date(from: "2009-08-29")!,
									 latestReleaseDate: dateFormatter.date(from: "2011-07-25")!)
	static var lion = ReleaseInfo(osName: "Lion",
									 osVersion: "10.7",
									 chipsets: ["x86-64"],
									 releaseDate: dateFormatter.date(from: "2011-07-20")!,
									 latestReleaseDate: dateFormatter.date(from: "2012-10-04")!)
	static var mountainLion = ReleaseInfo(osName: "Mountain Lion",
									 osVersion: "10.8",
									 chipsets: ["x86-64"],
									 releaseDate: dateFormatter.date(from: "2012-07-25")!,
									 latestReleaseDate: dateFormatter.date(from: "2015-08-13")!)

	// California time!
	static var mavericks = ReleaseInfo(osName: "Mavericks",
									 osVersion: "10.9",
									 chipsets: ["x86-64"],
									 releaseDate: dateFormatter.date(from: "2013-10-22")!,
									 latestReleaseDate: dateFormatter.date(from: "2016-07-18")!)
	static var yosemite = ReleaseInfo(osName: "Yosemite",
									 osVersion: "10.10",
									 chipsets: ["x86-64"],
									 releaseDate: dateFormatter.date(from: "2014-10-16")!,
									 latestReleaseDate: dateFormatter.date(from: "2017-07-19")!)
	static var elCapitan = ReleaseInfo(osName: "El Capitan",
									 osVersion: "10.11",
									 chipsets: ["x86-64"],
									 releaseDate: dateFormatter.date(from: "2015-09-30")!,
									 latestReleaseDate: dateFormatter.date(from: "2018-07-09")!)
	static var sierra = ReleaseInfo(osName: "Sierra",
									 osVersion: "10.12",
									 chipsets: ["x86-64"],
									 releaseDate: dateFormatter.date(from: "2016-09-20")!,
									 latestReleaseDate: dateFormatter.date(from: "2019-09-26")!)
	static var highSierra = ReleaseInfo(osName: "High Sierra",
									 osVersion: "10.13",
									 chipsets: ["x86-64"],
									 releaseDate: dateFormatter.date(from: "2017-09-25")!,
									 latestReleaseDate: dateFormatter.date(from: "2020-11-12")!)
	static var mojave = ReleaseInfo(osName: "Mojave",
									 osVersion: "10.14",
									 chipsets: ["x86-64"],
									 releaseDate: dateFormatter.date(from: "2018-09-24")!,
									 latestReleaseDate: dateFormatter.date(from: "2021-07-21")!)
	static var catalina = ReleaseInfo(osName: "Catalina",
									 osVersion: "10.15",
									 chipsets: ["x86-64"],
									 releaseDate: dateFormatter.date(from: "2019-10-07")!,
									 latestReleaseDate: dateFormatter.date(from: "2022-07-20")!)
	static var bigSur = ReleaseInfo(osName: "Big Sur",
									 osVersion: "11",
									 chipsets: ["x86-64", "ARM64"],
									 releaseDate: dateFormatter.date(from: "2020-11-12")!,
									 latestReleaseDate: dateFormatter.date(from: "2023-06-21")!)
	static var monterey = ReleaseInfo(osName: "Monterey",
									 osVersion: "12",
									 chipsets: ["x86-64", "ARM64"],
									 releaseDate: dateFormatter.date(from: "2021-10-25")!,
									 latestReleaseDate: dateFormatter.date(from: "2023-06-21")!)
	static var ventura = ReleaseInfo(osName: "Ventura",
									 osVersion: "13",
									 chipsets: ["x86-64", "ARM64"],
									 releaseDate: dateFormatter.date(from: "2022-10-24")!,
									 latestReleaseDate: dateFormatter.date(from: "2023-06-21")!)

	// Deliberately add releases out of order to show off sorting.
	static var releases: [ReleaseInfo] = [.ventura, .monterey, .bigSur, .cheetah, .puma, .jaguar, .panther,
										  .tiger, .leopard, .snowLeopard, .mavericks, .lion, .mountainLion,
										  .yosemite, .elCapitan, .sierra, .highSierra, .mojave, .catalina]

	// Don't need this for macOS 12+'s view as you can use Table-based sorting. But! This is for macOS 11.
	static var sortedReleases = releases.sorted()
}

/// Mix up the text display a bit.
enum StringType {
	case smol, usual, biggety
}
