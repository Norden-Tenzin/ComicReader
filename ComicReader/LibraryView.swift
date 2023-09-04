//
//  Library.swift
//  ComicReader
//
//  Created by Tenzin Norden on 8/23/23.
//

import SwiftUI
import SwiftData
import ZipArchive

struct LibraryView: View {
    @Environment(\.modelContext) private var context
    @Query private var exisitingComics: [Comic]
    var demoText: String
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)

    func doesComicExist(comicName: String) -> Bool {
        if exisitingComics.firstIndex(where: { comic in
            comic.name == comicName
        }) != nil {
            return true
        } else {
            return false
        }
    }

    func setCoverToFirstPage(chapterName: String, originalLocation: String) -> String {
        let tempLocation = getDirectoryInDocuments(of: COMIC_DATA_LOCATION_NAME + "/temp/").path
        let coverLocation = COMIC_DATA_LOCATION_NAME + "/Covers/\(chapterName)"
        createDirectoryInDocuments(dirName: COMIC_DATA_LOCATION_NAME + "/Covers/\(chapterName)")
        createDirectoryInDocuments(dirName: COMIC_DATA_LOCATION_NAME + "/temp/\(chapterName)/")
        if !FileManager.default.fileExists(atPath: getDirectoryInDocuments(of: coverLocation).path + "/cover.jpg") {
            unzipCBZFile(at: originalLocation, to: tempLocation + "\(chapterName)/")
            let pages = getComicPages(at: tempLocation + "\(chapterName)/")
            do {
                if FileManager.default.fileExists(atPath: "\(tempLocation)\(chapterName)/\(pages[0])") {
                    print("HERE")
                    try FileManager.default.moveItem(at: URL(filePath: "\(tempLocation)\(chapterName)/\(pages[0])"), to: URL(filePath: getDirectoryInDocuments(of: coverLocation).path + "/cover.jpg"))
                }
            } catch {
                print ("Error moving file: \(error)")
            }
            do {
                if FileManager.default.fileExists(atPath: "\(tempLocation)\(chapterName)/") {
                    try FileManager.default.removeItem(atPath: "\(tempLocation)\(chapterName)/")
                }
            } catch {
                print ("Error removing file: \(error)")
            }
        }
        return coverLocation + "/cover.jpg"
    }

    func findChapters(directoryContents: [String], item: String, tempComic: Comic) -> [Chapter] {
        var res: [Chapter] = []
        for innerItem in directoryContents {
            let originalLocation = COMIC_LOCATION_NAME + "/\(item)/\(innerItem)"
            let exportLocation = COMIC_DATA_LOCATION_NAME + "/\(item)/\(innerItem)"
            if tempComic.cover == "" {
                print(tempComic.cover)
                tempComic.cover = setCoverToFirstPage(chapterName: item, originalLocation: originalLocation)
            }

            let tempChapter = Chapter(name: innerItem, originalLocation: originalLocation, exportLocation: exportLocation, pages: [], currPage: 0)
            res.append(tempChapter)
        }
        return res
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
//                List($exisitingComics) { $comic in
//                    Card(comic: $comic)
//                }
                ForEach(exisitingComics, id: \.self.id) { comic in
                    Card(comic: comic)
                }
            }
                .padding(.horizontal, 4)
                .background(Color.black)
        }
            .onAppear() {
            for excomic in exisitingComics {
                print(excomic.chapters.map({ ch in
                    if ch.currPage != 0 {
                        return ch.toString()
                    } else {
                        return ""
                    }
                }))
//                deleteComic(comic: excomic)
            }
            do {
                let directoryContents = try FileManager.default.contentsOfDirectory(atPath: getDirectoryInDocuments(of: COMIC_LOCATION_NAME).path())
                for item in directoryContents {
                    if doesComicExist(comicName: item) {
//                        //                    Comic Does Exist
//                        //                    TODO: ADD CODE FOR SEARCHING AND UPDATING CHAPTERS

                        print(exisitingComics)
                    } else {
                        //                    Comic Doesnt Exist
                        //                    print(exisitingComics)
                        print (exisitingComics)
                        let isDir = FileManager.default.fileExistsAndIsDirectory(atPath: getDirectoryInDocuments(of: COMIC_LOCATION_NAME).path + "/" + item).1
                        if isDir {
                            let tempComic = Comic(name: item)
                            print("COVER: \(tempComic.cover)")
                            let directoryContents = try FileManager.default.contentsOfDirectory(atPath: getDirectoryInDocuments(of: COMIC_LOCATION_NAME).path() + "/\(item)/")
                            print("COVER: \(tempComic.cover)")
                            tempComic.chapters = findChapters(directoryContents: directoryContents, item: item, tempComic: tempComic)
                            print("COVER: \(tempComic.cover)")
//                            print(tempComic.toString())
                            //                    comics.append(tempComic)
                            //                    tempComic.writeToJson()
                            addComic(comic: tempComic)
                        } else {
                            let tempComic = Comic(name: item)
                            let originalLocation = COMIC_LOCATION_NAME + "/\(item)"
                            let exportLocation = COMIC_DATA_LOCATION_NAME + "/\(item)/"
                            let tempChapter = Chapter(name: item, originalLocation: originalLocation, exportLocation: exportLocation, pages: [], currPage: 0)
                            tempComic.chapters = [tempChapter]
                            tempComic.cover = setCoverToFirstPage(chapterName: item, originalLocation: originalLocation)
                            //                    comics.append(tempComic)
                            //                    tempComic.writeToJson()
                            addComic(comic: tempComic)
                        }
                    }
                }
            } catch {
                print("Error while retrieving directory contents: \(error)")
            }
        }
    }

    func addComic (comic: Comic) {
        context.insert(comic)
    }
    func deleteComic(comic: Comic) {
        context.delete(comic)
    }
}
