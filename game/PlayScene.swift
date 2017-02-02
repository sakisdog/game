import SpriteKit
import GameplayKit
import AudioToolbox

class PlayScene: SKScene, SKPhysicsContactDelegate {
    // MARK: - properties
    let scoreLabel = SKLabelNode()
    let messageLabel = SKLabelNode()
    let highScoreLabel = SKLabelNode()
    var myBall: MyBall!
    var lastContactBallName: String = ""
    var totalScore: Int = 0
    var highScore: Int = 0
    var basePoint: Int = 1
    var bonusPoint: Int = 0
    let colors:[ballColors] = [.red, .blue, .green, .yellow, .purple, ]
    var dropBallCount: Int = 0
    var screenBallCount: Int = 0
    var level: Int = 1
    var life: Int = 3
    var isInvincible: Bool = false
    let lightImpactGenerator = UIImpactFeedbackGenerator(style: .light)
    let heavyImpactGenerator = UIImpactFeedbackGenerator(style: .heavy)
    let generator = UINotificationFeedbackGenerator()
    let userDefaults = UserDefaults.standard


    // MARK: - methods
    override func didMove(to view: SKView) {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsWorld.contactDelegate = self
        lightImpactGenerator.prepare()
        heavyImpactGenerator.prepare()
        generator.prepare()

        initScoreLabel()
        initMyBall()

        self.run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(dropBall),
                SKAction.wait(forDuration: 1.0)
                ])
        ))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if life == 0 {
            let scene = PlayScene(fileNamed: "PlayScene")
            scene?.scaleMode = .aspectFill
            self.view!.presentScene(scene)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let location = touch.location(in: self)
        myBall.position = CGPoint(x: location.x, y: location.y)

        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    // MARK: - private
    func touchMoved(toPoint pos : CGPoint) {
        let moveAction = SKAction.move(to: pos, duration: 0.1)
        myBall.run(moveAction)
    }

    func initScoreLabel() {
        scoreLabel.text = "\(totalScore)"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        scoreLabel.fontSize = 300
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontColor = .gray
        scoreLabel.alpha = 0.8

        self.addChild(scoreLabel)
    }

    func initMyBall() {
        myBall = MyBall(circleOfRadius: 50.0)
        myBall.colorType = .red
        myBall.strokeColor = myBall.colorType.color()
        myBall.lineWidth = CGFloat(life * 5)
        myBall.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 300)
        self.addChild(myBall)

        let path = CGP
    }

    func dropBall() {
        if screenBallCount >= 10 {
            return
        }
        let ball = Ball(circleOfRadius: 50.0)
        let index = (Int)(arc4random_uniform(UInt32(level+2)))
        let colorType: ballColors = colors[index]
        ball.colorType = colorType
        ball.fillColor = colorType.color()
        if colorType == .red {
            ball.physicsBody?.categoryBitMask = 3
            ball.physicsBody?.contactTestBitMask = 3
            ball.physicsBody?.collisionBitMask = 3
        }
        ball.position = CGPoint(x: myBall.frame.midX, y: self.frame.maxY - 20.0)
        self.addChild(ball)

        dropBallCount += 1
        screenBallCount += 1
    }

    func playsSoundBallHits() {
        var soundFile = ""
        switch bonusPoint % 10 {
        case 1:
            soundFile = "pianoC.mp3"
        case 2:
            soundFile = "pianoD.mp3"
        case 3:
            soundFile = "pianoE.mp3"
        case 4:
            soundFile = "pianoF.mp3"
        case 5:
            soundFile = "pianoG.mp3"
        case 6:
            soundFile = "pianoA.mp3"
        case 7:
            soundFile = "pianoB.mp3"
        case 8:
            soundFile = "pianoC2.mp3"
            bonusPoint = 10
        default:
            soundFile = "pianoC.mp3"
        }
        //let action = SKAction.playSoundFileNamed(soundFile, waitForCompletion: true)
        let action = SKAction.playSoundFileNamed(soundFile, waitForCompletion: false)
        self.run(action)
    }

    func feedbackContact(times: Int) {
        switch times {
        case 1:
            lightImpactGenerator.impactOccurred()
        case 2:
            generator.notificationOccurred(.warning)
        case 3:
            generator.notificationOccurred(.error)
        default:
            lightImpactGenerator.impactOccurred()
        }
    }

    // Point fuction
    func pointUp() {
        totalScore += basePoint
        scoreLabel.text = "\(totalScore)"
        scoreLabel.fontColor = .orange
        levelUp()
    }

    func decreaseLife() {
        if isInvincible {
            return
        }
        life -= 1
        scoreLabel.fontColor = .gray
        myBall.glowWidth += 1
        myBall.lineWidth = CGFloat(life * 5)

        if life == 0 {
            scoreLabel.alpha = 1.0
            scoreLabel.zPosition = 100

            messageLabel.fontSize = 70
            messageLabel.fontColor = .gray
            messageLabel.fontName = "Helvetica"
            messageLabel.text = "GAME OVER"
            messageLabel.zPosition = 100
            messageLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
            self.addChild(messageLabel)

            myBall.removeFromParent()


            highScore = userDefaults.integer(forKey: "highScore")
            if totalScore > highScore {
                highScore = totalScore
                userDefaults.set(highScore, forKey: "highScore")
                highScoreLabel.text = "NEW SCORE! : \(highScore)"
                highScoreLabel.fontColor = .orange
            } else {
                highScoreLabel.text = "HIGH SCORE : \(highScore)"
                highScoreLabel.fontColor = .gray
            }
            highScoreLabel.fontSize = 40
            highScoreLabel.fontName = "Helvetica"
            highScoreLabel.zPosition = 100
            highScoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 150)
            self.addChild(highScoreLabel)
        }
    }

    func levelUp() {
        switch totalScore {
        case 0..<10 :
            level = 1
        case 10..<20:
            level = 2
        case 20..<30:
            level = 3
        default:
            level = 4
        }
        if level == 4 {
            messageLabel.fontSize = 50
            messageLabel.fontColor = .orange
            messageLabel.fontName = "Helvetica"
            messageLabel.text = "CLEAR!"
            messageLabel.zPosition = 100
            messageLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 50)
            self.addChild(messageLabel)

            myBall.removeFromParent()
            life = 0
        }
    }

    func becomeInvincible() {
        if isInvincible {
            return
        }
        isInvincible = true
        self.myBall.physicsBody?.categoryBitMask = 2
        self.myBall.physicsBody?.contactTestBitMask = 2
        self.myBall.physicsBody?.collisionBitMask = 2

        let fade =
            SKAction.sequence([
                SKAction.hide(),
                SKAction.wait(forDuration: 0.3),
                SKAction.unhide(),
                SKAction.wait(forDuration: 0.3),
                SKAction.hide(),
                SKAction.wait(forDuration: 0.3),
                SKAction.unhide(),
                SKAction.wait(forDuration: 0.3),
                SKAction.hide(),
                SKAction.wait(forDuration: 0.3),
                SKAction.unhide(),
                SKAction.wait(forDuration: 0.3),
                SKAction.hide(),
                SKAction.wait(forDuration: 0.3),
                SKAction.unhide(),
                SKAction.wait(forDuration: 0.3),
                SKAction.hide(),
                SKAction.wait(forDuration: 0.3),
                SKAction.unhide(),
                SKAction.wait(forDuration: 0.3),
                ])

        self.myBall.run(fade)

        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            ]), completion: {
                self.isInvincible = false
                self.myBall.removeAllActions()
                self.myBall.physicsBody?.categoryBitMask = 1
                self.myBall.physicsBody?.contactTestBitMask = 1
                self.myBall.physicsBody?.collisionBitMask = 1
        })
    }

    func vanishBall(ball: Ball) {
        if life == 0 {
            addGameOverEffect(myBall: self.myBall)
        } else {
            addVanishmentEffect(ball: ball)
        }
    }

    func addGameOverEffect(myBall: MyBall) {
        feedbackContact(times: 2)

        let radius = myBall.frame.size.width / 2
        if radius < 30 {
            return
        }
        let effectNode = SKShapeNode(circleOfRadius: radius)
        effectNode.position = myBall.position
        effectNode.strokeColor = myBall.colorType.color()
        effectNode.lineWidth = 3.0

        let nextBall = MyBall(circleOfRadius: radius * 0.8)
        nextBall.position = myBall.position

        effectNode.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.3),
            SKAction.removeFromParent()
            ]), completion: { self.addGameOverEffect(myBall: nextBall) })
        self.addChild(effectNode)
    }

    func addVanishmentEffect(ball: Ball) {
        let radius = ball.frame.size.width
        let effectNode = SKShapeNode(circleOfRadius: radius)
        effectNode.position = ball.position
        effectNode.strokeColor = ball.colorType.color()
        effectNode.lineWidth = 3.0

        let nextBall = Ball(circleOfRadius: radius/4)
        nextBall.position = ball.position

        effectNode.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.removeFromParent()
            ]))
        self.addChild(effectNode)
    }

    // Delegate
    func didBegin(_ contact: SKPhysicsContact) {
        if let nodeA = contact.bodyA.node as? Ball,
            let nodeB = contact.bodyB.node as? Ball {
            if nodeA.colorType == nodeB.colorType {
                addVanishmentEffect(ball: nodeA)
                addVanishmentEffect(ball: nodeB)

                nodeA.removeFromParent()
                nodeB.removeFromParent()
                screenBallCount -= 2
            }
        }

        if let nodeA = contact.bodyA.node as? MyBall,
            let nodeB = contact.bodyB.node as? Ball {
            if nodeA.colorType == nodeB.colorType {
                pointUp()
                bonusPoint += 1
                feedbackContact(times: 1)
            } else {
                decreaseLife()
                bonusPoint = 0
                becomeInvincible()
                feedbackContact(times: 2)
            }
            playsSoundBallHits()
            vanishBall(ball: nodeB)
            nodeB.removeFromParent()
            screenBallCount -= 1
        }
        if let nodeA = contact.bodyA.node as? Ball,
            let nodeB = contact.bodyB.node as? MyBall {
            if nodeA.colorType == nodeB.colorType {
                pointUp()
                bonusPoint += 1
                feedbackContact(times: 1)
            } else {
                decreaseLife()
                bonusPoint = 0
                becomeInvincible()
                feedbackContact(times: 2)
            }
            playsSoundBallHits()
            vanishBall(ball: nodeA)
            becomeInvincible()
            nodeA.removeFromParent()
            screenBallCount -= 1
        }
    }
}
