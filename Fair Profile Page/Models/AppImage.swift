//
//  AppImage.swift
//  Fair Profile Page
//
//  Created by Muhammad on 23/11/26.
//

import SwiftUI

struct AppImage: Identifiable {
    let id = UUID() // Provides a stable, unique identifier
    let image: Image
    let avatarPalatte: AvatarPalette
}
