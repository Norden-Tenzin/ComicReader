//
//  ComicReaderApp.swift
//  ComicReader
//
//  Created by Tenzin Norden on 8/16/23.
//

import SwiftUI
import SwiftData

@main
struct ComicReaderApp: App {
//    let modelContainer: ModelContainer
    init() {
        print("HERE")
        createDirectoryInDocuments(dirName: COMIC_LOCATION_NAME)
        createDirectoryInDocuments(dirName: COMIC_DATA_LOCATION_NAME)
//        createJsonInDocuments(jsonName: DATA_FILE_NAME)
//        print(readJSON(from: DATA_FILE_NAME, for: .documentDirectory).count)
//        do {
//            modelContainer = try ModelContainer(for: Comic.self)
//        } catch {
//            fatalError("Could not initialize ModelContainer")
//        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
            .modelContainer(for: [Comic.self, Chapter.self])
    }
}
