import SpriteKit
import GameplayKit

class CircleScene: SKScene {
    // MARK: - properties
    let colors:[ballColors] = [.red, .blue, .green, .yellow, .purple]
    var ball: SKShapeNode!
    let userDefaults = UserDefaults.standard
    var myColorIndex: Int = 0

    //weak var scene : SKScene?
    var levels = [100, 100, 100, 100] // max 100

    // MARK: - methods
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.white

        ball = SKShapeNode(circleOfRadius: 50)
        ball.lineWidth = 10
        ball.fillColor = .red
        ball.position = CGPoint(x: self.frame.midX + 50, y: self.frame.midY + 50)
        self.addChild(ball)

        var orbital: SKShapeNode!
        orbital = SKShapeNode(ellipseOf: CGSize(width: 200, height: 50))
        var satellite: SKShapeNode!
        satellite = SKShapeNode(circleOfRadius: 10)
        satellite.fillColor = .purple

        ball.addSatelliteOribital(satellite: satellite, orbital: orbital)




        var orbital2: SKShapeNode!
        orbital2 = SKShapeNode(ellipseOf: CGSize(width: 200, height: 50))
        var satellite2: SKShapeNode!
        satellite2 = SKShapeNode(circleOfRadius: 10)
        satellite2.fillColor = .cyan

        ball.addSatelliteOribital(satellite: satellite2, orbital: orbital2, orbitalAngle: 0.5, speedRatio: 1, reverse: true)


//        var orbital3: SKShapeNode!
//        orbital3 = SKShapeNode(ellipseOf: CGSize(width: 200, height: 50))
//        var satellite3: SKShapeNode!
//        satellite3 = SKShapeNode(circleOfRadius: 10)
//        satellite3.fillColor = .red
//
//        ball.addSatelliteOribital(satellite: satellite3, orbital: orbital3, orbitalAngle: 1.5, speedRatio: 1)
    }

    func touchMoved(toPoint pos : CGPoint) {
        ball.position = pos
    }


    func touchUp(atPoint pos : CGPoint) {

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchMoved(toPoint: t.location(in: self))
        }
    }
}

//extension Array {
//    func foreach (doit:(Element, Int) -> Void) {
//        for (i, e) in enumerate(self) { doit(e, i) }
//    }
//}
