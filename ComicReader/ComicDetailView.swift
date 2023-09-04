//
//  ComicDetailView.swift
//  ComicReader
//
//  Created by Tenzin Norden on 8/25/23.
//

import SwiftUI

struct ComicDetailView: View {
    @State private var currChapter: Chapter?
    let comic: Comic

    init(comic: Comic) {
        self.comic = comic
    }

    func closeFullScreenCover(deleteLocation: String) -> Void {
        currChapter = nil
        // delete in temp
        do {
            if FileManager.default.fileExists(atPath: deleteLocation) {
                try FileManager.default.removeItem(atPath: deleteLocation)
            }
        } catch {
            print ("Error removing file: \(error)")
        }
    }

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                let image: UIImage? = UIImage(contentsOfFile: getDirectoryInDocuments(of: comic.cover).path)
                if image != nil {
                    Image(uiImage: image!)
                        .resizable()
                        .aspectRatio(5.1 / 7.2, contentMode: .fit)
                        .cornerRadius(8)
                } else {
                    Color.black
                }
                VStack {
                    Text(comic.name)
                        .foregroundColor(Color.white)
                        .lineLimit(nil)
                    Spacer()
                }
                Spacer()
            }
                .frame(maxHeight: 180)
            Text("Desc... lorem Ipsum")
            List {
                ForEach(comic.chapters.sorted(by: { c1, c2 in
                    return c1.name < c2.name
                }), id: \.id) { chapter in
//                    NavigationLink(destination: ComicView(chapter: chapter), label: {
//                            Text(chapter.name)
//                                .lineLimit(1)
//                                .foregroundColor(Color.white)
//                        }
//                    )
                    Text(chapter.name)
                        .lineLimit(1)
                        .foregroundColor(Color.white)
                        .onTapGesture {
                        currChapter = chapter
                    }
                }
            }
                .fullScreenCover(item: $currChapter, content: { currChapter in
                ComicView(comic: comic, chapter: currChapter, close: closeFullScreenCover)
            })
        }
    }
}

//struct ComicDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ComicDetailView()
//    }
//}
