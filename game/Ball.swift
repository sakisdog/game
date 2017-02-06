import SpriteKit

class Ball: SKShapeNode {
    var colorType: ballColors = .black

    override init() {
        super.init()

        self.strokeColor = SKColor.black
        self.lineWidth = 0
        self.zPosition = 1

        self.physicsBody = SKPhysicsBody(circleOfRadius: 30.0)
        self.physicsBody?.categoryBitMask = 1
        self.physicsBody?.contactTestBitMask = 1
        self.physicsBody?.collisionBitMask = 1
        self.physicsBody?.restitution = 1.0
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.friction = 0
        self.physicsBody?.affectedByGravity = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MyBall: SKShapeNode {
    var colorType: ballColors = .black

    override init() {
        super.init()

        self.zPosition = 1
        self.physicsBody = SKPhysicsBody(circleOfRadius: 30.0)
        self.physicsBody?.categoryBitMask = 1
        self.physicsBody?.contactTestBitMask = 1
        self.physicsBody?.collisionBitMask = 1
        self.physicsBody?.isDynamic = false

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum ballColors {
    case red
    case blue
    case green
    case yellow
    case purple
    case black

    func color() -> UIColor {
        switch self {
        case .red:
            return UIColor().flatRed
        case .blue:
            return UIColor().flatBlue
        case .green:
            return UIColor().flatGreen
        case .yellow:
            return UIColor().flatYellow
        case .purple:
            return UIColor().flatPurple
        default:
            return UIColor().flatGray
        }
    }

    func bodyColor() -> UIColor {
        switch self {
        case .red:
            return UIColor().flatLightRed
        case .blue:
            return UIColor().flatLightBlue
        case .green:
            return UIColor().flatLightGreen
        case .yellow:
            return UIColor().flatLightYellow
        case .purple:
            return UIColor().flatLightPurple
        default:
            return UIColor().flatLightGray
        }
    }

    func nightColor() -> UIColor {
        switch self {
        case .red:
            return UIColor.rgb(r: 11, g: 188, b: 201, alpha: 1.0)
        case .blue:
            return UIColor.rgb(r: 203, g: 103, b: 36, alpha: 1.0)
        case .green:
            return UIColor.rgb(r: 209, g: 51, b: 142, alpha: 1.0)
        case .yellow:
            return UIColor.rgb(r: 14, g: 59, b: 240, alpha: 1.0)
        case .purple:
            return UIColor.rgb(r: 100, g: 166, b: 73, alpha: 1.0)
        default:
            return UIColor.rgb(r: 255, g: 255, b: 255, alpha: 1.0)
        }
    }

    func sound() -> String {
        switch self {
        case .red:
            return "piano_do.mp3"
        case .blue:
            return "piano_re.mp3"
        case .green:
            return "piano_mi.mp3"
        case .yellow:
            return "piano_fa.mp3"
        case .purple:
            return "piano_so.mp3"
        default:
            return ""
        }
    }
}
