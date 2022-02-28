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
        VStack{
            if dm.isLoading{
                Text("Loading...")
            }else{
                Text(dm.name)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
