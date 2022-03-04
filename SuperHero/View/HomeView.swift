//
//  HomeView.swift
//  SuperHero
//
//  Created by Akshay Kalucha on 28/02/22.
//

import SwiftUI

struct HomeView: View {
    @StateObject var dm = MainViewModel()
    init() {
        UITabBar.appearance().barTintColor = UIColor.black
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundColor = UIColor.black
    }
    var body: some View {
        TabView {
            CharactersView()
                .clipped()
                .tabItem{
                    Image(systemName: "person.3.fill")
                    Text("Characters")
                }
                .environmentObject(dm)
            ComicsView()
                .clipped()
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Comics")
                }
                .environmentObject(dm)
        }.accentColor(.orange)
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
