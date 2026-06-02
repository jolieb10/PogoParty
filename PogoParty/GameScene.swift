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
    private var playerPosition = CGPoint(x: 150, y: 300)
    var player = SKSpriteNode(imageNamed: "tile000")
    private var isJumping = false
    var moveSpeed: CGFloat = 400.0
    let textureAtlas = SKTextureAtlas(named: "green_slime_sprites")
    
    override func didMove(to view: SKView) {
        setupScene()
        setupPlayer(c: "green", tileNum: 0)
//        setupPlayer(c: "blue", tileNum: 50)
//        setupPlayer(c: "red", tileNum: 100)
//        setupPlayer(c: "yellow", tileNum: 150)
    }
    
    private func setupScene() {
        backgroundColor = SKColor(.white)
        size = view!.bounds.size
    }
    
    private func setupPlayer(c: String, tileNum: Int) {
        player.position = CGPoint(x: 300 + player.size.width, y: player.size.height + 100)
        player.setScale(4)
        staticAnimation(tileNum: tileNum)
        addChild(player)
    }
    
    private func staticAnimation(tileNum: Int){
        player.removeAction(forKey: "textureLoop")
        
        var staticAnimation = [SKTexture]()
        for i in 0..<9 {
            let name: String
            let frameNum = tileNum + i
            
            switch frameNum {
            case (0...9):
                name = "tile00\(frameNum)"
            case (10...99):
                name = "tile0\(frameNum)"
            default:
                name = "tile\(frameNum)"
            }
            staticAnimation.append(textureAtlas.textureNamed(name))
        }
        
        let animation = SKAction.animate(with: staticAnimation, timePerFrame: 0.12)
        let repeatForever = SKAction.repeatForever(animation)
        player.run(repeatForever, withKey: "textureLoop")
    }
    
    private func otherAnimation(tileNum: Int) {
        player.removeAction(forKey: "textureLoop")
        var playerAnimation = [SKTexture]()
        
        for i in 0..<9 {
            let name: String
            let frameNum = tileNum + i
            
            switch frameNum {
            case (10...99):
                name = "tile0\(frameNum)"
            default:
                name = "tile\(frameNum)"
            }
            playerAnimation.append(textureAtlas.textureNamed(name))
        }
        let animation = SKAction.animate(with: playerAnimation, timePerFrame: 0.15)
        let repeatForever = SKAction.repeatForever(animation)
        player.run(repeatForever, withKey: "textureLoop")
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let distance = hypot(player.position.x - location.x, player.position.y - location.y)
            let duration = distance / moveSpeed
            
            isJumping = true
            otherAnimation(tileNum: 20)
            move(to: location, time: duration)
        }
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        isJumping = false
//        staticAnimation(tileNum: 0)
//    }
    
    private func move(to location: CGPoint, time: CGFloat) {
        player.removeAction(forKey: "movingAction")
        
        let moveAction = SKAction.move(to: location, duration: time)
        
        let doneMoving = SKAction.run { [weak self] in
            guard let self = self else { return }
            self.isJumping = false
            self.staticAnimation(tileNum: 0)
        }
        
        let sequence = SKAction.sequence([moveAction, doneMoving])
        player.run(sequence, withKey: "movingAction")
    }
}
