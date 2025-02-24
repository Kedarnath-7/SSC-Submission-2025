import SpriteKit

class PlanetScene: SKScene {
    private var problemName: String!
    private var planetNode: SKSpriteNode!
    private var problemNodes: [String: SKSpriteNode] = [:]
    
    init(size: CGSize, problemName: String) {
        self.problemName = problemName
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        setupPlanet()
        setupProblems()
        
        removeSolvedProblem()
    }
    
    private func setupPlanet() {
        planetNode = SKSpriteNode(imageNamed: "Planet")
        planetNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        planetNode.setScale(0.5)
        addChild(planetNode)
    }
    
    private func setupProblems() {
        let problemPositions: [String: CGPoint] = [
            "Greenhouse Emissions": CGPoint(x: size.width * 0.7, y: size.height * 0.6),
            "Deforestation": CGPoint(x: size.width * 0.5, y: size.height * 0.8),
            "Ocean Disruption": CGPoint(x: size.width * 0.3, y: size.height * 0.5)
        ]
        
        for (name, position) in problemPositions {
            let problemNode = SKSpriteNode(imageNamed: name)
            problemNode.position = position
            problemNode.setScale(0.2)
            addChild(problemNode)
            problemNodes[name] = problemNode
        }
    }
    
    private func removeSolvedProblem() {
        if let solvedNode = problemNodes[problemName] {
            solvedNode.removeFromParent()
            problemNodes.removeValue(forKey: problemName)
        }
        
        checkMissionCompletion()
    }
    
    private func checkMissionCompletion() {
        if problemNodes.isEmpty {
            moveToCongratulateScene()
        } else {
            moveBackToProblemSelection()
        }
    }
    
    private func moveBackToProblemSelection() {
        let transition = SKTransition.fade(withDuration: 0.5)
        let problemDetailsScene = GameScene(size: size)
        view?.presentScene(problemDetailsScene, transition: transition)
    }
    
    private func moveToCongratulateScene() {
        let transition = SKTransition.fade(withDuration: 0.5)
        let congratulateScene = CongratulateScene(size: size)
        view?.presentScene(congratulateScene, transition: transition)
    }
}

