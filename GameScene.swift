import SpriteKit
import AVFoundation

import GameplayKit

class GameScene: SKScene {
    
    weak var gameTwo: GameTwo?
    var audioPlayer: AVAudioPlayer?
    
    var firstBoxSpriteNode: SKSpriteNode!
    var secondBoxSpriteNode: SKSpriteNode!
    var thirdBoxSpriteNode: SKSpriteNode!
    
    var backgroundSpriteNode: SKSpriteNode!
    
    var targetScoreForLevelCompletion: Int = 0
    var backgroundImageNameForCurrentGame: String = ""
    
    let elementsImages = ["Element1", "Element2", "Element3"]
    var playerScore: Int = 0
    
    var scoreLabel: SKLabelNode!
    var staticScoreLabel: SKLabelNode!
    
    var gameIsPaused: Bool = false
    var activeTimers: [Timer] = []
    
    override func didMove(to view: SKView) {
        setupGameScene()
        startFallingElements()
    }

    func setupGameScene() {
        backgroundSpriteNode = SKSpriteNode(imageNamed: backgroundImageNameForCurrentGame)
        backgroundSpriteNode.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundSpriteNode.size = CGSize(width: frame.width + 200, height: frame.height)
        backgroundSpriteNode.zPosition = -1
        backgroundSpriteNode.color = .black
        backgroundSpriteNode.colorBlendFactor = 0.2
        addChild(backgroundSpriteNode)
        
        staticScoreLabel = SKLabelNode(fontNamed: "Questrian")
        staticScoreLabel.text = "Score"
        staticScoreLabel.fontSize = 42
        staticScoreLabel.fontColor = .white
        staticScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY + 60)
        addChild(staticScoreLabel)
        
        scoreLabel = SKLabelNode(fontNamed: "Questrian")
        scoreLabel.text = "\(playerScore)"
        scoreLabel.fontSize = 82
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(scoreLabel)
        
        let screenWidthValue = frame.width
        let heightOfEachBox: CGFloat = 75
        let widthOfEachBox = screenWidthValue / 3.2
        
        firstBoxSpriteNode = SKSpriteNode(imageNamed: "Box1")
        secondBoxSpriteNode = SKSpriteNode(imageNamed: "Box2")
        thirdBoxSpriteNode = SKSpriteNode(imageNamed: "Box3")
        
        firstBoxSpriteNode.size = CGSize(width: widthOfEachBox, height: heightOfEachBox)
        secondBoxSpriteNode.size = CGSize(width: widthOfEachBox, height: heightOfEachBox)
        thirdBoxSpriteNode.size = CGSize(width: widthOfEachBox, height: heightOfEachBox)
        
        let boxVerticalOffset: CGFloat = 20
        firstBoxSpriteNode.position = CGPoint(x: widthOfEachBox / 2 + 10, y: heightOfEachBox / 2 + boxVerticalOffset)
        secondBoxSpriteNode.position = CGPoint(x: screenWidthValue / 2, y: heightOfEachBox / 2 + boxVerticalOffset)
        thirdBoxSpriteNode.position = CGPoint(x: screenWidthValue - widthOfEachBox / 2 - 10, y: heightOfEachBox / 2 + boxVerticalOffset)
        
        addChild(firstBoxSpriteNode)
        addChild(secondBoxSpriteNode)
        addChild(thirdBoxSpriteNode)
        
