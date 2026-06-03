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
    var greenPlayer = SKSpriteNode(imageNamed: "tile000")
    var bluePlayer = SKSpriteNode(imageNamed: "tile050")
    var redPlayer = SKSpriteNode(imageNamed: "tile100")
    var yellowPlayer = SKSpriteNode(imageNamed: "tile150")
    private var isJumping = false
    var moveSpeed: CGFloat = 400.0
    
    override func didMove(to view: SKView) {
        setupScene()
        
        greenPlayer.name = "player"
        bluePlayer.name = "player"
        redPlayer.name = "player"
        yellowPlayer.name = "player"
        
        setupPlayer(player: greenPlayer, c: "green", tileNum: 0)
        setupPlayer(player: bluePlayer, c: "blue", tileNum: 50)
        setupPlayer(player: redPlayer, c: "red", tileNum: 100)
        setupPlayer(player: yellowPlayer, c: "yellow", tileNum: 150)
    }
    
    private func setupScene() {
        backgroundColor = SKColor(.white)
        size = view!.bounds.size
    }
    
    private func setupPlayer(player: SKSpriteNode, c: String, tileNum: Int) {
        player.setScale(4)
        player.position = CGPoint(x: 300 + player.size.width, y: player.size.height + 100)
        player.zPosition = 5
        staticAnimation(player: player, tileNum: tileNum)
        addChild(player)
    }
    
    private func staticAnimation(player: SKSpriteNode, tileNum: Int){
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
            staticAnimation.append(SKTexture(imageNamed: name))
        }
        
        let animation = SKAction.animate(with: staticAnimation, timePerFrame: 0.12)
        let repeatForever = SKAction.repeatForever(animation)
        player.run(repeatForever, withKey: "textureLoop")
    }
    
    private func otherAnimation(player: SKSpriteNode, tileNum: Int) {
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
            playerAnimation.append(SKTexture(imageNamed: name))
        }
        let animation = SKAction.animate(with: playerAnimation, timePerFrame: 0.15)
        let repeatForever = SKAction.repeatForever(animation)
        player.run(repeatForever, withKey: "textureLoop")
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        if let playerNode = self.childNode(withName: "player") as? SKSpriteNode {
            self.handleTouch(player: playerNode, touch: touch)
        } else if let fallbackPlayer = self.children.first(where: { $0 is SKSpriteNode }) as? SKSpriteNode {
            self.handleTouch(player: fallbackPlayer, touch: touch)
        } else {
            print("No SKSpriteNodes in this scene yet.")
        }
    }
    
    func handleTouch(player: SKSpriteNode, touch: UITouch) {
        let location = touch.location(in: self)
        let touchedNode = self.atPoint(location)
        
        if let playerNode = touchedNode as? SKSpriteNode, playerNode.name == "player" {
            self.handleTouch(player: playerNode, touch: touch)
        } else if let fallbackPlayer = self.children.first(where: { $0.name == "player" }) as? SKSpriteNode {
            // Fallback if they tap the empty white background
            self.handleTouch(player: fallbackPlayer, touch: touch)
        }
        
        let distance = hypot(player.position.x - location.x, player.position.y - location.y)
        let duration = TimeInterval(distance / moveSpeed)
        
//        isJumping = true
//        otherAnimation(player: player, tileNum: 20)
//        move(player: player, to: location, time: duration)
        
        let baseTileNum = determineBaseTileNum(for: player)
        otherAnimation(player: player, tileNum: baseTileNum + 20)
        
        move(player: player, to: location, time: duration)
    }
    
    private func determineBaseTileNum(for player: SKSpriteNode) -> Int {
        guard let identity = player.userData?.value(forKey: "colorID") as? String else {
            return 0
        }
        
        switch identity {
        case "blue":   return 50
        case "red":    return 100
        case "yellow": return 150
        default:       return 0
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    private func move(player: SKSpriteNode, to location: CGPoint, time: CGFloat) {
        player.removeAction(forKey: "movingAction")
        
        let moveAction = SKAction.move(to: location, duration: time)
        
        let doneMoving = SKAction.run { [weak self] in
            guard let self = self else { return }
            self.isJumping = false
            let baseTileNum = self.determineBaseTileNum(for: player)
            self.staticAnimation(player: player, tileNum: 0)
        }
        
        let sequence = SKAction.sequence([moveAction, doneMoving])
        player.run(sequence, withKey: "movingAction")
    }
}
