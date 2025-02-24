import SpriteKit

class ProblemSelectionScene: SKScene {
    private var background: SKSpriteNode!
    private var planet: SKSpriteNode!
    private var aiRobot: SKSpriteNode!
    private var instructionLabel: SKLabelNode!
    private var problemMarkers: [SKSpriteNode] = []
    private var problemLabels: [SKLabelNode] = []
    private var solvedProblems: Set<String> = []
    
    init(size: CGSize, solvedProblemName: String? = nil, previousSolvedProblems: Set<String> = []) {
        self.solvedProblems = previousSolvedProblems 
        if let problemName = solvedProblemName {
            self.solvedProblems.insert(problemName) 
        }
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        addStars()
        addPlanet()
        addRobot()
        
        if solvedProblems.count >= 3 {
            showFinalMessage()
            return
        }
        
        addInstructionLabel()
        addProblemMarkers()
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
    
    private func addInstructionLabel() {
        instructionLabel = SKLabelNode(fontNamed: "Avenir")
        instructionLabel.text = "Tap on a problem to view more details."
        instructionLabel.fontSize = 24
        instructionLabel.fontColor = .white
        instructionLabel.position = CGPoint(x: aiRobot.position.x + 160, y: aiRobot.position.y - 50)
        instructionLabel.horizontalAlignmentMode = .left
        addChild(instructionLabel)
        
        let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.6)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.6)
        let blinkSequence = SKAction.sequence([fadeOut, fadeIn])
        instructionLabel.run(SKAction.repeatForever(blinkSequence))
    }
    
    private func addProblemMarkers() {
        let problems: [(name: String, image: String, position: CGPoint, scale: CGFloat, labelOffset: CGPoint)] = [
            ("Greenhouse Emissions", "Pointer2", CGPoint(x: planet.position.x - 230, y: planet.position.y + 50), 0.25, CGPoint(x: -32, y: 30)),
            ("Deforestation", "Pointer1", CGPoint(x: planet.position.x + 225, y: planet.position.y + 50), 0.25, CGPoint(x: 60, y: 30)),
            ("Ocean Disruption", "Pointer3", CGPoint(x: planet.position.x + 225, y: planet.position.y - 150), 0.25, CGPoint(x: 50, y: -45))
        ]
        
        for problem in problems {
            if solvedProblems.contains(problem.name) { continue }
            
            let marker = SKSpriteNode(imageNamed: problem.image)
            marker.setScale(problem.scale)
            marker.position = problem.position
            marker.name = problem.name
            
            let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.5)
            let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.5)
            marker.run(SKAction.repeatForever(SKAction.sequence([fadeOut, fadeIn])))
            
            problemMarkers.append(marker)
            addChild(marker)
            
            let label = SKLabelNode(fontNamed: "Avenir-Heavy")
            label.text = problem.name
            label.fontSize = 18
            label.fontColor = .white
            label.position = CGPoint(x: marker.position.x + problem.labelOffset.x, y: marker.position.y + problem.labelOffset.y)
            label.horizontalAlignmentMode = .center
            label.name = problem.name + " Label"
            
            problemLabels.append(label)
            addChild(label)
        }
    }
    
    private func showFinalMessage() {
        guard let aiRobot = aiRobot else { return }
        
        let speechBubble = SKSpriteNode(imageNamed: "Rectangle")
        speechBubble.setScale(0.25)
        speechBubble.position = CGPoint(x: aiRobot.position.x + 360, y: aiRobot.position.y - 30)
        addChild(speechBubble)
        
        let finalMessage = "Wow! Great, you have solved all the major problems. Now the planet's nature will take its course healing istself and it looks like our job is complete here!"
        let messageLabel = SKLabelNode(fontNamed: "Avenir")
        messageLabel.text = ""
        messageLabel.fontSize = 18
        messageLabel.fontColor = .white
        messageLabel.position = CGPoint(x: size.width / 2 + 50, y: speechBubble.position.y - 45)
        messageLabel.preferredMaxLayoutWidth = speechBubble.size.width * 0.85
        messageLabel.numberOfLines = 0
        messageLabel.horizontalAlignmentMode = .center
        addChild(messageLabel)
        
        var charIndex = 0
        let typingSpeed = 0.05
        let textTimer = SKAction.sequence([
            SKAction.run {
                if charIndex < finalMessage.count {
                    let index = finalMessage.index(finalMessage.startIndex, offsetBy: charIndex)
                    messageLabel.text?.append(finalMessage[index])
                    charIndex += 1
                } else {
                    self.removeAction(forKey: "typing")
                    self.showTapToContinue()
                }
            },
            SKAction.wait(forDuration: typingSpeed)
        ])
        
        run(SKAction.repeatForever(textTimer), withKey: "typing")
    }

    
    private func showTapToContinue() {
        let tapToContinueLabel = SKLabelNode(fontNamed: "Avenir")
        tapToContinueLabel.text = "Tap to continue"
        tapToContinueLabel.fontSize = 16
        tapToContinueLabel.fontColor = .yellow
        tapToContinueLabel.position = CGPoint(x: size.width / 2 + 40, y: aiRobot.position.y - 90)
        tapToContinueLabel.horizontalAlignmentMode = .center
        tapToContinueLabel.name = "tapToContinue"
        addChild(tapToContinueLabel)
        
        let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.6)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.6)
        let blinkSequence = SKAction.sequence([fadeOut, fadeIn])
        tapToContinueLabel.run(SKAction.repeatForever(blinkSequence))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if solvedProblems.count >= 3 {
            moveToCongratulateScene()
            return
        }
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            if let tappedNode = nodes(at: location).first, tappedNode.name == "tapToContinue" {
                moveToCongratulateScene()
                return
            }
            
            for marker in problemMarkers {
                if marker.contains(location) {
                    moveToProblemDetails(marker)
                    return
                }
            }
        }
    }
    
    private func moveToProblemDetails(_ marker: SKSpriteNode) {
        if let problemName = marker.name {
            let transition = SKTransition.crossFade(withDuration: 0.5)
            
            let problemDetailsScene = ProblemDetailsScene(size: size, problemName: problemName, previousSolvedProblems: solvedProblems)
            view?.presentScene(problemDetailsScene, transition: transition)
        }
    }
    
    func markProblemSolved(_ problemName: String) {
        solvedProblems.insert(problemName)
       
        if let markerIndex = problemMarkers.firstIndex(where: { $0.name == problemName }) {
            problemMarkers[markerIndex].removeFromParent()
            problemMarkers.remove(at: markerIndex)
        }
       
        if let labelIndex = problemLabels.firstIndex(where: { $0.text == problemName }) {
            problemLabels[labelIndex].removeFromParent()
            problemLabels.remove(at: labelIndex)
        }
       
        if solvedProblems.count >= 3 {
            moveToCongratulateScene()
        } else {
            let newScene = ProblemSelectionScene(size: size, previousSolvedProblems: solvedProblems)
            view?.presentScene(newScene, transition: SKTransition.crossFade(withDuration: 0.5))
        }
    }
    
    private func moveToCongratulateScene() {
        let transition = SKTransition.crossFade(withDuration: 0.5)
        let congratulateScene = CongratulateScene(size: size)
        view?.presentScene(congratulateScene, transition: transition)
    }
}
