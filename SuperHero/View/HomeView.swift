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
        TabView {
            CharactersView()
                .tabItem{
                    Image(systemName: "person.3.fill")
                    Text("Characters")
                }
                .environmentObject(dm)
            Text("Comics")
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Comics")
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
