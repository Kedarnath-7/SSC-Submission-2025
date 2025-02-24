import SpriteKit

class CongratulateScene: SKScene {
    private var background: SKSpriteNode!
    private var aiRobot: SKSpriteNode!
    private var speechBubble: SKSpriteNode!
    private var textLabel: SKLabelNode!
    private var exitButton: SKSpriteNode!
    private var restartButton: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        addBackground()
        addRobot()
        addSpeechBubble()
        addTextLabel()
        
        showCongratulationsMessage()
    }
    
    private func addBackground() {
        background = SKSpriteNode(imageNamed: "InsideSpaceship")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        addChild(background)
    }
    
    private func addRobot() {
        aiRobot = SKSpriteNode(imageNamed: "AI Robot")
        aiRobot.setScale(0.3)
        aiRobot.position = CGPoint(x: 220, y: size.height / 2 - 225)
        addChild(aiRobot)
    }
    
    private func addSpeechBubble() {
        speechBubble = SKSpriteNode(imageNamed: "SpeechBubbleLarge")
        speechBubble.setScale(0.35)
        speechBubble.position = CGPoint(x: size.width / 2 + 20, y: size.height * 0.65)
        addChild(speechBubble)
    }
    
    private func addTextLabel() {
        textLabel = SKLabelNode(fontNamed: "Avenir")
        textLabel.text = ""
        textLabel.fontSize = 20
        textLabel.fontColor = .black
        textLabel.position = CGPoint(x: size.width / 2 + 15, y: speechBubble.position.y + 70)
        textLabel.preferredMaxLayoutWidth = speechBubble.size.width * 0.85
        textLabel.numberOfLines = 0
        textLabel.horizontalAlignmentMode = .center
        textLabel.verticalAlignmentMode = .center
        addChild(textLabel)
    }
    
    private func showCongratulationsMessage() {
        let message = """
        Congratulations, Guardian! 🌍✨
        You have successfully restored the planet and earned your 'Planet Healer' title!🏆
        
        Your actions have created a real impact—the planet is healing because of you! 💚
        
        Keep inspiring change. Share your learning and help others become Planet Healers too!
        """
        typeWriterEffect(text: message)
    }
    
    private func typeWriterEffect(text: String) {
        var charIndex = 0
        let typingSpeed = 0.04
        let textTimer = SKAction.sequence([
            SKAction.run {
                if charIndex < text.count {
                    let index = text.index(text.startIndex, offsetBy: charIndex)
                    self.textLabel.text?.append(text[index])
                    charIndex += 1
                } else {
                    self.removeAction(forKey: "typing")
                    self.showExitAndRestartButtons()
                }
            },
            SKAction.wait(forDuration: typingSpeed)
        ])
        
        run(SKAction.repeatForever(textTimer), withKey: "typing")
    }
    
    private func showExitAndRestartButtons() {
        exitButton = SKSpriteNode(imageNamed: "Exit")
        exitButton.setScale(0.2)  // Adjust size as needed
        exitButton.position = CGPoint(x: size.width / 2 - 100, y: aiRobot.position.y - 50)
        exitButton.name = "exitButton"
        addChild(exitButton)
        
        restartButton = SKSpriteNode(imageNamed: "Restart")
        restartButton.setScale(0.2)  // Adjust size as needed
        restartButton.position = CGPoint(x: size.width / 2 + 100, y: aiRobot.position.y - 50)
        restartButton.name = "restartButton"
        addChild(restartButton)
       
        let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.6)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.6)
        let blinkSequence = SKAction.sequence([fadeOut, fadeIn])
        exitButton.run(SKAction.repeatForever(blinkSequence))
        restartButton.run(SKAction.repeatForever(blinkSequence))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            if let tappedNode = nodes(at: location).first {
                if tappedNode.name == "exitButton" {
                    exitGame()
                } else if tappedNode.name == "restartButton" {
                    restartGame()
                }
            }
        }
    }
    
    private func exitGame() {
        let fadeOut = SKAction.fadeOut(withDuration: 1.0)
        
        exitButton.removeAllActions()
        restartButton.removeAllActions()
        
        exitButton.removeFromParent()
        restartButton.removeFromParent()
        
        let exitMessage = SKLabelNode(fontNamed: "Avenir")
        exitMessage.text = "Thank you for playing! 🌍✨, Please close the application to exit."
        exitMessage.fontSize = 30
        exitMessage.fontColor = .white
        exitMessage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        exitMessage.alpha = 0
        addChild(exitMessage)
        
        exitMessage.run(SKAction.fadeIn(withDuration: 1.0))
        
        background.run(fadeOut)
        aiRobot.run(fadeOut)
        speechBubble.run(fadeOut)
        textLabel.run(fadeOut)
        exitButton.alpha = 0.0
        restartButton.alpha = 0.0
        isUserInteractionEnabled = false
    }
    
    private func restartGame() {
        let transition = SKTransition.crossFade(withDuration: 0.5)
        let newScene = ProblemSelectionScene(size: size, previousSolvedProblems: [])
        view?.presentScene(newScene, transition: transition)
    }
}
