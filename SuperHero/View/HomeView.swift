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
        ScrollView {
            VStack{
                if dm.isLoading{
                    Text("Loading...")
                }else {
                    ForEach(dm.results, id:\.self){ item in
                        Text("\(item.name)")
                        AsyncImage(url: URL(string:"\(item.thumbnail.path).jpg")) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 500, height: 500)
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
