import SpriteKit
import GameplayKit

class TestScene: SKScene, SKPhysicsContactDelegate {
    private var label: SKLabelNode?
    var paddle: SKSpriteNode!
    var left: CGFloat?
    var right: CGFloat?
    var blocks = [SKShapeNode]()

    override func didMove(to view: SKView) {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsWorld.contactDelegate = self
        left = -(self.frame.width/2.0)
        right = (self.frame.width/2.0)

        initSceneBalls()
        //initSceneBlocks()
    }

    func initSceneBlocks() {
        for i in 0..<5 {
            let block = SKShapeNode(rectOf: CGSize(width: 100.0, height: 50.0))

            block.position = CGPoint(x: left! + 50.0 + CGFloat(110.0 * Double(i)), y: 10.0)
            block.fillColor = .gray
            block.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width:100, height:50))
            block.physicsBody?.contactTestBitMask = 1
            block.physicsBody?.affectedByGravity = false
            block.physicsBody?.isDynamic = false
            block.name = "block\(i)"

            self.addChild(block)

            self.blocks.append(block)
        }

    }

    func initSceneBalls() {
        //self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)

        //self.physicsWorld.gravity = CGVectorMake(0, self.physicsWorld.gravity.dy * -1.0)
        for i in 0 ..< 30 {
            let ball = newBall()
            let x: CGFloat = CGFloat(CGFloat(i) * self.frame.width / 10.0)
            let y = i % 10
            ball.position = CGPoint(x: x, y: 30 * CGFloat(y))
            ball.physicsBody?.affectedByGravity = false
            ball.physicsBody?.contactTestBitMask = 1
            self.addChild(ball)
        }
    }

    func newBall() -> SKNode {
        let colors:[SKColor] = [.blue, .red, .green, .yellow, .purple]
        let index = (Int)(arc4random_uniform(4))
        let color = colors[index]
        // このradiusの値とphysicsbodyの値の設定は同じにしとくっポイ
        let ball = SKShapeNode(circleOfRadius: 30.0)
        ball.strokeColor = SKColor.black
        ball.fillColor = color
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 30.0)

        return ball
    }


    func skRand(low: CGFloat, high: CGFloat) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (high - low) + low;
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let location = touch.location(in: self)

        let colors:[SKColor] = [.blue, .red, .green, .yellow, .purple]
        let index = (Int)(arc4random_uniform(4))
        let color = colors[index]
        // このradiusの値とphysicsbodyの値の設定は同じにしとくっポイ
        let circle = SKShapeNode(circleOfRadius: 30.0)
        circle.position = CGPoint(x:location.x, y:location.y)
        circle.strokeColor = SKColor.black
        circle.fillColor = color
        circle.physicsBody = SKPhysicsBody(circleOfRadius: 30.0)


        self.addChild(circle)
    }

    func didBegin(_ contact: SKPhysicsContact) {
        if let block = contact.bodyA.node as? SKShapeNode {
            if blocks.contains(block) {
                block.removeFromParent()
            }
        }
        contact.bodyA.node?.physicsBody?.affectedByGravity = true
        contact.bodyB.node?.physicsBody?.affectedByGravity = true
    }
}