        firstBoxSpriteNode.name = "firstBox"
        secondBoxSpriteNode.name = "secondBox"
        thirdBoxSpriteNode.name = "thirdBox"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: self)
        
        if let touchedNode = atPoint(touchLocation) as? SKSpriteNode {
            switch touchedNode.name {
            case "firstBox":
                swapPositionsBetweenFirstAndSecondBoxes(firstBoxSpriteNode, secondBoxSpriteNode)
            case "secondBox":
                swapPositionsBetweenFirstAndSecondBoxes(firstBoxSpriteNode, secondBoxSpriteNode)
            case "thirdBox":
                swapPositionsBetweenSecondAndThirdBoxes(secondBoxSpriteNode, thirdBoxSpriteNode)
            default:
                break
            }
        }
    }
    
    func swapPositionsBetweenFirstAndSecondBoxes(_ firstBox: SKSpriteNode, _ secondBox: SKSpriteNode) {
        let temporaryPosition = firstBox.position
        firstBox.position = secondBox.position
        secondBox.position = temporaryPosition
    }
    
    func swapPositionsBetweenSecondAndThirdBoxes(_ secondBox: SKSpriteNode, _ thirdBox: SKSpriteNode) {
        let temporaryPosition = secondBox.position
        secondBox.position = thirdBox.position
        thirdBox.position = temporaryPosition
    }
    
    func startFallingElements() {
        let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
            self.dropRandomElement()
        }
        activeTimers.append(timer)
    }
    
    func dropRandomElement() {
        let randomIndex = Int.random(in: 0..<elementsImages.count)
        let randomImage = elementsImages[randomIndex]
        
        let elementSpriteNode = SKSpriteNode(imageNamed: randomImage)
        elementSpriteNode.size = CGSize(width: 50, height: 50)
        
        let randomXPosition = CGFloat.random(in: 50..<frame.width-50)
        elementSpriteNode.position = CGPoint(x: randomXPosition, y: frame.height - 50)
        
        addChild(elementSpriteNode)
        
        let moveDownAction = SKAction.moveTo(y: firstBoxSpriteNode.position.y + 75, duration: 4.0)
        let checkHitAction = SKAction.run { [weak self] in
            self?.checkForHit(element: elementSpriteNode, elementName: randomImage)
        }
        let removeAction = SKAction.removeFromParent()
        
        elementSpriteNode.run(SKAction.sequence([moveDownAction, checkHitAction, removeAction]))
    }
    
    func checkForHit(element: SKSpriteNode, elementName: String) {
        guard let firstBox = firstBoxSpriteNode, let secondBox = secondBoxSpriteNode, let thirdBox = thirdBoxSpriteNode else { return }
        
        let distanceToFirstBox = abs(element.position.x - firstBox.position.x)
        let distanceToSecondBox = abs(element.position.x - secondBox.position.x)
        let distanceToThirdBox = abs(element.position.x - thirdBox.position.x)
        
        let closestBox: SKSpriteNode
        if distanceToFirstBox < distanceToSecondBox && distanceToFirstBox < distanceToThirdBox {
            closestBox = firstBox
        } else if distanceToSecondBox < distanceToThirdBox {
            closestBox = secondBox
        } else {
            closestBox = thirdBox
        }
        
        if (elementName == "Element1" && closestBox.name == "firstBox") ||
           (elementName == "Element2" && closestBox.name == "secondBox") ||
           (elementName == "Element3" && closestBox.name == "thirdBox") {
            playerScore += 1
            if  UserDefaults.standard.bool(forKey: "isSoundOn") {
                guard let url = Bundle.main.url(forResource: "ballDroppedBucket", withExtension: "mp3") else {
                    return
                }
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.play()
                } catch {
                }
            }
            scoreLabel.text = "\(playerScore)"
            checkIfPlayerHasReachedTargetScore()
        } else {
            endTwoGame()
        }
    }
    
    func checkIfPlayerHasReachedTargetScore() {
        if playerScore >= targetScoreForLevelCompletion {
            self.gameTwo?.endTwoGameScene(score: playerScore)
        }
    }
    
    func endTwoGame() {
        pauseGameScene()
        self.gameTwo?.endTwoGameScene(score: playerScore)
    }
    
    func pauseGameScene() {
        gameIsPaused = true
        self.isPaused = true
        
        for timer in activeTimers {
            timer.invalidate()
        }
        activeTimers.removeAll()
        
        for node in self.children {
            node.isPaused = true
        }
    }
    
    func resumeGameScene() {
        gameIsPaused = false
        self.isPaused = false
        
        startFallingElements()
        
        for node in self.children {
            node.isPaused = false
        }
    }
    
    func startNewGame() {
        pauseGameScene()
        playerScore = 0
        scoreLabel.text = "\(playerScore)"
        
        for node in self.children {
            if node != firstBoxSpriteNode &&
               node != secondBoxSpriteNode &&
               node != thirdBoxSpriteNode &&
               node != scoreLabel &&
               node != staticScoreLabel &&
               node != backgroundSpriteNode {
                node.removeFromParent()
            }
        }
        
        resumeGameScene()
    }

}
