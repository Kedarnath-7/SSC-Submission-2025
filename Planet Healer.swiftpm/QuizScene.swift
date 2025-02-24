import SpriteKit

class QuizScene: SKScene {
    private var problemName: String!
    private var solvedProblems: Set<String>
    private var questionIndex = 0
    private var selectedAnswer: String?
    private var questionLabel: SKLabelNode!
    private var options: [SKLabelNode] = []
    
    private let questions: [String: [(question: String, options: [String], correctAnswer: String)]] = [
        "Greenhouse Emissions": [
            ("This planet is facing issues because of carbon emissions. What should be done?",  
             ["A) Expand public transport and promote electric vehicles",  
              "B) Build more highways for faster traffic flow",  
              "C) Reduce green spaces to create parking lots"],  
             "A) Expand public transport and promote electric vehicles"),
            
            ("Factories and power plants are releasing high amounts of greenhouse gases. What is the best solution?",  
             ["A) Increase production efficiency but continue burning fossil fuels",  
              "B) Switch to renewable energy sources like wind and solar",  
              "C) Build more coal plants to meet energy demands"],  
             "B) Switch to renewable energy sources like wind and solar"),
            
            ("The temperature on the planet is rising due to excess carbon dioxide. How can this be reduced?",  
             ["A) Cut down trees to build more factories",  
              "B) Increase industrial production to balance the climate",  
              "C) Plant more trees and protect forests"],  
             "C) Plant more trees and protect forests")
        ],
        
        "Deforestation": [
            ("Forests on this planet are disappearing, leading to loss of biodiversity. What should be done?",  
             ["A) Implement reforestation by planting more trees",  
              "B) Clear more land for urban expansion",  
              "C) Focus only on planting decorative plants in cities"],  
             "A) Implement reforestation by planting more trees"),
            
            ("Deforestation is increasing carbon dioxide levels in the atmosphere. What action should be taken?",  
             ["A) Burn forests to clear land quickly",  
              "B) Cut down more trees to make space for agriculture",  
              "C) Reduce logging and promote sustainable land use"],  
             "C) Reduce logging and promote sustainable land use"),
            
            ("Wildlife on this planet is struggling due to deforestation. What is the best approach?",  
             ["A) Capture animals and move them to urban areas",  
              "B) Protect natural habitats and create wildlife reserves",  
              "C) Ignore the issue since forests can regrow on their own"],  
             "B) Protect natural habitats and create wildlife reserves")
        ],
        
        "Ocean Disruption": [
            ("Oceans on this planet are heavily polluted with plastic waste. What is the best solution?",  
             ["A) Dump waste further into the ocean to keep beaches clean",  
              "B) Reduce plastic usage and improve waste management",  
              "C) Ignore the problem since the ocean is vast"],  
             "B) Reduce plastic usage and improve waste management"),
            
            ("Marine life is dying due to overfishing. What should be done?",  
             ["A) Catch as many fish as possible before stocks run out",  
              "B) Allow fishing without restrictions to meet food demand",  
              "C) Enforce fishing limits and protect breeding areas"],  
             "C) Enforce fishing limits and protect breeding areas"),
            
            ("Coral reefs are being destroyed due to rising ocean temperatures. What can help?",  
             ["A) Reduce carbon emissions to slow global warming",  
              "B) Harvest corals for commercial use",  
              "C) Build artificial reefs and ignore climate change"],  
             "A) Reduce carbon emissions to slow global warming")
        ]
    ]

    
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
        showQuestion()
    }
    
    private func showQuestion() {
        guard let problemQuestions = questions[problemName], questionIndex < problemQuestions.count else {
            moveToNextScene(isPassed: true)
            return
        }
        
        let currentQuestion = problemQuestions[questionIndex]
        
        removeAllChildren()
        
        questionLabel = SKLabelNode(fontNamed: "Avenir-Heavy")
        questionLabel.text = currentQuestion.question
        questionLabel.fontSize = 24
        questionLabel.fontColor = .white
        questionLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.7)
        questionLabel.preferredMaxLayoutWidth = size.width * 0.8
        questionLabel.numberOfLines = 0
        questionLabel.horizontalAlignmentMode = .center
        addChild(questionLabel)
        
        options.removeAll()
        for (index, option) in currentQuestion.options.enumerated() {
            let optionLabel = SKLabelNode(fontNamed: "Avenir")
            optionLabel.text = option
            optionLabel.fontSize = 20
            optionLabel.fontColor = .lightGray
            optionLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.5 - CGFloat(index) * 50)
            optionLabel.name = option
            addChild(optionLabel)
            options.append(optionLabel)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            for option in options {
                if option.contains(location) {
                    selectedAnswer = option.text
                    validateAnswer(selectedNode: option)
                    break
                }
            }
        }
    }
    
    private func validateAnswer(selectedNode: SKLabelNode) {
        guard let correctAnswer = questions[problemName]?[questionIndex].correctAnswer else { return }
        
        if selectedAnswer == correctAnswer {
            selectedNode.fontColor = .green
            let wait = SKAction.wait(forDuration: 0.5)
            let nextQuestion = SKAction.run { [weak self] in
                self?.questionIndex += 1
                self?.showQuestion()
            }
            run(SKAction.sequence([wait, nextQuestion]))
        } else {
            selectedNode.fontColor = .red
        }
    }
    
    private func moveToNextScene(isPassed: Bool) {
        let transition = SKTransition.crossFade(withDuration: 0.5)
        
        if isPassed {
           
            let newSolvedProblems = solvedProblems.union([problemName])
            let problemSelectionScene = ProblemSelectionScene(size: size, solvedProblemName: problemName, previousSolvedProblems: newSolvedProblems)
            view?.presentScene(problemSelectionScene, transition: transition)
        } else {
            questionIndex = 0
            showQuestion()
        }
    }
}
