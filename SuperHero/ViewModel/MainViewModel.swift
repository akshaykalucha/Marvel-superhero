//
//  MainViewModel.swift
//  SuperHero
//
//  Created by Akshay Kalucha on 28/02/22.
//

import Foundation
import SwiftUI
import Combine

class MainViewModel: ObservableObject {
    @Published var name = ""
    @Published var isLoading: Bool = false
    @Published var results: [Result] = []
    @Published var offset: Int = 0
    @Published var searchQuery = ""
    @Published var fetchedCharacters: [Result] = []
    // Cancel the search publisher whenevrver needed
    var searchCancellable: AnyCancellable? = nil
    @Published var fetchedComics: [Comic] = []
    @Published var mainOffset: Int = 0
    @Published var firstLoad: Bool = false
    @Published var NoRes: Bool = false
    
    var toSearch: Bool = false
    
    var loadAgain: Bool = false
    
    init() {
        firstLoad = true
        fetchData()
        searchCancellable = $searchQuery
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: { str in
                if str == "" {
                    if self.loadAgain {
                        self.fetchedCharacters = []
                        self.mainOffset = 0
                        self.fetchData()
                        self.toSearch = false
                        self.loadAgain = false
                    }
                    self.mainOffset = 0
                    self.NoRes = false
                    print("empty query")
                }else { self.NoRes = false }
                for chr in self.searchQuery{
                    if chr != " "{
                        self.toSearch = true
                    }
                }
                print(str)
//                if str == "" {
//                    self.fetchedCharacters = nil
//
//                } else {
                if self.toSearch{
                    self.fetchedCharacters = []
                    self.searchCharacter(ch: str)
                }
                //                }
            })
    }
    func searchCharacter(ch: String){
        let originalQuery = searchQuery.replacingOccurrences(of: " ", with: "%20")
        print(originalQuery)
        let url = "https://gateway.marvel.com/v1/public/characters?nameStartsWith=\(originalQuery)&apikey=3fb5c86240a009ead7052eb4aad4d08c&ts=1646036094096&hash=711d7a634d78f820f2fc380aaffa6c4f"
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string:url)!) { (data, _, err) in
            if let error = err{
                print(error.localizedDescription)
                return
            }
            guard let APIData = data else {
                print("NO data found")
                return
            }
            do {
                let characters = try JSONDecoder().decode(APIResult.self, from: APIData)
                DispatchQueue.main.async {
                    if characters.data.results.count == 0 {
                        self.NoRes = true
                    }else{
                        self.NoRes = false
                    }
                    self.firstLoad = true
                    self.loadAgain = true
//                    if self.fetchedCharacters == nil {
                        self.fetchedCharacters = characters.data.results
//                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        .resume()
    }

    func fetchComics(){
        let url = "https://gateway.marvel.com/v1/public/comics?limit=20&offset=\(self.offset)&apikey=3fb5c86240a009ead7052eb4aad4d08c&ts=1646036094096&hash=711d7a634d78f820f2fc380aaffa6c4f"
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string:url)!) { (data, _, err) in
            if let error = err{
                debugPrint(error)
                return
            }
            guard let APIData = data else {
                print("NO data found")
                return
            }
            do {
                let characters = try JSONDecoder().decode(APIComicResult.self, from: APIData)
                DispatchQueue.main.async {
                    self.fetchedComics.append(contentsOf: characters.data.results)
                }
            } catch {
                debugPrint(error)
            }
        }
        .resume()
    }
    
    
    func shouldLoadData (id: Int)-> Bool {
        return id == results.count - 1
    }
    func fetchData() {
        if self.results.count == 0 {
            isLoading = true
        }
        guard let url = URL(string:"https://gateway.marvel.com/v1/public/characters?apikey=3fb5c86240a009ead7052eb4aad4d08c&ts=1646036094096&hash=711d7a634d78f820f2fc380aaffa6c4f&offset=\(self.mainOffset)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with:url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                DispatchQueue.main.async {
                    self.name = response.etag
                    self.isLoading = false
                    self.firstLoad = false
                    self.fetchedCharacters.append(contentsOf: response.data.results)
                    for index in 0..<response.data.results.count{
                        let id = response.data.results[index].id
                        let name = response.data.results[index].name
                        let mod = response.data.results[index].modified
                        let thp = response.data.results[index].thumbnail
                        let desc = response.data.results[index].description
                        let myres = Result(id: id, name: name, description: desc, modified: mod, thumbnail: thp)
                        self.results.append(myres)
                    }
                }
            }
            
            catch{
                print(error)
            }
            
        }
        task.resume()
    }
}
