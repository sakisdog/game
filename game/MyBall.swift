import SpriteKit

class MyBall: SKShapeNode {
    var colorType: ballColors = .black

    override init() {
        super.init()

        self.physicsBody = SKPhysicsBody(circleOfRadius: 80.0)
        self.physicsBody?.contactTestBitMask = 1
        self.physicsBody?.isDynamic = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
