//
//  LogoScreen.swift
//  PogoParty
//
//  Created by Student on 5/22/26.
//

import SwiftUI

struct LogoScreen: View {
    @State private var logoScreen = false
    
    var body: some View {
        VStack {
            Image(.logo)
                .resizable()
                .scaledToFit()
                .frame(width: 1600, height: 600)
                .ignoresSafeArea()
                .opacity(logoScreen ? 1.0 : 0.0)
                .onAppear{
                    withAnimation(.easeIn(duration: 0.5).delay(1)){
                        logoScreen = true
                    }
                    withAnimation(.easeOut(duration: 0.3).delay(4)){
                        logoScreen = false
                    }
                }
        }
        .padding()
//        .rotationEffect(.degrees(270))
    }
}

#Preview {
    LogoScreen()
}
