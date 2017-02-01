import SpriteKit
import GameplayKit

class TitleScene: SKScene {
    // MARK: - properties
    let titleLabel = SKLabelNode()
    let messageLabel = SKLabelNode()
    let colors:[ballColors] = [.red, .blue, .green, .yellow, .purple]
    var dropBallCount: Int = 0
    var screenBallCount: Int = 0
    var level: Int = 1
    var life: Int = 3

    // MARK: - methods
    override func didMove(to view: SKView) {
        initTitleLabel()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let scene = PlayScene(fileNamed: "PlayScene")
        scene?.scaleMode = .aspectFill
        self.view!.presentScene(scene)
    }

    // MARK: - private
    func initTitleLabel() {
        let index = (Int)(arc4random_uniform(UInt32(level+2)))
        let colorType: ballColors = colors[index]

        titleLabel.text = "colors"
        titleLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        titleLabel.fontSize = 200
        titleLabel.fontName = "Helvetica"
        titleLabel.fontColor = .gray

        self.addChild(titleLabel)
    }

}
