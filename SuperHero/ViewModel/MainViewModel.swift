//
//  MainViewModel.swift
//  SuperHero
//
//  Created by Akshay Kalucha on 28/02/22.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var name = ""
    @Published var isLoading: Bool = false
    @Published var results: [Result] = []
    @Published var offset: Int = 0
    
    init() {
        fetchData()
    }

    func shouldLoadData (id: Int)-> Bool {
        return id == results.count - 1
    }
    func fetchData() {
        if self.results.count == 0 {
            isLoading = true
        }
        guard let url = URL(string:"https://gateway.marvel.com/v1/public/characters?apikey=3fb5c86240a009ead7052eb4aad4d08c&ts=1646036094096&hash=711d7a634d78f820f2fc380aaffa6c4f&offset=\(self.offset)") else {
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
                    for index in 0..<response.data.results.count{
                        let id = response.data.results[index].id
                        let name = response.data.results[index].name
                        let mod = response.data.results[index].modified
                        let thp = response.data.results[index].thumbnail
                        let myres = Result(id: id, name: name, modified: mod, thumbnail: thp)
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
