//
//  Comic.swift
//  ComicReader
//
//  Created by Tenzin Norden on 9/2/23.
//

import Foundation
import SwiftData

@Model
class Chapter: Identifiable {
    let id: UUID
    let name: String
    let originalLocation: String
    let exportLocation: String
    var pages: [String]
    var currPage: Int
    var totalPages: Int

    enum CodingKeys: CodingKey {
        case _id
        case _name
        case _originalLocation
        case _exportLocation
        case _pages
        case _currPage
        case _totalPages
        case _$backingData
        case _$observationRegistrar
    }

    init(name: String, originalLocation: String, exportLocation: String, pages: [String], currPage: Int) {
        self.id = UUID()
        self.name = name
        self.originalLocation = originalLocation
        self.exportLocation = exportLocation
        self.pages = pages
        self.currPage = currPage
        self.totalPages = pages.count
    }

//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(UUID.self, forKey: ._id)
//        self.name = try container.decode(String.self, forKey: ._name)
//        self.originalLocation = try container.decode(String.self, forKey: ._originalLocation)
//        self.exportLocation = try container.decode(String.self, forKey: ._exportLocation)
//        self.pages = try container.decode([String].self, forKey: ._pages)
//        self.currPage = try container.decode(Int.self, forKey: ._currPage)
//        self.totalPages = try container.decode(Int.self, forKey: ._totalPages)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: ._id)
//        try container.encode(name, forKey: ._name)
//        try container.encode(originalLocation, forKey: ._originalLocation)
//        try container.encode(pages, forKey: ._pages)
//        try container.encode(currPage, forKey: ._currPage)
//        try container.encode(totalPages, forKey: ._totalPages)
//    }

    func setCurrPage(currPage: Int) {
        self.currPage = currPage
    }

    func toString() -> String {
        return "Name: \(name), Pages: \(pages), CurrPage: \(currPage), TotalPages: \(totalPages)"
    }
}

@Model
class Comic: Equatable {
    static func == (lhs: Comic, rhs: Comic) -> Bool {
        if lhs.id == rhs.id { return true }
        else { return false }
    }
    let id: UUID
    let name: String
    var chapters: [Chapter]
    var cover: String

    enum CodingKeys: CodingKey {
        case id
        case name
        case chapters
        case cover
    }

    init(name: String) {
        self.id = UUID()
        self.name = name
        self.chapters = []
        self.cover = ""
    }

//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(UUID.self, forKey: .id)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.chapters = try container.decode([Chapter].self, forKey: .chapters)
//        self.cover = try container.decode(String.self, forKey: .cover)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(name, forKey: .name)
//        try container.encode(chapters, forKey: .chapters)
//        try container.encode(cover, forKey: .cover)
//    }

    func setChapters(chapters: [Chapter]) {
        self.chapters = chapters
    }

//    func writeToJson() {
//        if (readJSON(from: DATA_FILE_NAME, for: .documentDirectory).firstIndex(where: { comic in
//                return comic.name == self.name
//            }) != nil) {
//            print("EXISTS")
//            updateJSON(to: DATA_FILE_NAME, for: .documentDirectory, comics: self)
//        } else {
//            print("NOT EXISTS")
//            writeJSON(to: DATA_FILE_NAME, for: .documentDirectory, comics: self)
//        }
//    }

    func toString() -> String {
        return "Name: \(name), Chapters: \(chapters)"
    }
}
