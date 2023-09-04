//
//  ComicView.swift
//  ComicReader
//
//  Created by Tenzin Norden on 8/24/23.
//

import SwiftUI
import SwiftUIPager
import SwiftData

class PageClass: ObservableObject {
    @Published var page: Page = Page.withIndex(0)
}

struct ComicView: View {
    @Environment(\.modelContext) private var context

//    @Query var currComic: [Comic]

    @State var pageObj: PageClass = PageClass()
    @State var pageNumber: Double
    @State var sliderIndex: Double
    @State var isOverlayActive: Bool = false
    @State var loaded: Bool = false
    @State var tempLocation: String = ""
    @State var deleteLocation: String = ""
    @State var pages: [UIImage]
    var close: (String) -> Void
    var comic: Comic

    var chapter: Chapter

    init(comic: Comic, chapter: Chapter, close: @escaping (String) -> Void) {
        self.comic = comic
        self.chapter = chapter
        self.close = close
        self.sliderIndex = Double(chapter.currPage)
        self.pages = []
        self.pageNumber = 0
        self.chapter.totalPages = 1
    }

    private func sliderChanged(to newValue: Double) {
        pageNumber = newValue
        let roundedValue = Int(pageNumber)
//        chapter.currPage = roundedValue
        updateComic(newIndex: roundedValue)
        pageObj.page.update(Page.Update.new(index: roundedValue))
    }

    var body: some View {
        if loaded == false {
            ProgressView()
                .onAppear {
                DispatchQueue.main.async {
                    tempLocation = getDirectoryInDocuments(of: COMIC_DATA_LOCATION_NAME).path + "/temp/\(comic.name)/\(chapter.name)/"
                    createDirectoryInDocuments(dirName: COMIC_DATA_LOCATION_NAME + "/temp/\(comic.name)/\(chapter.name)/")
                    deleteLocation = getDirectoryInDocuments(of: COMIC_DATA_LOCATION_NAME).path + "/temp/\(comic.name)/"

                    print(getDirectoryInDocuments(of: chapter.originalLocation).path)
                    print(tempLocation)

                    print(FileManager.default.fileExists(atPath: getDirectoryInDocuments(of: chapter.originalLocation).path))
                    print(FileManager.default.fileExists(atPath: tempLocation))

                    unzipCBZFile(at: getDirectoryInDocuments(of: chapter.originalLocation).path, to: tempLocation)
                    chapter.pages = getComicPages(at: tempLocation)

                    func getAllPages(chapter: Chapter) -> [UIImage] {
                        var res: [UIImage] = []
                        for pageLoc in chapter.pages {
                            res.append(UIImage(contentsOfFile: tempLocation + "/" + pageLoc)!)
                        }
                        return res
                    }
                    pages = getAllPages(chapter: chapter)
                    chapter.totalPages = pages.count
                    pageNumber = Double(chapter.currPage)
                    loaded = true
                }
            }
        } else {
            ZStack {
                Pager(
                    page: pageObj.page,
                    data: pages,
                    id: \.self,
                    content: { pageImage in
                        ZoomableContainer {
                            Image(uiImage: pageImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                )
                    .allowsDragging(true)
                    .onPageChanged { index in
//                    chapter.currPage = index
//                    UPDATE THE PAGE NUMBER
                    updateComic(newIndex: index)
                }
                    .onPageWillChange { index in
                    pageNumber = Double(index)
                }
                    .gesture(TapGesture(count: 1).onEnded({ void in
                        isOverlayActive.toggle()
                    }))
                VStack {
                    HStack {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .bold))
                            .padding([.top, .leading, .bottom], 15)
                            .padding(.trailing, 5)
                            .onTapGesture {
                            close(deleteLocation)
                        }
                        VStack(alignment: .leading) {
                            Text(chapter.name)
                                .font(.system(size: 20, weight: .bold))
                                .lineLimit(1)
                            Text(comic.name)
                                .font(.system(size: 16))
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                        .background(Color.gray)
                    Spacer()
                    HStack {
                        ZStack {
                            Circle()
                                .foregroundColor(Color.gray)
                                .frame(width: 50)
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .bold))
                                .padding([.top, .leading, .bottom], 10)
                                .padding(.trailing, 10)
                        }
                        HStack {
                            Text("\(Int(pageNumber) + 1)")
                                .frame(maxWidth: 40)
                            Slider(
                                value: $sliderIndex,
                                in: 0...Double(chapter.totalPages - 1),
                                step: 1)
                                .onChange(of: sliderIndex) { oldValue, newValue in
                                sliderChanged(to: newValue)
                            }
                            Text("\(chapter.totalPages)")
                                .frame(maxWidth: 40)
                        }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 10)
                            .background(Color.gray)
                            .cornerRadius(30)
                        ZStack {
                            Circle()
                                .foregroundColor(Color.gray)
                                .frame(width: 50)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20, weight: .bold))
                                .padding([.top, .trailing, .bottom], 10)
                                .padding(.leading, 10)
                        }
                    }
                        .padding(.horizontal, 10)
                    HStack {
                        Spacer()
                        Image(systemName: "gearshape.arrow.triangle.2.circlepath")
                            .font(.system(size: 25))
                        Spacer()
                        Image(systemName: "crop")
                            .font(.system(size: 25))
                        Spacer()
                        Image(systemName: "arrow.turn.up.forward.iphone")
                            .font(.system(size: 25))
                        Spacer()
                        Image(systemName: "gear")
                            .font(.system(size: 25))
                        Spacer()
                    }
                        .padding(.top, 20)
                        .padding(.bottom, 5)
                        .background(Color.gray)
                        .padding(.top, 5)
                }
                    .opacity(isOverlayActive ? 1.0 : 0)
                    .animation(.easeInOut(duration: 0.25), value: isOverlayActive)
            }
        }
    }

    func updateComic(newIndex: Int) {
//        let predicate =
        let comics = Query(filter: #Predicate<Comic> {
            return $0.id.uuidString != comic.id.uuidString
        })

        print(comics)
//        if let fetchedComic = comics.first {
//            print(fetchedComic.toString())
//        }




//        let predicate = #Predicate<Comic> { passedComic in
//            passedComic.id == comic.id
//        }
//        let descriptor = FetchDescriptor<Comic>(predicate: predicate)
//        do {
//            let comics = try context.fetch(descriptor)
//            if let fetchedComic = comics.first {
//                print(fetchedComic.toString())
//            }
//        } catch {
//            print("ERROR: Failed to fetch Chapter: \(error)")
//        }
//        let predicate = #Predicate<Chapter> { storedChapter in
//            storedChapter.id == chapter.id
//        }
//        let descriptor = FetchDescriptor<Chapter>(predicate: predicate)
//        do {
//            let chapters = try context.fetch(descriptor)
//            if let chapter = chapters.first {
//                chapter.currPage = newIndex
//            }
//        } catch {
//            print("ERROR: Failed to fetch Chapter: \(error)")
//        }
    }
//        let indexToChange = comic.chapters.firstIndex { Chapter in
//            return Chapter == chapter
//        }
//        if indexToChange != nil {
//            comic.chapters[indexToChange!].currPage = newIndex
//        } else {
//            fatalError("COMIC PAGE NUMBER COULDNT BE SET")
//        }
//        do {
//            try context.save()
//        } catch {
//            print(error.localizedDescription)
//        }
}
