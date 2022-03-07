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
    @State private var showModall = false
    
    //    @StateObject var sm = SuperHero()
    
//    private enum Field: Int {
//        case yourTextEdit
//    }
//    @FocusState private var focusedField: Field?
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("bg")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .aspectRatio(geometry.size, contentMode: .fill)
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 15) {
                        Text("Superhero")
                            .font(Font.custom("BADABB__", size: 40))
                        HStack(spacing: 10) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Your favourite character", text: $dm.searchQuery)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
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
//                                print("fetching")
                                dm.fetchData()
                            }
                    } else {
                        GeometryReader{reader -> Color in
                            let minY = reader.frame(in: .global).minY
                            let height = UIScreen.main.bounds.height / 1.3
                            
                            if !dm.fetchedCharacters.isEmpty && minY < height {
//                                print("last")
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
            }
            ModalView()
        }
        .navigationTitle("Superheroes")
    }
}


struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersView().environmentObject(MainViewModel())
    }
}



struct CharacterRowView: View {
    var character: Result
    @EnvironmentObject var vm: MainViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            WebImage(url: URL(string: extractImage()))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 170, height: 170)
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 5, y: 5)
                .shadow(color: Color.black.opacity(0.5), radius: 5, x: -5, y: -5)
            VStack(alignment: .leading, spacing: 8) {
                Text(character.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.top, 4)
                Text(character.description)
                    .font(.caption)
                    .foregroundColor(.white)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                Spacer()
                Button {
                    vm.modalData = self.character
                    vm.isShowingModal = true
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
    
    func extractImage()-> String {
        let path = character.thumbnail.path
        let ext = character.thumbnail.ext
        return "\(path).\(ext)"
    }
}
