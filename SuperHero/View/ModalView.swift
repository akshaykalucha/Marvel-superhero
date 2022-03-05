//
//  NewView.swift
//  SuperHero
//
//  Created by Akshay Kalucha on 03/03/22.
//

import SwiftUI

struct ModalView: View {
    @EnvironmentObject var vm: MainViewModel
    @State private var isDragging = false
    @State private var currHeight: CGFloat = 400
    let minHeight: CGFloat = 400
    let maxHeight: CGFloat = 700
    let startOpacity: Double = 0.4
    let endOpacity: Double = 0.8
    
    var percentage: Double {
        let res = Double((currHeight - minHeight) / (maxHeight - minHeight))
        return max(0, min(1,res))
    }
    var body: some View {
        ZStack(alignment: .bottom) {
            if vm.isShowingModal {
                Color.black.opacity(startOpacity + (endOpacity - startOpacity) * percentage).ignoresSafeArea()
                    .onTapGesture {
                        vm.isShowingModal = false
                    }
                mainView
                .transition(.move(edge: .bottom))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut)
    }
    
    
    var mainView: some View {
        VStack {
            ZStack{
                Capsule()
                    .frame(width: 40, height: 5)
                    .foregroundColor(Color.black)
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.00001))
            .gesture(dragGesture)
            ZStack{
                VStack{
                    Text("This is a marvel comic modal to view your favourite super heroes")
                        .foregroundColor(Color.black)
                        .font(.system(size: 25, weight: .regular))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 10)
                    Text("iron man")
                        .foregroundColor(Color.black)
                        .font(.system(size: 20, weight: .bold))
                }
                .padding(.horizontal, 30)
            }
            .frame(maxHeight: .infinity)
            .padding(.bottom, 35)
        }
        .frame(height: currHeight)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                Rectangle()
                    .frame(height: currHeight / 2)
            }
                .foregroundColor(.white)
        )
        .animation(isDragging ? nil : .easeInOut(duration: 0.45))
        .onDisappear {
            currHeight = minHeight
        }
    }
    
    @State private var prevDragTranslation = CGSize.zero
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { val in
                if !isDragging {
                    isDragging = true
                }
                let dragAmount = val.translation.height - prevDragTranslation.height
                if currHeight > maxHeight || currHeight < minHeight {
                    currHeight -= dragAmount / 6
                }else{
                    currHeight -= dragAmount
                }
                prevDragTranslation = val.translation
            }
            .onEnded { val in
                prevDragTranslation = .zero
                isDragging = false
                if currHeight > maxHeight {
                    currHeight = maxHeight
                } else if currHeight < minHeight{
                    currHeight = minHeight
                }
            }
    }
    
}
struct NewView_Previews: PreviewProvider {
    @State private var show = false
    static var previews: some View {
        CharactersView().environmentObject(MainViewModel())
    }
}
