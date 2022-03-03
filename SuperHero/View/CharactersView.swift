//
//  CharactersView.swift
//  SuperHero
//
//  Created by Akshay Kalucha on 03/03/22.
//

import SwiftUI

struct CharactersView: View {
    @EnvironmentObject var dm: MainViewModel
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Superhero", text: $dm.searchQuery)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.06), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.06), radius: 5, x: -5, y: -5)
                }
                .padding()
                
                if let characters = dm.fetchedCharacters{
                    if characters.isEmpty{
                        Text("No results...")
                            .padding(.top, 20)
                    } else {
                        ForEach(characters){ data in
                            Text(data.name)
                        }
                    }
                }
                else {
                    if dm.searchQuery != "" {
                        ProgressView()
                            .padding(.top, 20)
                    }
                }
            }
            .navigationTitle("Marvel")
        }
    }
}

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
