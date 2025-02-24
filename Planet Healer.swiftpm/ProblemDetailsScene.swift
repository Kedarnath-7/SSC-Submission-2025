import SpriteKit

class ProblemDetailsScene: SKScene {
    private var problemName: String!
    private var solvedProblems: Set<String> 
    private var background: SKSpriteNode!
    private var aiRobot: SKSpriteNode!
    private var speechBubble: SKSpriteNode!
    private var textLabel: SKLabelNode!
    private var tapToContinueLabel: SKLabelNode!
    private var solveButton: SKSpriteNode!
    
    private var dialogueIndex = 0
    private var isTyping = false
    
    private let problemDialogues: [String: [String]] = [
        "Greenhouse Emissions": [
            "Greenhouse gases trap heat in the Earth's atmosphere, causing global temperatures to rise. This leads to extreme weather patterns, rising sea levels, and disrupted ecosystems.",
            "Burning fossil fuels in power plants, vehicles, and industries releases large amounts of carbon dioxide (CO₂) and methane (CH₄). Deforestation also worsens the problem by reducing the number of trees that absorb CO₂.",
            "We can reduce emissions by shifting to renewable energy sources like solar and wind power, using energy-efficient appliances, and promoting sustainable transportation, such as electric vehicles and public transport."
        ],
        "Deforestation": [
            "Forests are disappearing rapidly, threatening wildlife and increasing carbon dioxide levels in the atmosphere. This leads to climate change, loss of biodiversity, and disrupted water cycles.",
            "Deforestation happens due to logging, agriculture, and urban expansion. Large areas of forests are cleared for farming, roads, and settlements, often without replanting trees.",
            "Reforestation—planting trees where they have been cut—is one way to restore forests. Governments and businesses must adopt sustainable land use policies. Consumers can help by choosing products from responsible sources and reducing paper waste."
        ],
        "Ocean Disruption": [
            "Oceans regulate Earth's climate and support marine life, but pollution and warming waters are throwing ecosystems off balance. Coral reefs are dying, fish populations are declining, and sea levels are rising.",
            "Industrial waste, plastic pollution, and oil spills contaminate ocean waters. Overfishing and climate change also contribute by disrupting food chains and increasing ocean acidity.",
            "Reducing plastic waste, enforcing laws against dumping industrial waste, and protecting marine habitats can help restore ocean health. Choosing sustainable seafood and supporting conservation efforts also play a key role."
        ]
    ]
    
    // ✅ Updated initializer to accept solvedProblems
    init(size: CGSize, problemName: String, previousSolvedProblems: Set<String>) {
        self.problemName = problemName
        self.solvedProblems = previousSolvedProblems
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        addBackground()
        addRobot()
        addSpeechBubble()
        addTextLabel()
        addTapToContinueLabel()
        showNextDialogue()
    }
    
    private func addBackground() {
        background = SKSpriteNode(imageNamed: "InsideSpaceship")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        addChild(background)
    }
    
    private func addRobot() {
        let aiRobot = SKSpriteNode(imageNamed: "AI Robot")
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
        textLabel.fontSize = 24
        textLabel.fontColor = .black
        textLabel.position = CGPoint(x: size.width / 2 + 16, y: speechBubble.position.y + 80)
        textLabel.preferredMaxLayoutWidth = speechBubble.size.width * 0.85
        textLabel.numberOfLines = 0
        textLabel.horizontalAlignmentMode = .center
        textLabel.verticalAlignmentMode = .center
        addChild(textLabel)
    }
    
    private func addTapToContinueLabel() {
        tapToContinueLabel = SKLabelNode(fontNamed: "Avenir-Italic")
        tapToContinueLabel.text = "Tap to continue"
        tapToContinueLabel.fontSize = 20
        tapToContinueLabel.fontColor = .white
        tapToContinueLabel.position = CGPoint(x: size.width / 2, y: speechBubble.position.y - 80)
        tapToContinueLabel.isHidden = true
        addChild(tapToContinueLabel)
    }
    
    private func showNextDialogue() {
        guard let dialogues = problemDialogues[problemName], dialogueIndex < dialogues.count else {
            showSolveButton()
            return
        }
        
        let dialogue = dialogues[dialogueIndex]
        dialogueIndex += 1
        isTyping = true
        textLabel.text = ""
        tapToContinueLabel.isHidden = true
        typeWriterEffect(text: dialogue)
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
                    self.isTyping = false
                    self.tapToContinueLabel.isHidden = false
                }
            },
            SKAction.wait(forDuration: typingSpeed)
        ])
        
        run(SKAction.repeatForever(textTimer), withKey: "typing")
    }
    
    private func showSolveButton() {
        tapToContinueLabel.removeAllActions() 
        tapToContinueLabel.run(SKAction.fadeOut(withDuration: 0.5)) 
        
        solveButton = SKSpriteNode(imageNamed: "Solve")
        solveButton.setScale(0.2)  
        solveButton.position = CGPoint(x: size.width / 2, y: size.height / 4)
        solveButton.alpha = 0 
        solveButton.name = "solveButton"
        addChild(solveButton)
        
        let fadeIn = SKAction.fadeIn(withDuration: 1.0)
        solveButton.run(fadeIn)
        
        let solveLabel = SKLabelNode(fontNamed: "Avenir")
        solveLabel.text = "Tap Solve to Continue"
        solveLabel.fontSize = 18
        solveLabel.fontColor = .white
        solveLabel.position = CGPoint(x: size.width / 2, y: solveButton.position.y - 100)
        solveLabel.alpha = 0
        addChild(solveLabel)
        
        solveLabel.run(fadeIn)
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let blink = SKAction.sequence([fadeIn, fadeOut])
        let blinkForever = SKAction.repeatForever(blink)
        solveButton.run(blinkForever)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            if isTyping {
                removeAction(forKey: "typing")
                textLabel.text = problemDialogues[problemName]?[dialogueIndex - 1] ?? ""
                isTyping = false
                tapToContinueLabel.isHidden = false
                return
            }
            
            if let solveButton = solveButton, solveButton.contains(location) {
                goToQuizScene()
            } else {
                showNextDialogue()
            }
        }
    }

    private func goToQuizScene() {
        let transition = SKTransition.fade(withDuration: 0.5)
        let quizScene = QuizScene(size: size, problemName: problemName, previousSolvedProblems: solvedProblems)
        view?.presentScene(quizScene, transition: transition)
    }
}
