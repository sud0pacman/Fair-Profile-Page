//
//  ActionButton.swift
//  Fair Profile Page
//
//  Created by Muhammad on 04/11/26.
//

//
//  ActionButton.swift
//  PrettyProfilePage
//
//  Created by Muhammad on 02/11/26.
//

import SwiftUI

struct ActionButton: View {
    let icon: String
    let title: String

    var body: some View {
        Button {} label: {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 19, weight: .semibold))
                    .frame(width: 52, height: 52)
                    .glassEffect(.regular.interactive(), in: .circle)
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white.opacity(0.85))
            }
            .foregroundStyle(.white)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        GeometryReader { geo in
            VStack {
                ActionButton(
                    icon: "phone.fill", title: "Call"
                )
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(content: Color.blue.scaledToFill)
        }
        .ignoresSafeArea()
    }
}
