import SpriteKit

class GameScene: SKScene {
    private var background: SKSpriteNode!
    private var planet: SKSpriteNode!
    private var aiRobot: SKSpriteNode!
    private var speechBubble: SKSpriteNode!
    private var dialogueLabel: SKLabelNode!
    private var tapToContinueLabel: SKLabelNode!
    private var stars: [SKSpriteNode] = []
    private var typingTimer: Timer?
    
    private let dialogues = [
        "This is Planet Terra... A once-thriving world full of life and balance.",
        "Long ago, its skies were blue, its forests stretched endlessly, and its oceans sparkled with purity.",
        "It was home to countless species, each playing a vital role in its ecosystem.",
        "But over time, things changed... Rapid industrialization, pollution, and deforestation disrupted its delicate balance.",
        "The planet’s natural defenses weakened, and now, it is on the verge of total environmental collapse.",
        "We, the Planet Healers, have been called upon for this mission— to restore balance before it's too late.",
        "Three major issues need urgent attention. If we solve them, we might still save Terra.",
        "Let's begin!"
    ]
    
    private var dialogueIndex = 0
    private var dialogueActive = true
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        addStars()
        addPlanet()
        addRobot()
        addSpeechBubble()
        addDialogueLabel()
        addTapToContinueLabel()
        showNextDialogue()
    }
    
    private func addStars() {
        for _ in 0..<75 {
            let star = SKSpriteNode(imageNamed: "Star")
            star.setScale(0.005)
            star.position = CGPoint(x: CGFloat.random(in: 0..<size.width), y: CGFloat.random(in: 0..<size.height))
            addChild(star)
        }
    }
    
    private func addPlanet() {
        planet = SKSpriteNode(imageNamed: "Planet")
        planet.setScale(0.40)
        planet.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)
        addChild(planet)
    }
    
    private func addRobot() {
        aiRobot = SKSpriteNode(imageNamed: "AI Robot")
        aiRobot.setScale(0.25)
        aiRobot.position = CGPoint(x: size.width * 0.20, y: size.height * 0.30)
        addChild(aiRobot)
    }
    
    private func addSpeechBubble() {
        speechBubble = SKSpriteNode(imageNamed: "Rectangle")
        speechBubble.setScale(0.25)
        speechBubble.position = CGPoint(x: size.width * 0.55, y: size.height * 0.25)
        addChild(speechBubble)
    }
    
    private func addDialogueLabel() {
        dialogueLabel = SKLabelNode(fontNamed: "Avenir")
        dialogueLabel.text = ""
        dialogueLabel.fontSize = 24
        dialogueLabel.fontColor = .white
        dialogueLabel.position = CGPoint(x: size.width / 2 + 50, y: speechBubble.position.y)
        dialogueLabel.preferredMaxLayoutWidth = speechBubble.size.width * 0.85
        dialogueLabel.numberOfLines = 0
        dialogueLabel.verticalAlignmentMode = .center
        dialogueLabel.horizontalAlignmentMode = .center
        addChild(dialogueLabel)
    }
    
    private func addTapToContinueLabel() {
        tapToContinueLabel = SKLabelNode(fontNamed: "Avenir")
        tapToContinueLabel.text = "Tap to continue"
        tapToContinueLabel.fontSize = 16
        tapToContinueLabel.fontColor = .white
        tapToContinueLabel.position = CGPoint(x: size.width / 2 + 180, y: dialogueLabel.position.y - 70)
        tapToContinueLabel.alpha = 0 // Initially hidden
        addChild(tapToContinueLabel)
    }
    
    private func showNextDialogue() {
        guard dialogueIndex < dialogues.count else {
            moveToProblemSelectionScene()
            return
        }
        
        let text = dialogues[dialogueIndex]
        dialogueIndex += 1
        
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
    
    private func moveToProblemSelectionScene() {
        let transition = SKTransition.crossFade(withDuration: 0.5)
        let problemSelectionScene = ProblemSelectionScene(size: size)
        view?.presentScene(problemSelectionScene, transition: transition)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if dialogueActive {
            showNextDialogue()
        }
    }
}
