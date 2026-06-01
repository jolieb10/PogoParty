//
//  ContentView.swift
//  PogoParty
//
//  Created by Student on 5/21/26.
//

// https://www.youtube.com/watch?v=Snl3oxPifWo
// https://opengameart.org/content/animated-slime

//  https://docs.google.com/presentation/d/1SoSl67q5QHSnknravGQwxa7aedNiwz-RH34Vmb-fa0Q/edit?slide=id.g2bf36cfb3c292e42_1#slide=id.g2bf36cfb3c292e42_1

import SwiftUI
import SpriteKit

struct ContentView: View {
    private let gameScene = GameScene()
    
    var body: some View {
        ZStack {
            VStack {
                SpriteView(scene: gameScene)
                    .ignoresSafeArea()
            }
            //LogoScreen()
        }
    }
}

#Preview {
    ContentView()
}
