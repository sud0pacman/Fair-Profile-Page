//
//  AvatarPalette.swift
//  Fair Profile Page
//
//  Created by Muhammad on 23/11/26.
//

import simd
import SwiftUI
import UIKit

struct AvatarPalette {
    /// Sahifa foni. Rasm pastidagi gradient ham shu rangga o'tadi, shuning uchun ikkalasi bir xil bo'lishi shart.
    let page: Color
    /// Sahifa tepasidagi rang (fon gradientining boshi)
    let pageTop: Color

    static let fallback = AvatarPalette(page: ProfilePalette.page, pageTop: ProfilePalette.pageTop)

    init(page: Color, pageTop: Color) {
        self.page = page
        self.pageTop = pageTop
    }

    /// 1-o'rindagi rang → `page`, 2-o'rindagi → `pageTop`
    init(image: UIImage) {
        let colors = image.dominantColors(count: 2)
        guard let first = colors.first else {
            self = .fallback
            return
        }
        let second = colors.count > 1 ? colors[1] : first
        page = Color(first.readableUnderWhiteText)
        pageTop = Color(second.readableUnderWhiteText)
    }
}

// MARK: - Dominant colors

private extension UIImage {
    /// Rasmdagi eng ko'p uchraydigan, bir-biridan sezilarli farq qiladigan `count` ta rang
    func dominantColors(count: Int) -> [UIColor] {
        guard let cgImage else { return [] }

        // 1) Rasmni 32×32 ga kichraytiramiz: 1024 piksel sanash uchun yetarli va tez
        let side = 32
        var pixels = [UInt8](repeating: 0, count: side * side * 4)
        guard let context = CGContext(
            data: &pixels, width: side, height: side,
            bitsPerComponent: 8, bytesPerRow: side * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return [] }
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: side, height: side))

        // 2) O'xshash ranglarni bitta "quti"ga yig'amiz: har kanal 256 emas, 8 pog'ona
        struct Bucket { var r = 0, g = 0, b = 0, count = 0 }
        var buckets: [Int: Bucket] = [:]

        for i in stride(from: 0, to: pixels.count, by: 4) {
            let r = Int(pixels[i]), g = Int(pixels[i + 1]), b = Int(pixels[i + 2])

            // Deyarli qora va deyarli oq piksellar fon uchun yaramaydi
            let brightness = max(r, g, b)
            if brightness < 40 || min(r, g, b) > 225 { continue }

            let key = (r >> 5) << 6 | (g >> 5) << 3 | (b >> 5)
            var bucket = buckets[key] ?? Bucket()
            bucket.r += r
            bucket.g += g
            bucket.b += b
            bucket.count += 1
            buckets[key] = bucket
        }

        // 3) Eng ko'p piksel tushgan qutilardan boshlab, bir-biriga juda o'xshamaganlarini olamiz
        var result: [SIMD3<Double>] = []
        for bucket in buckets.values.sorted(by: { $0.count > $1.count }) {
            let n = Double(bucket.count)
            let color = SIMD3(Double(bucket.r) / n, Double(bucket.g) / n, Double(bucket.b) / n)
            let isDistinct = result.allSatisfy { simd_distance($0, color) > 60 }
            if isDistinct { result.append(color) }
            if result.count == count { break }
        }

        return result.map { UIColor(red: $0.x / 255, green: $0.y / 255, blue: $0.z / 255, alpha: 1) }
    }
}

private extension UIColor {
    /// Ustidagi oq matn o'qilishi uchun juda yorug' rangni to'qroq qiladi, rang tusi saqlanadi
    var readableUnderWhiteText: UIColor {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return UIColor(hue: hue, saturation: saturation, brightness: min(brightness, 0.55), alpha: 1)
    }
}
