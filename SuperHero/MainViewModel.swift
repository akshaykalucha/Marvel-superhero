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
    
    init() {
        fetchData()
    }
    func fetchData() {
        isLoading = true
        guard let url = URL(string:"https://gateway.marvel.com/v1/public/characters?apikey=3fb5c86240a009ead7052eb4aad4d08c&ts=1646036094096&hash=711d7a634d78f820f2fc380aaffa6c4f") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with:url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let model = try JSONDecoder().decode(Response.self, from: data)
                DispatchQueue.main.async {
                    self.name = model.etag
                    self.isLoading = false
                }
            }
            catch{
                print("error")
            }
            
        }
        task.resume()
    }
}
