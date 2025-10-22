//
//  ContentView.swift
//  VolcanoWorld
//
//  Created by Алексей Авер on 13.10.2025.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack(alignment: .center) {
            Image(.loadingBack)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 1.2)
                .ignoresSafeArea(edges: .all)
            Image(.loadingLogo)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.7)
                .offset(y: -100)
            
            VStack {
                Spacer()
                
                ProgressView()
                    .colorInvert()
                    .scaleEffect(1.5)
            }
            .padding(.bottom)
        }
    }
}

#Preview {
    LoadingView()
}
