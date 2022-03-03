//
//  NewView.swift
//  SuperHero
//
//  Created by Akshay Kalucha on 03/03/22.
//

import SwiftUI

struct NewView: View {
    @State private var text = "Hello, world!"

    var body: some View {
        ScrollView {
            TextField("Hello", text: $text)
                .padding()
        }
        .onAppear {
            UIScrollView.appearance().keyboardDismissMode = .onDrag
        }
    }
}
struct NewView_Previews: PreviewProvider {
    static var previews: some View {
        NewView()
    }
}
