import SpriteKit
import GameplayKit

import SpriteKit
import GameplayKit

class SampleScene: SKScene {

    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var myBall: MyBall!
    var gravityNode: MyBall!
    var circle: SKShapeNode!
    var dots: SKShapeNode!

    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.white
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)

        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)

        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5

            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }

        myBall = MyBall(circleOfRadius: 50)
        myBall.fillColor = .blue
        myBall.physicsBody?.isDynamic = true
        myBall.physicsBody?.affectedByGravity = false
        self.addChild(myBall)

        gravityNode = MyBall(circleOfRadius: 50)
        gravityNode.fillColor = .red
        gravityNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 300)
        self.addChild(gravityNode)

        var d = 45.0
        var rx = 200.0
        var ry = 100.0
        var x = rx * cos(d * M_PI / 180.0)
        var y = ry * sin(d * M_PI / 180.0)
        var p = CGPoint(x: frame.width/2 + CGFloat(x), y: frame.height/2 + CGFloat(y))
        dots = SKShapeNode(circleOfRadius: 10)
        dots?.position = p
        dots.fillColor = .green

        circle = SKShapeNode(circleOfRadius: 45)
        circle.fillColor = .red
        circle.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 300)
        circle.addChild(dots)
    }


    func touchDown(atPoint pos : CGPoint) {

        //gravityNode.position = pos
        dots.position = pos

        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }

    func touchMoved(toPoint pos : CGPoint) {
        //gravityNode.position = pos
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }

    func touchMoved2(touch : UITouch) {
        let pos = touch.location(in: self)
        let previousPos = touch.preciseLocation(in: self.view)
        print("Pos: \(pos)")
        print("prevPos: \(previousPos)")
        let r = atan2(previousPos.y - pos.y, previousPos.x - pos.x)

        let rotateAction = SKAction.rotate(toAngle: r, duration: 0)
        gravityNode.run(rotateAction)
    }

    func touchUp(atPoint pos : CGPoint) {

        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchMoved(toPoint: t.location(in: self))
            self.touchMoved2(touch: t)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }


    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
