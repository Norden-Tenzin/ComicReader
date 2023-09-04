//
//  Card.swift
//  ComicReader
//
//  Created by Tenzin Norden on 8/23/23.
//

import SwiftUI

struct Card: View {
    let comic: Comic

    var body: some View {
        NavigationLink(destination: ComicDetailView(comic: comic),
            label: {
                ZStack {
                    let image: UIImage? = UIImage(contentsOfFile: getDirectoryInDocuments(of: comic.cover).path)
                    if image != nil {
                        Image(uiImage: image!)
                            .resizable()
                            .aspectRatio(5.1 / 7.2, contentMode: .fit)
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Color.black
                    }
                    Rectangle().fill(
                        Gradient(stops: [
                                .init(color: .clear, location: 0.5),
                                .init(color: .black, location: 1.40)
                            ]
                        )
                    )
                    VStack(alignment: .leading) {
                        Spacer()
                        Text(comic.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(2)
                            .font(.system(size: 14, weight: .bold))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.white)
                            .padding(.all, 10)
                            .shadow(color: Color.black, radius: 5)
                    }
                }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(Color.white)
                    .cornerRadius(8)
            }
        )
    }
}
