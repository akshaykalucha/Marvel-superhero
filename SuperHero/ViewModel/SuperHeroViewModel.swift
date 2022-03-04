//
//  SuperHeroViewModel.swift
//  SuperHero
//
//  Created by Akshay Kalucha on 04/03/22.
//

import Foundation
import SwiftUI
import Combine

class SuperHero: ObservableObject {
    @Published var name:String = ""
    
    
    let baseUrl: String = "https://www.superheroapi.com/api.php/338148107599656"
    
    func callSAPI(ch:String) {
        guard let url = URL(string: "\(baseUrl)/search/\(ch)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let response = try JSONDecoder().decode(SPResponse.self, from: data)
                print(response)
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
}
