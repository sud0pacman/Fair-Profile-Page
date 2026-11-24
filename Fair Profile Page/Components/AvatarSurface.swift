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
    /// Status bar balandligi. Ota view'dan beriladi: bu view ScrollView ichida
    /// va safe area'ni e'tiborsiz qoldiradi, shuning uchun o'zi uni o'lchay olmaydi.
    let topInset: CGFloat
    
    @State private var currentIndex: Int = 0

    var body: some View {
        ZStack(alignment: .top) {
            TabView(selection: $currentIndex) {
                ForEach(Array(images.enumerated()), id: \.element.id) { index, appImage in
                    ZStack(alignment: .center) {
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
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: currentIndex) { oldValue, newValue in
                selection = images[newValue].id
                print("LLL currentIndex: \(currentIndex)")
            }
            
            HStack(spacing: 4) {
                ForEach(0..<images.count, id: \.self) { index in
                    Capsule()
                        .fill(index == currentIndex ? Color.white : Color.white.opacity(0.35))
                        .frame(height: 2.5)
                        .animation(.easeInOut(duration: 0.2), value: currentIndex)
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, topInset + 8)
            // Yig'ilgan (dumaloq) holatda indikator kerak emas
            .opacity(isExpanded ? 1 : 0)
        }
        .onAppear {
            // Tashqaridan berilgan selection bo'lsa, shu rasmdan boshlaymiz
            if let selection, let index = images.firstIndex(where: { $0.id == selection }) {
                currentIndex = index
            }
        }
    }

    /// scaledToFill rasmni berilgan frame'ga to'g'ri sig'diradi
    private func fill(_ image: Image) -> some View {
        Color.clear
            .overlay { image.resizable().scaledToFill() }
            .clipped()
    }
}
