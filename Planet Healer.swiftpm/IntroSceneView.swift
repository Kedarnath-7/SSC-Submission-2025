import SpriteKit
import SwiftUI

class IntroSceneView: SKScene {
    private var rocket: SKSpriteNode!
    private var planet: SKSpriteNode!
    private var stars: [SKSpriteNode] = [] 
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        addStars()
        
        let rocketTexture = SKTexture(imageNamed: "SpaceshipWithFlames")
        rocket = SKSpriteNode(texture: rocketTexture)
        rocket.setScale(0.15)
        rocket.position = CGPoint(x: -50, y: -50)
        addChild(rocket)
        
        // Planet setup
        let planetTexture = SKTexture(imageNamed: "SolarSystem")
        planet = SKSpriteNode(texture: planetTexture)
        planet.setScale(0.5)
        planet.position = CGPoint(x: size.width - 200, y: size.height - 200)
        planet.alpha = 0
        addChild(planet)
        
        startAnimation()
    }
    
    private func addStars() {
        for _ in 0..<75 {
            let starTexture = SKTexture(imageNamed: "Star")
            let star = SKSpriteNode(texture: starTexture)
            star.setScale(0.005)
            star.position = CGPoint(x: CGFloat.random(in: 0..<size.width), y: CGFloat.random(in: 0..<size.height))
            
            let starSpeed = CGFloat.random(in: 0.5..<1.0)
            star.run(SKAction.repeatForever(SKAction.moveBy(x: -starSpeed, y: 0, duration: 0.1)))
            
            stars.append(star)
            addChild(star)
        }
    }
    
    private func startAnimation() {
        let fadeIn = SKAction.fadeIn(withDuration: 3)
        let moveDiagonally = SKAction.move(to: CGPoint(x: size.width + 100, y: size.height + 100), duration: 9.0)
        
        let planetFadeIn = SKAction.fadeIn(withDuration: 1.0)
        let moveBackToPlanet = SKAction.move(to: CGPoint(x: size.width - 500, y: size.height - 150), duration: 7.0)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        
        let cinematicText1 = createCinematicText(position: CGPoint(x: size.width - 200, y: 150))
        addChild(cinematicText1)
        let fadeOutText = SKAction.fadeOut(withDuration: 0.1)
        let rocketSequence = SKAction.sequence([
            fadeIn,
            SKAction.run { self.animateText(label: cinematicText1, line1: "Guardian Horizon 2898", line2: "Galactic Guardian Spaceship") },
            moveDiagonally,
            SKAction.run {cinematicText1.run(fadeOutText)}
        ])
        
        rocket.run(rocketSequence) { [weak self] in
            self?.planet.run(planetFadeIn) {
                self?.rocket.position = CGPoint(x: -50, y: 100)
                
                let cinematicText2 = self?.createCinematicText(position: CGPoint(x: self!.size.width - 200, y: 150))
                self?.addChild(cinematicText2!)
                self?.animateText(label: cinematicText2!, line1: "Planetary System 3510", line2: "Milky Way Galaxy")
                
                self?.rocket.run(moveBackToPlanet) {
                    self?.run(fadeOut) {
                        self?.moveToNextScene()
                    }
                }
            }
        }
    }
    
    private func createCinematicText(position: CGPoint) -> SKLabelNode {
        let label = SKLabelNode(fontNamed: "Helvetica Neue Bold")
        label.fontSize = 24
        label.fontColor = .white
        label.position = position
        label.numberOfLines = 2
        label.preferredMaxLayoutWidth = 400
        label.horizontalAlignmentMode = .center
        label.alpha = 0
        return label
    }
    
    private func animateText(label: SKLabelNode, line1: String, line2: String) {
        label.alpha = 1
        
        let fullText = "\(line1)\n\(line2)|" 
        var currentText = ""
        var index = 0
        
        let typewriterAction = SKAction.sequence([
            SKAction.wait(forDuration: 0.05),
            SKAction.run {
                if index < fullText.count {
                    let character = fullText[fullText.index(fullText.startIndex, offsetBy: index)]
                    currentText.append(character)
                    label.text = currentText
                    index += 1
                }
            }
        ])
        
        let typewriterSequence = SKAction.repeat(typewriterAction, count: fullText.count)
        
        let blinkCursor = SKAction.sequence([
            SKAction.run { label.text = currentText.replacingOccurrences(of: "|", with: "") },
            SKAction.wait(forDuration: 0.5),
            SKAction.run { label.text = currentText },
            SKAction.wait(forDuration: 0.5)
        ])
        
        let cursorBlinkForever = SKAction.repeatForever(blinkCursor)
        
        label.run(SKAction.sequence([typewriterSequence, cursorBlinkForever]))
    }
    
    private func moveToNextScene() {
        let insideSpaceshipScene = InsideSpaceshipScene(size: self.size)
        insideSpaceshipScene.scaleMode = .aspectFill
        self.view?.presentScene(insideSpaceshipScene, transition: SKTransition.fade(withDuration: 1.0))
    }
    
    override func update(_ currentTime: TimeInterval) {
        for star in stars {
            if star.position.x < 0 {
                star.position.x = size.width
            }
        }
    }
}

struct SpriteKitView: UIViewRepresentable {
    func makeUIView(context: Context) -> SKView {
        let skView = SKView()
        let scene = IntroSceneView(size: CGSize(width: 1024, height: 768))
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // No updates required
    }
}
