import SpriteKit
import GameplayKit

class TitleScene: SKScene {
    // MARK: - properties
    let titleLabel = SKLabelNode()
    let startButton = SKLabelNode()
    let colors:[ballColors] = [.red, .blue, .green, .yellow, .purple]
    let userDefaults = UserDefaults.standard
    var myColorIndex: Int = 0

    // MARK: - methods
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.white
        myColorIndex = (Int)(arc4random_uniform(UInt32(3)))
        userDefaults.set(myColorIndex, forKey: "MyColor")
        initTitleLabel()
        initStartButton()
        addChildren()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }

    func touchDown(atPoint pos : CGPoint) {
        let touchedNode = scene?.atPoint(pos)
        if (touchedNode?.name == "start") {
            let scene = GameScene(size: self.size)
            scene.scaleMode = .aspectFill
            self.view!.presentScene(scene)
        }
    }

    // MARK: - private
    func addChildren() {
        self.addChild(titleLabel)
        self.addChild(startButton)
    }

    func initTitleLabel() {
        titleLabel.text = "Frapper"
        titleLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        titleLabel.fontSize = 100
        titleLabel.fontName = "Helvetica"
        titleLabel.fontColor = colors[myColorIndex].color()
    }

    func initStartButton() {
        startButton.name = "start"
        startButton.text = "start"
        //startButton.fontName = "Helvetica"
        startButton.fontSize = 50
        startButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 150)
        startButton.fontColor = colors[myColorIndex].color()
    }
}
