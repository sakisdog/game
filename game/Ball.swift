import SpriteKit

class Ball: SKShapeNode {
    var colorType: ballColors = .black

    override init() {
        super.init()

        self.strokeColor = SKColor.black
        self.lineWidth = 0

        self.physicsBody = SKPhysicsBody(circleOfRadius: 50.0)
        self.physicsBody?.categoryBitMask = 1
        self.physicsBody?.contactTestBitMask = 1
        self.physicsBody?.collisionBitMask = 1
        self.physicsBody?.restitution = 1.0
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.friction = 0
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.velocity = CGVector(dx: 200, dy: -400)
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

    func color() -> SKColor {
        switch self {
        case .red:
            return SKColor(colorLiteralRed: 244, green: 67, blue: 54, alpha: 1.0)
        case .blue:
            return SKColor(colorLiteralRed: 52, green: 152, blue: 219, alpha: 1.0)
        case .green:
            return SKColor(colorLiteralRed: 46, green: 204, blue: 113, alpha: 1.0)
        case .yellow:
            return SKColor(colorLiteralRed: 241, green: 196, blue: 15, alpha: 1.0)
        case .purple:
            return SKColor(colorLiteralRed: 155, green: 89, blue: 182, alpha: 1.0)
        default:
            return SKColor(colorLiteralRed: 52, green: 73, blue: 94, alpha: 1.0)
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
