//
//  ContentView.swift
//  Fair Profile Page
//
//  Created by Muhammad on 03/11/26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isExpanded = false
    @State private var scrollY: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ScrollView {
                    let topInset = geo.safeAreaInsets.top
                    
                    VStack(alignment: .center, spacing: 16) {
                        avatar(width: geo.size.width, topInset: topInset)
                            .onGeometryChange(for: CGFloat.self) { proxy in
                                proxy.frame(in: .named("scroll")).minY
                            } action: { y in
                                handleScroll(y: y)
                            }
                    }
                }
                .frame(width: geo.size.width)
                .coordinateSpace(name: "scroll")
                .scrollIndicators(.hidden)
                .ignoresSafeArea(edges: .top)
            }
            .padding(.top, 16)
        }
    }
    
    private func handleScroll(y: CGFloat) {
        print("y is: \(y)")
        scrollY = y
    }
    
    @ViewBuilder
    private func avatar(width: CGFloat, topInset: CGFloat) -> some View {
        
        let avatarRect: CGRect = isExpanded ?
            CGRect(x: 0, y: 0, width: width, height: width)
        : CGRect(x: 0, y: 0, width: 150, height: 150)
        
        let avatarRadius: CGFloat = isExpanded ? 0 : avatarRect.width / 2
        
        
        Image(.avatar)
            .resizable()
            .scaledToFill()
            .frame(width: avatarRect.width, height: avatarRect.height)
            .cornerRadius(avatarRadius)
            .onTapGesture {
                withAnimation {
                    isExpanded = !isExpanded
                }
            }
    }
}

#Preview {
    ContentView()
}

