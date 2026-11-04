//
//  InfoRow.swift
//  Fair Profile Page
//
//  Created by Muhammad on 04/11/26.
//

import SwiftUI

struct InfoRow: View {
    let title: String
    let value: String
    var trailingIcon: String? = nil

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 14)).foregroundStyle(.white.opacity(0.75))
                Text(value).font(.system(size: 17)).foregroundStyle(.white)
            }
            Spacer()
            if let trailingIcon {
                Image(systemName: trailingIcon).font(.system(size: 20)).foregroundStyle(.white)
            }
        }
        .padding(.vertical, 11)
    }
}
