//
//  GameScene.swift
//  PogoParty
//
//  Created by Student on 5/22/26.
//

import Foundation
import SwiftUI
import SpriteKit

class GameScene: SKScene {
    let player = SKSpriteNode()
    private var isJumping = false
    var moveSpeed: CGFloat = 300.0
    
    let gTextureAtlas = SKTextureAtlas(named: "green_slime_sprites")
    let bTextureAtlas = SKTextureAtlas(named: "blue_slime_sprites")
    let rTextureAtlas = SKTextureAtlas(named: "red_slime_sprites")
    let yTextureAtlas = SKTextureAtlas(named: "yellow_slime_sprites")
    
    override func didMove(to view: SKView) {
        setupScene()
        setupPlayer(c: "green", tileNum: 0)
        setupPlayer(c: "blue", tileNum: 50)
        setupPlayer(c: "red", tileNum: 100)
        setupPlayer(c: "yellow", tileNum: 150)
    }
    
    private func setupScene() {
        backgroundColor = SKColor(.white)
        size = view!.bounds.size
    }
    
    private func setupPlayer(c: String, tileNum: Int) {
        player.position = CGPoint(x: 100 + player.size.width, y: player.size.height + 100)
        player.setScale(1)
        staticAnimation(t: gTextureAtlas)
        addChild(player)
    }
    
    private func staticAnimation(t: SKTextureAtlas){
        var staticAnimation = [SKTexture]()
        for i in 0..<9 {
            let name = "tile 00\(i)"
//            let name: String
//            let frameNum = tileNum + i
//            
//            switch frameNum {
//            case (0...9):
//                name = "tile00\(frameNum)"
//            case (10...99):
//                name = "tile0\(frameNum)"
//            default:
//                name = "tile\(frameNum)"
//            }
            staticAnimation.append(t.textureNamed(name))
        }
        
        let animation = SKAction.animate(with: staticAnimation, timePerFrame: 0.12)
        let repeatForever = SKAction.repeatForever(animation)
        player.run(repeatForever)
    }
    
    private func jumpAnimation(t: SKTextureAtlas) {
        var playerAnimation = [SKTexture]()
        for i in 10..<20 {
            let name = "jump0\(i)"
            playerAnimation.append(t.textureNamed(name))
        }
        let animation = SKAction.animate(with: playerAnimation, timePerFrame: 0.15)
        let repeatForever = SKAction.repeatForever(animation)
        player.run(repeatForever)
    }
    
//    private func movePlayer(to targetPosition: CGPoint, player: SKSpriteNode) {
//        let dx = targetPosition.x - player.position.x
//        let dy = targetPosition.y - player.position.y
//        let distance = sqrt(dx*dx + dy*dy)
//        
//        if distance > 0 {
//            let swiftX = dx / distance
//            let swiftY = dy / distance
//            
//            player.physicsBody?.velocity = CGVector(dx: swiftX * moveSpeed, dy: swiftY * moveSpeed)
//        }
//    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isJumping = true
        jumpAnimation(t: gTextureAtlas)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isJumping = false
        staticAnimation(t: gTextureAtlas)
    }
}
