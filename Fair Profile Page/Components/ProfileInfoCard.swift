//
//  ProfileInfoCard.swift
//  Fair Profile Page
//
//  Created by Muhammad on 04/11/26.
//

import SwiftUI

struct ProfileInfoCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            InfoRow(title: "mobile", value: "+1 555 010 0123")
            Divider().overlay(.white.opacity(0.15))
            InfoRow(title: "username", value: "@alicia", trailingIcon: "qrcode")
            Divider().overlay(.white.opacity(0.15))
            InfoRow(title: "date of birth", value: "Mar 14, 1998")
        }
        .padding(.horizontal, 16)
        .background(.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}
