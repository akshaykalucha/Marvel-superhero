//
//  HomeView.swift
//  SuperHero
//
//  Created by Akshay Kalucha on 28/02/22.
//

import SwiftUI

struct HomeView: View {
    @StateObject var dm = MainViewModel()

    var body: some View {
        VStack{
            if dm.isLoading{
                ProgressView()
            }else {
                ScrollView{
                    VStack {
                        ForEach(0..<dm.results.count, id:\.self){ index in
                            Text("\(dm.results[index].name)")
//                                .onAppear(perform: {
//                                    print(index)
//                                    if dm.shouldLoadData(id: index) {
//                                            dm.offset += 10
//                                            dm.fetchData()
//                                    }
//                                })
                            AsyncImage(url: URL(string:"\(dm.results[index].thumbnail.path).\(dm.results[index].thumbnail.ext)")) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 400, height: 500)
                            .cornerRadius(15)
                        }
                        GeometryReader{reader -> Color in
                            let minY = reader.frame(in: .global).minY
                            let height = UIScreen.main.bounds.height / 1.3
                            
                            if !dm.results.isEmpty && minY < height {
                                print("last")
                                DispatchQueue.main.async {
                                    dm.offset += 20
                                    dm.fetchData()
                                }
                            }
                            
                            return Color.clear
                        }
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
                .preferredColorScheme(.dark)
        }
    }
}
