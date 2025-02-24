import SpriteKit

class InsideSpaceshipScene: SKScene {
    private var background: SKSpriteNode!
    private var aiRobot: SKSpriteNode!
    private var speechBubble: SKSpriteNode!
    private var dialogueLabel: SKLabelNode!
    private var startButton: SKSpriteNode!
    private var tapToContinueLabel: SKLabelNode!
    
    private let dialogueParts = [
        "Oh, you are back from your hyper sleep. Good timing!",
        "We are just moments away from reaching our destination.",
        "In the meantime, as this is your first mission, let me brief you about it.",
        "As a new recruit in an advanced space colony “Galactic Guardians”",
        "You are tasked with saving a planet which is on the brink of collapse.",
        "I'm AERON, your companion. I'll be helping you throughout this journey.",
        "Ah, we just landed! Are you ready to kick start your first mission?"
    ]
    
    private var currentPartIndex = 0
    private var typingTimer: Timer?
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        // Background
        background = SKSpriteNode(imageNamed: "InsideSpaceship")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        background.alpha = 0
        addChild(background)
        
        // AI Robot
        aiRobot = SKSpriteNode(imageNamed: "AI Robot")
        aiRobot.setScale(0.3)
        aiRobot.position = CGPoint(x: 225, y: size.height / 2 - 170)
        aiRobot.alpha = 0
        addChild(aiRobot)
        
        // Speech Bubble
        speechBubble = SKSpriteNode(imageNamed: "SpeechBubble")
        speechBubble.setScale(0.35)
        speechBubble.position = CGPoint(x: size.width / 2, y: size.height * 0.6)
        speechBubble.alpha = 0
        addChild(speechBubble)
        
        // Dialogue Label
        dialogueLabel = SKLabelNode(fontNamed: "SF Pro")
        dialogueLabel.fontSize = 28
        dialogueLabel.fontColor = .black
        dialogueLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.62) // Slightly higher than speech bubble
        dialogueLabel.alpha = 0
        dialogueLabel.numberOfLines = 0
        dialogueLabel.preferredMaxLayoutWidth = speechBubble.size.width * 0.8
        addChild(dialogueLabel)
        
        // "Tap to Continue" Label
        tapToContinueLabel = SKLabelNode(fontNamed: "Avenir")
        tapToContinueLabel.text = "Tap to Continue →"
        tapToContinueLabel.fontSize = 18
        tapToContinueLabel.fontColor = .white
        tapToContinueLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.55)
        tapToContinueLabel.alpha = 0  // Hidden at first
        addChild(tapToContinueLabel)
        
        // Start Button (Hidden initially)
        startButton = SKSpriteNode(imageNamed: "Start")
        startButton.setScale(0.2)
        startButton.position = CGPoint(x: size.width / 2, y: size.height / 4)
        startButton.alpha = 0
        addChild(startButton)
        
        // Fade in elements and start dialogue
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        background.run(fadeIn)
        aiRobot.run(fadeIn) { [weak self] in
            self?.speechBubble.run(fadeIn)
            self?.showNextDialogue()
        }
    }
    
    private func showNextDialogue() {
        guard currentPartIndex < dialogueParts.count else {
            showStartButton()
            return
        }
        
        let text = dialogueParts[currentPartIndex]
        currentPartIndex += 1
        
        dialogueLabel.text = ""
        dialogueLabel.alpha = 1
        tapToContinueLabel.alpha = 0  
        
        var currentCharIndex = 0
        typingTimer?.invalidate()
        typingTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if currentCharIndex < text.count {
                let index = text.index(text.startIndex, offsetBy: currentCharIndex)
                self.dialogueLabel.text?.append(text[index])
                currentCharIndex += 1
            } else {
                timer.invalidate()
                self.showTapIndicator()
            }
        }
    }
    
    private func showTapIndicator() {
        let fadeIn = SKAction.fadeIn(withDuration: 1.0)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let blink = SKAction.sequence([fadeIn, fadeOut])
        let blinkForever = SKAction.repeatForever(blink)
        
        tapToContinueLabel.run(fadeIn)
        tapToContinueLabel.run(blinkForever)
    }
    
    private func showStartButton() {
        tapToContinueLabel.removeAllActions() // Stop blinking
        tapToContinueLabel.run(SKAction.fadeOut(withDuration: 0.5)) 
        
        let fadeIn = SKAction.fadeIn(withDuration: 1.0)
        startButton.run(fadeIn)
        
        // "Tap Start to Continue" Label
        let startLabel = SKLabelNode(fontNamed: "Avenir")
        startLabel.text = "Tap Start to Continue"
        startLabel.fontSize = 18
        startLabel.fontColor = .white
        startLabel.position = CGPoint(x: size.width / 2, y: startButton.position.y - 100)
        startLabel.alpha = 0
        addChild(startLabel)
        
        startLabel.run(fadeIn)
        
        // Blinking effect for Start button
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let blink = SKAction.sequence([fadeIn, fadeOut])
        let blinkForever = SKAction.repeatForever(blink)
        startButton.run(blinkForever)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if startButton.alpha > 0, startButton.contains(location) {
                transitionToTitleScene()
            } else {
                showNextDialogue()
            }
        }
    }
    
    private func transitionToTitleScene() {
        let titleScene = TitleScene(size: self.size)
        titleScene.scaleMode = .aspectFill
        self.view?.presentScene(titleScene, transition: SKTransition.fade(withDuration: 2.0))
    }
}
