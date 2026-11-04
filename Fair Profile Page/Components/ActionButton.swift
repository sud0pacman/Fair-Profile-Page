//
//  ActionButton.swift
//  Fair Profile Page
//
//  Created by Muhammad on 04/11/26.
//

import SwiftUI

struct ActionButton: View {
    let icon: String
    let title: String
    let isExpanded: Bool

    var body: some View {
        Button {} label: {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 19, weight: .semibold))
                    .frame(width: 52, height: 52)
                    .background(.white.opacity(isExpanded ? 0.22 : 0.16), in: Circle())
                    .background(.ultraThinMaterial.opacity(isExpanded ? 1 : 0), in: Circle())
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white.opacity(0.85))
            }
            .foregroundStyle(.white)
        }
        .buttonStyle(.plain)
    }
}
