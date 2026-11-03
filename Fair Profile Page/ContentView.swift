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
            let width = geo.size.width
            let topInset = geo.safeAreaInsets.top
            
            VStack {
                ScrollView {
                    VStack(alignment: .center, spacing: 16) {
                        avatar(width: width, topInset: topInset)
                            .onGeometryChange(for: CGFloat.self) { proxy in
                                proxy.frame(in: .named("scroll")).minY
                            } action: { y in
                                handleScroll(y)
                            }
                        
                    }
                    .frame(width: geo.size.width)
                }
                .coordinateSpace(name: "scroll")
                .scrollIndicators(.hidden)
                .ignoresSafeArea(edges: .top)
            }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: isExpanded)
    }
    
    private func handleScroll(_ y: CGFloat) {
        print("y: \(y)")
        if y == scrollY {
            return
        }
        
        scrollY = y
        
        if !isExpanded, y > 70 {
            withAnimation {
                isExpanded = true
            }
        } else if isExpanded, y < -24 {
            withAnimation {
                isExpanded = false
            }
        }
    }
    
    @ViewBuilder
    private func avatar(width: CGFloat, topInset: CGFloat) -> some View {
        let expandedHeight = width * 1.2
        
        // circleSize = avatarSize * (1 + (nechaFoizScroll * scale))
        let overScroll = max(scrollY, 0)
        let pull = overScroll / 70
        let circleSize = 100 * (1 + (pull * 0.15))
        
        let avatarRect = isExpanded ? CGRect(x: 0, y: 0, width: width, height: expandedHeight)
            : CGRect(x: 0, y: topInset + 8, width: circleSize, height: circleSize)
        
        let cornerRadius = isExpanded ? 0 : circleSize / 2
        
        Image(.avatar)
            .resizable()
            .scaledToFill()
            .frame(width: avatarRect.width, height: avatarRect.height)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .offset(x: avatarRect.minX, y: avatarRect.minY)
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

