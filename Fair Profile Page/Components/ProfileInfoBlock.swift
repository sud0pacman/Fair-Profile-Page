//
//  ProfileInfoBlock.swift
//  Fair Profile Page
//
//  Created by Muhammad on 04/11/26.
//

import SwiftUI

struct ProfileInfoBlock: View {
    let name: String
    let status: String
    let isExpanded: Bool

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 6) {
                Text(name)
                    .font(.system(size: 26, weight: .semibold))
                Image(systemName: "gift.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(.yellow)
            }
            .foregroundStyle(.white)
            .shadow(color: .black.opacity(isExpanded ? 0.2 : 0), radius: 6, y: 1)

            Text(status)
                .font(.system(size: 15))
                .foregroundStyle(.white.opacity(0.65))
                .padding(.top, 2)

            GlassEffectContainer(spacing: 20) {
                HStack(spacing: 20) {
                    ActionButton(icon: "phone.fill", title: "call")
                    ActionButton(icon: "bell.fill", title: "mute")
                    ActionButton(icon: "magnifyingglass", title: "search")
                    ActionButton(icon: "ellipsis", title: "more")
                }
            }
            .padding(.top, 16)
        }
    }
}
