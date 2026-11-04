//
//  AvatarSurface.swift
//  Fair Profile Page
//
//  Created by Muhammad on 04/11/26.
//

import SwiftUI

struct AvatarSurface: View {
    let image: Image
    let isExpanded: Bool
    let blurStart: CGFloat
    
    var body: some View {
        fill(image)
        
        fill(image)
            .blur(radius: 22, opaque: true)
            .mask(
                LinearGradient(stops: [
                    // bu yerdan boshlab blur kesilgandek ko'rinadi
                    .init(color: .clear, location: blurStart),
                    // bu yerdan boshlab blur + color bo'ladi
                    .init(color: .black, location: min(blurStart + 0.18, 1))
                ], startPoint: .top, endPoint: .bottom)
            )
            .opacity(isExpanded ? 1 : 0)
        
        LinearGradient(stops: [
            .init(color: ProfilePalette.page.opacity(0), location: blurStart + 0.2),
            .init(color: ProfilePalette.page.opacity(0.45), location: min(blurStart + 0.3, 1)),
            .init(color: ProfilePalette.page, location: 1)
        ], startPoint: .top, endPoint: .bottom)
        .opacity(isExpanded ? 1 : 0)
    }
    
    private func fill(_ image: Image) -> some View {
        Color.clear
            .overlay { image.resizable().scaledToFill().scaleEffect(1) }
            .clipped()
    }
}

#Preview {
    let image = Image(.avatar)
    
    NavigationStack {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.width * 1.2
            let blurStart = (height - 170 - 60) / height
            
            AvatarSurface(image: image, isExpanded: true, blurStart: blurStart)
                .frame(width: width, height: height)
        }
        .ignoresSafeArea(edges: .top)
    }
}
