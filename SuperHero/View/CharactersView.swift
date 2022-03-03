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
    private enum Field: Int {
        case yourTextEdit
    }
    @FocusState private var focusedField: Field?
    
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Image("bg")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .aspectRatio(geometry.size, contentMode: .fill)
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(spacing: 15) {
                            HStack(spacing: 10) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                TextField("Superhero", text: $dm.searchQuery)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                //                                .focused($focusedField, equals: .yourTextEdit)
                                    .foregroundColor(Color.black)
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.09), radius: 5, x: 5, y: 5)
                            .shadow(color: Color.black.opacity(0.09), radius: 5, x: -5, y: -5)
                        }
                        .padding()
                        
                        if let characters = dm.fetchedCharacters{
                            if characters.isEmpty{
                                if dm.NoRes {
                                    Text("No result found")
                                        .padding(.top, 20)
                                } else{
                                    ProgressView()
                                        .padding(.top, 20)
                                }
                            } else {
                                ForEach(characters){ data in
                                    CharacterRowView(character: data)
                                }
                            }
                        }
                        if dm.mainOffset == dm.fetchedCharacters.count && !dm.firstLoad && dm.searchQuery == "" {
                            ProgressView()
                                .padding(.vertical)
                                .onAppear {
                                    print("fetching")
                                    dm.fetchData()
                                }
                        } else {
                            GeometryReader{reader -> Color in
                                let minY = reader.frame(in: .global).minY
                                let height = UIScreen.main.bounds.height / 1.3
                                
                                if !dm.fetchedCharacters.isEmpty && minY < height {
                                    print("last")
                                    DispatchQueue.main.async {
                                        dm.mainOffset = dm.fetchedCharacters.count
                                    }
                                    
                                }
                                return Color.clear
                            }
                        }
                    }.onAppear {
                        UIScrollView.appearance().keyboardDismissMode = .onDrag
                    }
                    //            }
                    //            .onTapGesture {
                    //                // Hide Keyboard
                    //                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    //            }
                    //            .gesture(
                    //                DragGesture(minimumDistance: 0, coordinateSpace: .local).onEnded({ gesture in
                    //                    // Hide keyboard on swipe down
                    //                    if gesture.translation.height > 0 {
                    //                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    //                    }
                    //            }))
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
                    .foregroundColor(.white)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
            }
            Spacer(minLength: 0)
        }
        .background(.black.opacity(0.4))
        .cornerRadius(8)
        .frame(height: 180)
        .padding(.horizontal)
    }
    
    func extractImage()-> String {
        let path = character.thumbnail.path
        let ext = character.thumbnail.ext
        return "\(path).\(ext)"
    }
}
