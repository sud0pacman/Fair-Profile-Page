//
//  ProfileNavBar.swift
//  Fair Profile Page
//
//  Created by Muhammad on 04/11/26.
//

import SwiftUI

struct ProfileNavBar: View {
    var body: some View {
        HStack {
            Button {} label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(width: 38, height: 38)
                    .glassEffect(.regular.interactive(), in: .circle)
            }
            Spacer()
            Button {} label: {
                Text("Edit")
                    .font(.system(size: 17, weight: .medium))
                    .padding(.horizontal, 14)
                    .frame(height: 38)
                    .glassEffect(.regular.interactive(), in: .capsule)
            }
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 16)
        .padding(.top, 4)
    }
}
