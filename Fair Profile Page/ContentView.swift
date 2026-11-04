//
//  ContentView.swift
//  Fair Profile Page
//
//  Created by Muhammad on 03/11/26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var infoBlockHeight: CGFloat = 170
    @State private var isExpanded = false
    @State private var scrollY: CGFloat = 0
    
    let image: Image = Image(.avatar)
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let topInset = geo.safeAreaInsets.top
            
            ZStack {
                background
                
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
        : CGRect(x: (width - circleSize) / 2, y: topInset + ProfileLayout.avatarTop, width: circleSize, height: circleSize)
        
        let cornerRadius = isExpanded ? 0 : circleSize / 2
        
        let infoTop: CGFloat = isExpanded
            ? expandedHeight - infoBlockHeight - 14
        : topInset + ProfileLayout.avatarTop + circleSize + ProfileLayout.avatarToInfo
        
        let blurStart = (avatarRect.height - infoBlockHeight) / max(avatarRect.height, 1)
        
        ZStack(alignment: .topLeading) {
            AvatarSurface(
                isExpanded: isExpanded,
                blurStart: blurStart,
                image: image
            )
            .frame(width: avatarRect.width, height: avatarRect.height)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .offset(x: avatarRect.minX, y: avatarRect.minY)
            .onTapGesture {
                withAnimation {
                    isExpanded = !isExpanded
                }
            }
            
            ProfileInfoBlock(
                name: "Muhammad",
                status: "last seen just now",
                isExpanded: isExpanded
            )
            .frame(width: width)
            .onGeometryChange(for: CGFloat.self) { proxy in
                proxy.size.height
            } action: { newValue in
                infoBlockHeight = newValue
            }
            .offset(y: infoTop)
            
        }
    }
    
    private var background: some View {
        LinearGradient(colors: [ProfilePalette.pageTop, ProfilePalette.page],
                       startPoint: .top, endPoint: .init(x: 0.5, y: 0.45))
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}

