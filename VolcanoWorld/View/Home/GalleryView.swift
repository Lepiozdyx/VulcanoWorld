//
//  GalleryView.swift
//  VolcanoWorld
//
//  Created by Алексей Авер on 16.10.2025.
//

import SwiftUI

struct GalleryView: View {
    @EnvironmentObject private var themeStore: ThemeStore
    @EnvironmentObject private var volcanoes: VolcanoManager
    @Environment(\.dismiss) private var dismiss
    
    let id: Int
    
    var body: some View {
        let p = themeStore.palette
        
        VStack(alignment: .leading, spacing: 0) {
            if let v = volcanoes.volcano(by: id) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Circle()
                                .fill(Color.switchTintLight)
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Image(systemName: "arrow.left")
                                        .foregroundStyle(.black)
                                        .font(.system(size: 17, weight: .semibold))
                                )
                        }
                        Spacer()
                    }
                    
                    Text(v.name + " Gallery")
                        .foregroundStyle(.white)
                        .font(.customFont(.JockeyRegular, size: 40))
                    
                    HStack {
                        Text("Stunning visuals and lava flows")
                            .foregroundStyle(.white)
                            .font(.customFont(.InterRegular, size: 16))
                        Spacer()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 16)
                .headerBackground()
                
                ScrollView {
                    VStack(spacing: 16) {
                        
                        VStack(spacing: 16) {
                            
                            if let first = v.photos.first {
                                ZStack(alignment: .bottomLeading) {
                                    Image(first)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: .infinity, minHeight: 260, maxHeight: 300)
                                        .clipped()
                                        .overlay(
                                            LinearGradient(
                                                colors: [.clear, .black.opacity(0.6)],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        
                                        HStack(spacing: 6) {
                                            Image(systemName: "flame.fill")
                                                .font(.system(size: 14, weight: .bold))
                                            Text("Featured")
                                                .font(.customFont(.InterRegular, size: 14))
                                        }
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(
                                            Capsule()
                                                .fill(p.switchTint.opacity(0.75))
                                        )
                                        
                                        Text("Lava Flow at Night")
                                            .font(.customFont(.JockeyRegular, size: 24))
                                            .foregroundStyle(.white)
                                        
                                        Text("Glowing molten lava flowing down the mountainside")
                                            .font(.customFont(.InterRegular, size: 15))
                                            .foregroundStyle(.white.opacity(0.85))
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 18)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                .shadow(color: p.switchTint.opacity(0.3), radius: 20, x: 0, y: 10)
                                .padding()
                            }
                            
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                ForEach(v.photos.dropFirst(), id: \.self) { photo in
                                    Image(photo)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: UIScreen.main.bounds.width / 2 - 32)
                                        .clipped()
                                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                        .shadow(color: p.switchTint.opacity(0.2), radius: 10, x: 0, y: 6)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 20)
                            
                            VolcanicPhotographyCard()
                                .environmentObject(themeStore)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 32)
                        }
                    }
                    .padding(.bottom, 24)
                }
                .scrollIndicators(.hidden)
                .background(p.background.ignoresSafeArea())
            }
        }
        .background(themeStore.palette.background.ignoresSafeArea())
        
    }
}

#Preview {
    GalleryView(id: 5)
        .environmentObject(ThemeStore())
        .environmentObject(VolcanoManager())
}

private struct VolcanicPhotographyCard: View {
    @EnvironmentObject private var themeStore: ThemeStore
    
    var body: some View {
        let p = themeStore.palette
        let radius: CGFloat = 26

        VStack(alignment: .center, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(p.switchTint.opacity(0.25))
                    .frame(width: 64, height: 64)
                    .shadow(color: p.switchTint.opacity(0.4), radius: 18)
                    .shadow(color: p.switchTint.opacity(0.2), radius: 28, y: 6)

                Image(systemName: "photo")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(p.switchTint)
            }
            .padding(.top, 6)

            Text("Volcanic Photography")
                .foregroundStyle(p.switchTint)
                .font(.customFont(.InterRegular, size: 24))
                .padding(.top, 4)

            Text("These images showcase the raw power and beauty of Earth's most magnificent geological features. From glowing lava flows to towering ash clouds, volcanoes are nature's ultimate spectacle.")
                .foregroundStyle(p.textMain.opacity(0.9))
                .font(.customFont(.InterRegular, size: 16))
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal, 8)
        }
        .padding(.vertical, 22)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(p.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .stroke(p.textSecond.opacity(0.14), lineWidth: 1)
        )
    }
}
