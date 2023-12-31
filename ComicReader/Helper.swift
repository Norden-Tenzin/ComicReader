//
//  Helper.swift
//  ComicReader
//
//  Created by Tenzin Norden on 8/23/23.
//

import Foundation
import ZipArchive
//
//func updateJSON (to file: String, for location: FileManager.SearchPathDirectory, comics data: Comic) -> Void {
//    var currDATA = readJSON(from: file, for: location)
//    let index = currDATA.firstIndex { comic in
//        comic.name == data.name
//    }
//    currDATA[index!] = data
//    do {
//        let fileURL = try FileManager.default
//            .url(for: location, in: .userDomainMask, appropriateFor: nil, create: true)
//            .appendingPathComponent("\(file).json")
//        let encodedData = try JSONEncoder().encode(currDATA)
//        try encodedData.write(to: fileURL)
//    } catch {
//        print("error: \(error)")
//    }
//}
//
//func writeJSON (to file: String, for location: FileManager.SearchPathDirectory, comics data: Comic) -> Void {
//    var currDATA = readJSON(from: file, for: location)
//    currDATA.append(data)
//    do {
//        let fileURL = try FileManager.default
//            .url(for: location, in: .userDomainMask, appropriateFor: nil, create: true)
//            .appendingPathComponent("\(file).json")
//        let encodedData = try JSONEncoder().encode(currDATA)
//        try encodedData.write(to: fileURL)
//    } catch {
//        print("error: \(error)")
//    }
//}
//
//func writeEmptyJSON (to file: String, for location: FileManager.SearchPathDirectory) -> Void {
//    do {
//        let fileURL = try FileManager.default
//            .url(for: location, in: .userDomainMask, appropriateFor: nil, create: true)
//            .appendingPathComponent("\(file).json")
//        FileManager.default.createFile(atPath: fileURL.path, contents: Data("[]".utf8), attributes: nil)
//    } catch {
//        print("error: \(error)")
//    }
//}
//
//func readJSON (from file: String, for location: FileManager.SearchPathDirectory) -> [Comic] {
//    do {
//        let fileURL = try FileManager.default
//            .url(for: location, in: .userDomainMask, appropriateFor: nil, create: true)
//            .appendingPathComponent("\(file).json")
//        return try JSONDecoder().decode([Comic].self, from: Data(contentsOf: fileURL))
//    } catch {
//        print("error: \(error)")
//        return []
//    }
//}

func getFilePath (of fileName: String, for location: FileManager.SearchPathDirectory) -> URL? {
    do {
        let fileURL = try FileManager.default
            .url(for: location, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(fileName)
        return fileURL
    } catch {
        print("error: \(error)")
        return nil
    }
}

func doesFileExist(at fileName: String, for location: FileManager.SearchPathDirectory) -> Bool? {
    return FileManager.default.fileExists(atPath: getFilePath(of: fileName, for: location)?.path ?? "")
}

func getDirectoryInDocuments(of directoryName: String) -> URL {
    let dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(directoryName)
    return dataPath
}

func createDirectoryInDocuments(dirName: String) {
    do {
        try FileManager.default.createDirectory(atPath: getDirectoryInDocuments(of: dirName).path, withIntermediateDirectories: true, attributes: nil)
    } catch let error as NSError {
        print("Error creating directory: \(error.localizedDescription)")
    }
}

//func createJsonInDocuments(jsonName: String) {
//    if doesFileExist(at: jsonName, for: .documentDirectory) == nil {
//        writeEmptyJSON(to: jsonName, for: .documentDirectory)
//        print("NEW FILE CREATED")
//    } else {
//        print("FILE EXISTS")
//    }
//}

func unzipCBZFile(at originalLocation: String, to exportLocation: String) {
    let res = SSZipArchive.unzipFile(atPath: originalLocation, toDestination: exportLocation)
    print("FROM: \(originalLocation) to \(exportLocation): \(res)")
}

func getComicPages(at location: String) -> [String] {
    do {
        print("COMIC PAGES LOCATION: \(location)")
        let directoryContents = try FileManager.default.contentsOfDirectory(atPath: location)
        return directoryContents.sorted()
    }
    catch {
        print("error: \(error)")
        return []
    }
}
