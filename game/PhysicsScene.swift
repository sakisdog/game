import SpriteKit
import GameplayKit

class PhysicsScene: SKScene {
    func createSceneContents() {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)

        //self.physicsWorld.gravity = CGVectorMake(0, self.physicsWorld.gravity.dy * -1.0)
        for _ in 0 ..< 30 {
            self.addChild(self.newBall())
        }
    }

    func newBall() -> SKNode {
        let ball = SKShapeNode()
        let path = CGMutablePath()
        let r = skRand(low: 3, high: 30)
        //CGPathAddArc(path, nil, 0, 0, r, 0, M_PI * 2, true)
        ball.path = path
        ball.fillColor = UIColor(colorLiteralRed: Float(skRand(low: 0, high: 1.0)), green: Float(skRand(low: 0, high: 1.0)), blue: Float(skRand(low: 0, high: 1.0)), alpha: Float(skRand(low: 0.7, high: 1.0)))
        ball.strokeColor = SKColor.clear
        ball.position = CGPoint(x:skRand(low: 0, high: self.frame.size.width), y:skRand(low: 0, high: self.frame.size.height))
        ball.physicsBody = SKPhysicsBody(circleOfRadius: r)
        return ball
    }


    func skRand(low: CGFloat, high: CGFloat) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (high - low) + low;
    }
}
