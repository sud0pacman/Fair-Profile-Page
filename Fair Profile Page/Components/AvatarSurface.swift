//
//  AvatarSurface.swift
//  Fair Profile Page
//
//  Created by Muhammad on 04/11/26.
//

import SwiftUI

/// Rasm + progressive blur + fon bilan qo'shilish
struct AvatarSurface: View {
    let images: [AppImage]
    /// Hozir ko'rinib turgan rasmning id'si
    @Binding var selection: AppImage.ID?
    let isExpanded: Bool
    let blurStart: CGFloat

    var body: some View {
        TabView(selection: $selection) {
            ForEach(images) { appImage in
                ZStack {
                    fill(appImage.image)
                    
                    // 1) Progressive blur: rasmning blur qilingan nusxasi, pastga qarab ko'rinadi
                    fill(appImage.image)
                        .blur(radius: 22, opaque: true)
                        .mask(
                            LinearGradient(stops: [
                                .init(color: .clear, location: blurStart),
                                .init(color: .black, location: min(blurStart + 0.18, 1))
                            ], startPoint: .top, endPoint: .bottom)
                        )
                        .opacity(isExpanded ? 1 : 0)
                    
                    // 2) Fon rangiga o'tish: rasm pasti sahifaga qo'shilib ketadi
                    LinearGradient(stops: [
                        .init(color: appImage.avatarPalatte.page.opacity(0), location: blurStart),
                        .init(color: appImage.avatarPalatte.page.opacity(0.45), location: min(blurStart + 0.2, 1)),
                        .init(color: appImage.avatarPalatte.page, location: 1)
                    ], startPoint: .top, endPoint: .bottom)
                    .opacity(isExpanded ? 1 : 0)
                }
                .tag(Optional(appImage.id))
            }
        }
        .tabViewStyle(.page)
    }

    /// scaledToFill rasmni berilgan frame'ga to'g'ri sig'diradi
    private func fill(_ image: Image) -> some View {
        Color.clear
            .overlay { image.resizable().scaledToFill() }
            .clipped()
    }
}
