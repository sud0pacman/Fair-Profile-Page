//
//  ContentView.swift
//  Fair Profile Page
//
//  Created by Muhammad on 03/11/26.
//

import SwiftUI

struct ProfileHeaderView: View {
    let avatar: UIImage
    var name: String = "Alicia Brown"
    var status: String = "last seen just now"

    @State private var isExpanded = false
    @State private var scrollY: CGFloat = 0          // > 0 overscroll, < 0 yuqoriga scroll
    @State private var infoBlockHeight: CGFloat = 170
    @State private var selectedImageID: AppImage.ID?
    @State private var appImageList: [AppImage]
    
    let uiImages = [
        UIImage(named: "avatar"),
        UIImage(named: "avatar2")
    ]
    
    init(avatar: UIImage = UIImage(named: "avatar2") ?? UIImage(),
         name: String = "Alicia Brown",
         status: String = "last seen just now") {
        self.avatar = uiImages.first! ?? UIImage()
        self.name = name
        self.status = status
        
        let list = uiImages.map { uiImage in
            let uiImg = uiImage ?? UIImage()
            return AppImage(image: Image(uiImage: uiImg),
                            avatarPalatte: AvatarPalette(image: uiImg))
        }
        _appImageList = State(initialValue: list)
        _selectedImageID = State(initialValue: list.first?.id)
    }

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let topInset = geo.safeAreaInsets.top

            ZStack(alignment: .top) {
                background

                ScrollView {
                    VStack(spacing: 16) {
                        header(width: width, topInset: topInset)
                            .onGeometryChange(for: CGFloat.self) { proxy in
                                proxy.frame(in: .named("scroll")).minY
                            } action: { y in
                                handleScroll(y)
                            }

                        ProfileInfoCard()
                            .padding(.horizontal, 16)

                        Spacer(minLength: 600)
                    }
                }
                .coordinateSpace(name: "scroll")
                .scrollIndicators(.hidden)
                .ignoresSafeArea(edges: .top)

                ProfileNavBar()
            }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: isExpanded)
    }

    // MARK: Scroll logic

    private func handleScroll(_ y: CGFloat) {
        scrollY = y
        if !isExpanded, y > ProfileLayout.expandThreshold {
            withAnimation(.profileExpand) { isExpanded = true }
        } else if isExpanded, y < -ProfileLayout.collapseThreshold {
            withAnimation(.profileExpand) { isExpanded = false }
        }
    }

    // MARK: Header

    @ViewBuilder
    private func header(width: CGFloat, topInset: CGFloat) -> some View {
        let overscroll = max(scrollY, 0)
        let expandedHeight = width * ProfileLayout.expandedAspect

        // Collapsed: tortilganda avatar biroz kattalashadi
        let pull = min(overscroll / ProfileLayout.expandThreshold, 1)
        let circleSize = ProfileLayout.avatarSize * (1 + pull * ProfileLayout.pullScale)

        // Avatar frame (ikki holat orasida spring interpolyatsiya qiladi)
        let avatarRect: CGRect = isExpanded
            ? CGRect(x: 0, y: 0, width: width, height: expandedHeight)
            : CGRect(x: (width - circleSize) / 2, y: topInset + ProfileLayout.avatarTop,
                     width: circleSize, height: circleSize)

        let cornerRadius: CGFloat = isExpanded ? 0 : circleSize / 2

        // Ism + status + buttonlar bloki joyi
        let infoTop: CGFloat = isExpanded
            ? expandedHeight - infoBlockHeight - 14              // rasm ustida, pastda
            : topInset + ProfileLayout.avatarTop + circleSize + ProfileLayout.avatarToInfo

        let headerHeight: CGFloat = isExpanded
            ? expandedHeight
            : infoTop + infoBlockHeight + 4

        // Blur rasmning qayeridan boshlanishi (info blokidan biroz yuqorida)
        let blurStart = max(0, (avatarRect.height - infoBlockHeight - 60) / max(avatarRect.height, 1))

        ZStack(alignment: .topLeading) {
            AvatarSurface(
                images: appImageList,
                selection: $selectedImageID,
                isExpanded: isExpanded,
                blurStart: blurStart
            )
            .frame(width: avatarRect.width, height: avatarRect.height)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .offset(x: avatarRect.minX, y: avatarRect.minY)
            .onTapGesture {
                withAnimation(.profileExpand) { isExpanded.toggle() }
            }

            ProfileInfoBlock(name: name, status: status, isExpanded: isExpanded)
                .frame(width: width)
                .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { infoBlockHeight = $0 }
                .offset(y: infoTop)
        }
        .frame(width: width, height: headerHeight, alignment: .topLeading)
    }
    
    /// Hozir ko'rinib turgan rasm
    private var selectedImage: AppImage? {
        appImageList.first { $0.id == selectedImageID }
    }
    
    private var palette: AvatarPalette {
        selectedImage?.avatarPalatte ?? .fallback
    }

    private var background: some View {
        LinearGradient(colors: [palette.pageTop, palette.page],
                       startPoint: .top, endPoint: .init(x: 0.5, y: 0.45))
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.3), value: selectedImageID)
    }
}

#Preview {
    ProfileHeaderView()
}
