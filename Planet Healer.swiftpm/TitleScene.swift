import SpriteKit

class TitleScene: SKScene {
    private var planetLabel: SKLabelNode!
    private var healerLabel: SKLabelNode!
    private var tapToStartLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        addStars()
        addTitle()
        animateTitle()
        addTapToStartLabel()
    }
    
    private func addStars() {
        for _ in 0..<75 {
            let star = SKSpriteNode(imageNamed: "Star")
            star.setScale(0.005)
            star.position = CGPoint(x: CGFloat.random(in: 0..<size.width), y: CGFloat.random(in: 0..<size.height))
            addChild(star)
        }
    }
    
    private func addTitle() {
        let spacing: CGFloat = 150 
        
        // "Planet" Label (Red & Blinking)
        planetLabel = SKLabelNode(fontNamed: "Helvetica Neue Bold")
        planetLabel.text = "PLANET"
        planetLabel.fontSize = 90
        planetLabel.fontColor = .red
        planetLabel.alpha = 0
        planetLabel.setScale(0.6) 
        
        healerLabel = SKLabelNode(fontNamed: "Helvetica Neue Bold")
        healerLabel.text = "HEALER"
        healerLabel.fontSize = 90
        healerLabel.fontColor = .green
        healerLabel.alpha = 0
        healerLabel.setScale(0.6) 
        
        let planetWidth = planetLabel.frame.width
        let healerWidth = healerLabel.frame.width
        
        let _ = planetWidth + healerWidth + spacing
        let centerX = size.width / 2
        
        planetLabel.position = CGPoint(x: centerX - (healerWidth / 2 + spacing / 2), y: size.height / 2)
        healerLabel.position = CGPoint(x: centerX + (planetWidth / 2 + spacing / 2), y: size.height / 2)
        
        addChild(planetLabel)
        addChild(healerLabel)
    }
    
    private func animateTitle() {
        let fadeIn = SKAction.fadeIn(withDuration: 4.0)
        let scaleUp = SKAction.scale(to: 1.0, duration: 3.5)
        let titleAppear = SKAction.group([fadeIn, scaleUp])
       
        let blink = SKAction.repeatForever(SKAction.sequence([
            SKAction.fadeAlpha(to: 0.4, duration: 0.6),
            SKAction.fadeAlpha(to: 1.0, duration: 0.6)
        ]))
        
        planetLabel.run(SKAction.sequence([titleAppear, blink]))
        healerLabel.run(titleAppear) 
    }
    
    private func addTapToStartLabel() {
        tapToStartLabel = SKLabelNode(fontNamed: "Avenir")
        tapToStartLabel.text = "Tap to Start"
        tapToStartLabel.fontSize = 36
        tapToStartLabel.fontColor = .white
        tapToStartLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.25)
        tapToStartLabel.alpha = 0
        
        addChild(tapToStartLabel)
        
        let fadeIn = SKAction.fadeIn(withDuration: 3.5)
        let blink = blinkAnimation()
        let sequence = SKAction.sequence([SKAction.wait(forDuration: 4.0), fadeIn, blink])
        tapToStartLabel.run(sequence)
    }
    
    private func blinkAnimation() -> SKAction {
        let fadeOut = SKAction.fadeAlpha(to: 1.0, duration: 1.5)
        let fadeIn = SKAction.fadeAlpha(to: 1.5, duration: 2.5)
        return SKAction.repeatForever(SKAction.sequence([fadeOut, fadeIn]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        transitionToGameScene()
    }
    
    private func transitionToGameScene() {
        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = .aspectFill
        self.view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: 1.5))
    }
}
