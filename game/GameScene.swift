import SpriteKit
import GameplayKit
import AudioToolbox

class GameScene: SKScene, SKPhysicsContactDelegate {
    // MARK: - properties
    let scoreLabel = SKLabelNode()
    let messageLabel = SKLabelNode()
    let highScoreLabel = SKLabelNode()
    let pauseButton = SKLabelNode()
    let unpauseButton = SKLabelNode()
    let restartButton = SKLabelNode()
    let exitButton = SKLabelNode()
    var myBall: MyBall!
    var totalScore: Int = 0
    var highScore: Int = 0
    var basePoint: Int = 1
    var bonusPoint: Int = 0
    let colors:[ballColors] = [.red, .blue, .green, .yellow, .purple]
    var myColorIndex: Int = 0
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
        self.backgroundColor = SKColor.white
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsWorld.contactDelegate = self
        lightImpactGenerator.prepare()
        heavyImpactGenerator.prepare()
        generator.prepare()

        myColorIndex = userDefaults.integer(forKey: "MyColor")

        initMyBall()
        initScoreLabel()
        initHighScoreLabel()
        initMessageLabel()
        initPauseButton()
        initRestartButton()
        initExitButton()


        self.run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(dropBall),
                SKAction.wait(forDuration: 1.5)
                ])
        ))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }

    func touchDown(atPoint pos : CGPoint) {
        let touchedNode = scene?.atPoint(pos)

        if (touchedNode?.name == "pauseButton") {
            pause()
        } else if (touchedNode?.name == "restartButton") {
            presentGameScene()
        } else if (touchedNode?.name == "exitButton") {
            presentTitleScene()
        } else {
            if self.isPaused {
                unpause()
            } else if life == 0 {
                presentGameScene()
            }
        }
    }

    func pause() {
        pauseButton.isHidden = true
        restartButton.isHidden = false
        exitButton.isHidden = false
        scoreLabel.zPosition = 100
        self.isPaused = true
//        let pauseView = PauseView(scene: self, frame: self.frame)
//        self.view?.addSubview(pauseView)
    }

    func unpause() {
        pauseButton.isHidden = false
        restartButton.isHidden = true
        exitButton.isHidden = true
        scoreLabel.zPosition = 0
        self.isPaused = false
    }

    func presentGameScene() {
        let nextMyColorIndex = (Int)(arc4random_uniform(UInt32(3)))
        userDefaults.set(nextMyColorIndex, forKey: "MyColor")
        let nextScene = GameScene(size: (self.view?.bounds.size)!)
        nextScene.scaleMode = .aspectFill
        self.view!.presentScene(nextScene)
    }

    func presentTitleScene() {
        let nextScene = TitleScene(size: (self.view?.bounds.size)!)
        nextScene.scaleMode = .aspectFill
        self.view!.presentScene(nextScene)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isPaused {
            return
        }
        let touch: UITouch = touches.first!
        let location = touch.location(in: self)
        myBall.position = CGPoint(x: location.x, y: location.y)

        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }

    func touchMoved(toPoint pos : CGPoint) {
        let moveAction = SKAction.move(to: pos, duration: 0.1)
        myBall.run(moveAction)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    // MARK: - private
    func initMyBall() {
        myBall = MyBall(circleOfRadius: 30.0)
        myBall.colorType = colors[myColorIndex]
        myBall.strokeColor = myBall.colorType.color()
        myBall.fillColor = myBall.colorType.bodyColor()
        myBall.lineWidth = CGFloat(life * 3)
        myBall.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 200)

        self.addChild(myBall)
    }

    func initScoreLabel() {
        scoreLabel.text = "\(totalScore)"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        scoreLabel.fontSize = 150
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontColor = .gray

        self.addChild(scoreLabel)
    }

    func initPauseButton() {
        pauseButton.name = "pauseButton"
        pauseButton.text = "||"
        pauseButton.fontColor = .gray
        pauseButton.fontName = "Helvetica"
        print(pauseButton.frame)
        pauseButton.position = CGPoint(x: self.frame.maxX - 50, y: self.frame.maxY - 50)

        self.addChild(pauseButton)
    }

    func initHighScoreLabel() {
        highScore = userDefaults.integer(forKey: "HighScore")
        highScoreLabel.isHidden = true
        highScoreLabel.fontSize = 30
        highScoreLabel.zPosition = 100
        highScoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 130)
        self.addChild(highScoreLabel)
    }

    func initMessageLabel() {
        messageLabel.isHidden = true
        messageLabel.fontSize = 50
        messageLabel.fontColor = .gray
        messageLabel.text = "GAME OVER"
        messageLabel.zPosition = 100
        messageLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
        self.addChild(messageLabel)
    }

    func initUnpauseButton() {
        unpauseButton.isHidden = true
        unpauseButton.text = "UnPause"
        unpauseButton.name = "unpauseButton"
        unpauseButton.fontSize = 30
        unpauseButton.fontColor = .gray
        unpauseButton.zPosition = 100
        unpauseButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 150)
        self.addChild(unpauseButton)
    }

    func initRestartButton() {
        restartButton.isHidden = true
        restartButton.text = "Restart"
        restartButton.name = "restartButton"
        restartButton.fontSize = 30
        restartButton.fontColor = .gray
        restartButton.zPosition = 100
        restartButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 200)
        self.addChild(restartButton)
    }

    func initExitButton() {
        exitButton.isHidden = true
        exitButton.text = "Exit to Menu"
        exitButton.name = "exitButton"
        exitButton.fontSize = 30
        exitButton.fontColor = .gray
        exitButton.zPosition = 100
        exitButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 250)
        self.addChild(exitButton)
    }

    func dropBall() {
        if screenBallCount >= 10 {
            return
        }

        let ball = Ball(circleOfRadius: 30.0)

        let index = (Int)(arc4random_uniform(UInt32(level+2)))
        let colorType: ballColors = colors[index]
        ball.colorType = colorType
        ball.fillColor = colorType.color()

        if colorType == colors[myColorIndex] {
            ball.physicsBody?.categoryBitMask = 3
            ball.physicsBody?.contactTestBitMask = 3
            ball.physicsBody?.collisionBitMask = 3
        }
        ball.physicsBody?.velocity = dropVelocity(
            speed: CGFloat(200 + (50 * level)),
            targetPoint: CGPoint(
                x: myBall.frame.midX,
                y: self.frame.maxY - myBall.frame.midY
            )
        )
        ball.position = CGPoint(x: self.frame.midX, y: self.frame.maxY)

        self.addChild(ball)

        dropBallCount += 1
        screenBallCount += 1
    }

    func dropVelocity(speed: CGFloat, targetPoint: CGPoint) -> CGVector {
        let distance = sqrt(
            (targetPoint.x * targetPoint.x) + (targetPoint.y * targetPoint.y)
        )
        let ratio = speed / distance
        return CGVector(dx: targetPoint.x * ratio, dy: -(targetPoint.y * ratio))
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

    // Contact Delegate
    func didBegin(_ contact: SKPhysicsContact) {
        if let nodeA = contact.bodyA.node as? Ball,
            let nodeB = contact.bodyB.node as? Ball {
            if nodeA.colorType == nodeB.colorType {
                addVanishmentEffect(ball: nodeA)
                addVanishmentEffect(ball: nodeB)
                nodeA.removeFromParent()
                nodeB.removeFromParent()
                screenBallCount -= 2
                return
            }
        }
        if let nodeA = contact.bodyA.node as? MyBall,
            let nodeB = contact.bodyB.node as? Ball {
            updateScore(result: (nodeA.colorType == nodeB.colorType))
            playsSoundBallHits()
            vanishBall(ball: nodeB)
            nodeB.removeFromParent()
            screenBallCount -= 1
            return
        }
        if let nodeA = contact.bodyA.node as? Ball,
            let nodeB = contact.bodyB.node as? MyBall {
            updateScore(result: (nodeA.colorType == nodeB.colorType))
            playsSoundBallHits()
            vanishBall(ball: nodeA)
            becomeInvincible()
            nodeA.removeFromParent()
            screenBallCount -= 1
            return
        }
    }

    func updateScore(result: Bool) {
        if result {
            pointUp()
            bonusPoint += 1
            feedbackContact(times: 1)
        } else {
            decreaseLife()
            bonusPoint = 0
            becomeInvincible()
            feedbackContact(times: 2)
        }
    }

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
        myBall.removeSatelliteOrbital(name: "orbital\(life)")
        life -= 1
        scoreLabel.fontColor = .gray

        if life == 0 {
            pauseButton.isHidden = true

            scoreLabel.zPosition = 100

            messageLabel.isHidden = false

            myBall.removeFromParent()


            highScoreLabel.isHidden = false
            if totalScore > highScore {
                highScore = totalScore
                userDefaults.set(highScore, forKey: "HighScore")
                highScoreLabel.text = "NEW HIGH SCORE!"
                highScoreLabel.fontColor = .orange
                scoreLabel.fontColor = .orange
            } else {
                highScoreLabel.text = "HIGH SCORE: \(highScore)"
                highScoreLabel.fontColor = .gray
            }


            exitButton.isHidden = false
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
            messageLabel.fontColor = SKColor.orange
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
            ]), completion: {
                self.addGameOverEffect(myBall: nextBall)
        })
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
}
