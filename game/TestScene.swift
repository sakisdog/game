import SpriteKit
import GameplayKit

class TestScene: SKScene, SKPhysicsContactDelegate {
    private var label: SKLabelNode?
    var paddle: SKShapeNode!
    var left: CGFloat?
    var right: CGFloat?
    var blocks = [SKShapeNode]()
    var moving: Bool = false

    override func didMove(to view: SKView) {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsWorld.contactDelegate = self
        left = -(self.frame.width/2.0)
        right = (self.frame.width/2.0)

        //initSceneBalls()
        //initSceneBlocks()
        initPaddle()

        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(TestScene.dropBall), userInfo: nil, repeats: true)
    }

    func initPaddle() {
        paddle = SKShapeNode(circleOfRadius: 100)
        paddle.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        paddle.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        paddle.physicsBody?.contactTestBitMask = 1
        paddle.physicsBody?.isDynamic = false
        paddle.fillColor = .brown
        self.addChild(paddle)
    }

    func newBall() -> SKNode {
        let colors:[SKColor] = [.red, .blue, .green, .yellow, .purple]
        let index = (Int)(arc4random_uniform(5))
        let color: SKColor = colors[index]
        let ball = SKShapeNode(circleOfRadius: 30.0)
        ball.strokeColor = SKColor.black
        ball.fillColor = color
        ball.lineWidth = 0
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 30.0)
        ball.physicsBody?.contactTestBitMask = 1
        ball.physicsBody?.restitution = 1.0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.friction = 0
        switch color {
        case SKColor.red:
            ball.name = "ball_red"
        case SKColor.blue:
            ball.name = "ball_blue"
        case SKColor.green:
            ball.name = "ball_green"
        case SKColor.yellow:
            ball.name = "ball_yellow"
        case SKColor.purple:
            ball.name = "ball_purple"
        default:
            ball.name = "ball"
        }

        return ball
    }

    func dropBall() {
        if moving {
            let ball = newBall()
            ball.position = CGPoint(x: paddle.frame.midX, y: self.frame.maxY - 20.0)
            self.addChild(ball)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        moving = true
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let location = touch.location(in: self)
        paddle.position = CGPoint(x: location.x, y: location.y)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        moving = false
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node as? SKShapeNode,
            let nodeB = contact.bodyB.node as? SKShapeNode else {
            return
        }
        if nodeA.name?.contains("ball") == true {
            nodeA.physicsBody?.affectedByGravity = false
        }
        if nodeB.name?.contains("ball") == true {
            nodeB.physicsBody?.affectedByGravity = false
        }

        if nodeA.name == nodeB.name {
            var soundFile = "piano_do.mp3"
            if nodeA.name == "ball_red" {
                soundFile = "piano_do.mp3"
            }
            if nodeA.name == "ball_blue" {
                soundFile = "piano_re.mp3"
            }
            if nodeA.name == "ball_green" {
                soundFile = "piano_mi.mp3"
            }
            if nodeA.name == "ball_yellow" {
                soundFile = "piano_fa.mp3"
            }
            if nodeA.name == "ball_purple" {
                soundFile = "piano_so.mp3"
            }
            let action = SKAction.playSoundFileNamed(soundFile, waitForCompletion: true)
            self.run(action)
            nodeA.removeFromParent()
            nodeB.removeFromParent()
        }
    }
}
