import UIKit
import SpriteKit

class PauseView: UIView{

    var backGroundView : UIView!
    var scene : SKScene!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    init(scene : SKScene,frame : CGRect){
        super.init(frame: scene.view!.bounds)

        // 自分が追加されたシーン.
        self.scene = scene

        // シーン内をポーズ.
        self.scene.view!.isPaused = true

        // シーン内のタッチを検出させなくする.
        //self.scene.isUserInteractionEnabled = false

        self.layer.zPosition = 10

        // シーン全体を被せる背景を追加.
        self.backGroundView = UIView(frame: scene.view!.bounds)
        //self.backGroundView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
        self.backGroundView.layer.position = scene.view!.center
        self.addSubview(backGroundView)

//        let unpauseButton = UIButton(frame: CGRect(x: 0, y: 0, width: backGroundView.frame.width/2, height: 50))
//        unpauseButton.setTitle("Unpause", for: .normal)
//        unpauseButton.setTitleColor(.gray, for: .normal)
//        unpauseButton.titleLabel?.font = UIFont(name: "", size: 50)
//        unpauseButton.layer.position = CGPoint(x: backGroundView.center.x, y: backGroundView.center.y + 50)
//        unpauseButton.addTarget(self, action: #selector(didTapUnpauseButton), for: .touchUpInside)
//        self.addSubview(unpauseButton)
//
//
//        let exitButton = UIButton(frame: CGRect(x: 0, y: 0, width: backGroundView.frame.width/2, height: 50))
//        exitButton.setTitle("Exit to Menu", for: .normal)
//        exitButton.titleLabel?.font = UIFont(name: "", size: 50)
//        exitButton.setTitleColor(.gray, for: .normal)
//        exitButton.layer.position = CGPoint(x: backGroundView.center.x, y: unpauseButton.center.y + 50)
//        exitButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
//        self.addSubview(exitButton)


    }

    func didTapUnpauseButton(sender : UIButton){
        if let scene = self.scene as? GameScene {
            scene.view!.isPaused = false
            scene.isUserInteractionEnabled = true
            self.removeFromSuperview()
            scene.unpause()
        }

    }

    func didTapExitButton(sender : UIButton){
        if let scene = self.scene as? GameScene {
            scene.view!.isPaused = false
            scene.isUserInteractionEnabled = true
            self.removeFromSuperview()
            scene.presentTitleScene()
        }
    }
}
