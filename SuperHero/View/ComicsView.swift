//
//  ComicsView.swift
//  SuperHero
//
//  Created by Akshay Kalucha on 03/03/22.
//

import SwiftUI
import SDWebImageSwiftUI


struct ComicsView: View {
    @EnvironmentObject var homeData: MainViewModel
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Image("bg")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .aspectRatio(geometry.size, contentMode: .fill)
                    ScrollView(.vertical, showsIndicators: true) {
                        if homeData.fetchedComics.isEmpty {
                            ProgressView()
                                .padding(.top, 30)
                        }
                        else {
                            VStack(spacing: 15) {
                                ForEach(homeData.fetchedComics){ comic in
                                    ComicRowView(character: comic)
                                }
                                if homeData.offset == homeData.fetchedComics.count {
                                    ProgressView()
                                        .padding(.vertical)
                                        .onAppear {
                                            print("fetching")
                                            homeData.fetchComics()
                                        }
                                } else {
                                    GeometryReader{reader -> Color in
                                        let minY = reader.frame(in: .global).minY
                                        let height = UIScreen.main.bounds.height / 1.3
                                        
                                        if !homeData.fetchedComics.isEmpty && minY < height {
                                            print("last")
                                            DispatchQueue.main.async {
                                                homeData.offset = homeData.fetchedComics.count
                                            }
                                        }
                                        return Color.clear
                                    }
                                    .frame(width: 20, height: 20)
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                    .navigationTitle("Top Comics")
                }
                .onAppear {
                    if homeData.fetchedComics.isEmpty {
                        homeData.fetchComics()
                    }
                }
            }
            
        }
    }
}

struct ComicsView_Previews: PreviewProvider {
    static var previews: some View {
        ComicsView().environmentObject(MainViewModel())
    }
}




struct ComicRowView: View {
    var character: Comic
    
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            WebImage(url: extractImage(data: character.thumbnail))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 170, height: 170)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(character.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.top, 4)
                if let description = character.description {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.white)
                        .lineLimit(4)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                Button {

                } label: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.orange)
                        .overlay (
                        Text("Details")
                            .foregroundColor(Color.black)
                            .font(.system(size: 12))
                        )
                        .frame(width: 60, height: 20)
                        .padding(.bottom, 5)
                }
            }
            Spacer(minLength: 0)
        }
        .background(Color(red: 236/255, green: 166/255, blue: 166/255).opacity(0.6))
        .cornerRadius(8)
        .frame(width: UIScreen.main.bounds.width * 0.97)
        .padding(.bottom, 6)
    }
    
    func extractImage(data: [String: String])-> URL {
        let path = data["path"] ?? ""
        let ext = data["extension"] ?? ""
        return URL(string: "\(path).\(ext)")!
    }
}

