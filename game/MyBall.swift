import SpriteKit

class MyBall: SKShapeNode {
    var colorType: ballColors = .black

    override init() {
        super.init()

        self.physicsBody = SKPhysicsBody(circleOfRadius: 50.0)
        self.physicsBody?.categoryBitMask = 1
        self.physicsBody?.contactTestBitMask = 1
        self.physicsBody?.collisionBitMask = 1
        self.physicsBody?.isDynamic = false
        //self.physicsBody?.affectedByGravity = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
