//
//  GifView.swift
//  SuperHero
//
//  Created by Akshay Kalucha on 01/03/22.
//

import SwiftUI
import SDWebImageSwiftUI
import WebKit

struct GifView: View {
    @State var animationFinished: Bool = false
    @State var animationStarted: Bool = false
    @State var removeGif: Bool = false
    var body: some View {
        ZStack{
            if !animationFinished{
                ZStack {
                    Color.white
                        .ignoresSafeArea()
                    
                    AnimatedImage(url: getImgURL())
                        .resizable()
                        .ignoresSafeArea()
                }
                .opacity(animationFinished ? 0: 1)
            }else{
                HomeView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.9) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    animationFinished = true
                }
            }
        }
    }
    
    func getImgURL() -> URL {
        let bundle = Bundle.main.path(forResource: "marveldc", ofType: "gif")
        let url = URL(fileURLWithPath: bundle ?? "")
        return url
    }
}

struct GifView_Previews: PreviewProvider {
    static var previews: some View {
        GifView()
    }
}
