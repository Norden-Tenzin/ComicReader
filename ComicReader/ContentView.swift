//
//  ContentView.swift
//  ComicReader
//
//  Created by Tenzin Norden on 8/16/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query private var exisitingComics: [Comic]

    @State private var selectedTab: Int = 0

    let tabs: [Tab] = [
            .init(icon: Image(systemName: "music.note"), title: "Music"),
//            .init(icon: Image(systemName: "film.fill"), title: "Movies"),
//            .init(icon: Image(systemName: "book.fill"), title: "Books")
    ]

    init() {
        print("HERE1")
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = UIColor(Color.black)
//        UINavigationBar.appearance().standardAppearance = appearance
//        UINavigationBar.appearance().scrollEdgeAppearance = appearance
//        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
//        UINavigationBar.appearance().isTranslucent = false
    }

    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack(spacing: 0) {
                    // Tabs
                    Tabs(tabs: tabs, geoWidth: geo.size.width, selectedTab: $selectedTab)
                    // Views
                    TabView(selection: $selectedTab,
                        content: {
                            LibraryView(demoText: "Music View")
                                .tag(0)
//                            LibraryView(demoText: "Movies View")
//                                .tag(1)
//                            LibraryView(demoText: "Books View")
//                                .tag(2)
                        })
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
                    .foregroundColor(Color.black)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("Library")
            }
        }
    }
}

//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
