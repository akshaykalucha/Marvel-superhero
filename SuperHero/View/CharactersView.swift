//
//  CharactersView.swift
//  SuperHero
//
//  Created by Akshay Kalucha on 03/03/22.
//

import SwiftUI
import SDWebImageSwiftUI

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
                            .autocapitalization(.none)
                            .disableAutocorrection(true )
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
                            CharacterRowView(character: data)
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


struct CharacterRowView: View {
    var character: Result
    
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            WebImage(url: URL(string: extractImage()))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(character.name)
                    .font(.title3)
                    .fontWeight(.bold)
                Text(character.description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal)
    }
    
    func extractImage()-> String {
        let path = character.thumbnail.path
        let ext = character.thumbnail.ext
        return "\(path).\(ext)"
    }
}
