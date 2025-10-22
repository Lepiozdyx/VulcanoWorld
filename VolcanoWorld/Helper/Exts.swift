//
//  Exts.swift
//  VolcanoWorld
//
//  Created by Алексей Авер on 13.10.2025.
//

import SwiftUI
import Foundation

extension UIApplication {
    var safeAreaInsets: UIEdgeInsets {
        connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow?.safeAreaInsets }
            .first ?? .zero
    }
}

extension View {
    func topSafePadding(_ extra: CGFloat = 0) -> some View {
        let inset = UIApplication.shared.safeAreaInsets.top
        return self.padding(.top, inset + extra)
    }
}


extension View {
    func headerBackground() -> some View {
        self
            .padding([.horizontal, .bottom])
            .background(
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.switchTintDark, .switchTintLight],
                            startPoint: .top,
                            endPoint: .bottomTrailing
                        )
                    )
                    .ignoresSafeArea() 
            )
    }
}


func lastWordFromVolcanoName(_ name: String) -> String {
    var s = name.trimmingCharacters(in: .whitespacesAndNewlines)
    
    s = s.replacingOccurrences(of: "\\(.*?\\)", with: " ",
                               options: .regularExpression)
    
    s = s.replacingOccurrences(of: "\\s+", with: " ",
                               options: .regularExpression)
    
    let parts = s.split(separator: " ")
    guard var last = parts.last.map(String.init) else { return "" }
    
    let trimSet = CharacterSet.punctuationCharacters
        .union(.symbols)
        .union(.whitespacesAndNewlines)
    last = last.trimmingCharacters(in: trimSet)
    
    return last
}
