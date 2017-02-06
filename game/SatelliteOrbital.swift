import SpriteKit

extension SKShapeNode {
    //  Setting Example:
    //      let orbital = SKShapeNode(ellipseOf: CGSize(width: 90, height: 30))
    //      let satellite = SKShapeNode(circleOfRadius: 5)
    //      satellite.fillColor = myBall.colorType.color()
    //      planet.addSatelliteOribital(satellite: satelliteNode, orbital: orbitalNode, orbitalAngle: angle, reverse: isReverse, name: "orbital")
    func addSatelliteOribital(satellite: SKShapeNode, orbital: SKShapeNode, orbitalAngle: CGFloat = 0, delay: CGFloat = 0, speedRatio: Double = 1.0, reverse: Bool = false, name: String = "") {

        orbital.name = name
        orbital.lineWidth = 0
        orbital.run(SKAction.rotate(byAngle: orbitalAngle, duration: 0))

        self.addSatellite(satellite: satellite, orbital: orbital, delay: delay, speedRatio: speedRatio, reverse: reverse)
        self.addChild(orbital)
    }

    func removeSatelliteOrbital(name: String) {
        self.childNode(withName: name)?.removeFromParent()
    }

    private func addSatellite(satellite: SKShapeNode, orbital: SKShapeNode, delay: CGFloat = 0, speedRatio: Double = 1.0, reverse: Bool = false) {

        var radian = CGFloat(M_PI / 180)
        var time: CGFloat = delay
        let speed: Double = 0.05 / speedRatio
        if reverse { radian *= -1.0 }

        let oribitalRadiusX = orbital.frame.width / 2
        let oribitalRadiusY = orbital.frame.height / 2

        satellite.run(
            SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run() {
                        time += 10.0
                        satellite.position = CGPoint(
                            x: oribitalRadiusX * cos(radian * time),
                            y: oribitalRadiusY * sin(radian * time)
                        )
                        if self.contains(
                            CGPoint(x: satellite.position.x + self.position.x,
                                    y: satellite.position.y + self.position.y)
                            )
                        {
                            if sin(radian * time) > 0 {
                                satellite.zPosition = -1.0
                            }
                        } else {
                            satellite.zPosition = 1.0
                        }
                    },
                    SKAction.wait(forDuration: speed)
                    ])
            )
        )
        
        orbital.addChild(satellite)
    }
}
