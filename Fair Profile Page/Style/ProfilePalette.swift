//
//  ProfilePalette.swift
//  Fair Profile Page
//
//  Created by Muhammad on 04/11/26.
//

import SwiftUI

enum ProfileLayout {
    static let avatarSize: CGFloat = 100
    static let avatarTop: CGFloat = 8            // safe area'dan keyin
    static let avatarToInfo: CGFloat = 12
    static let expandedAspect: CGFloat = 1.2     // rasm balandligi = width * 1.2
    static let expandThreshold: CGFloat = 70     // shuncha pastga tortilsa → expand
    static let collapseThreshold: CGFloat = 24   // expanded'da shuncha yuqoriga scroll → collapse
    static let pullScale: CGFloat = 0.15         // collapsed'da tortganda avatar kattalashishi
}

enum ProfilePalette {
    /// Sahifa foni. Rasm pastidagi gradient ham shu rangga o'tadi, shuning uchun ikkalasi bir xil bo'lishi shart.
    static let page = Color(red: 0.55, green: 0.32, blue: 0.86)
    static let pageTop = Color(red: 0.80, green: 0.38, blue: 0.86)
}

// MARK: - Animation

extension Animation {
    static let profileExpand = Animation.spring(response: 0.45, dampingFraction: 0.82)
}
