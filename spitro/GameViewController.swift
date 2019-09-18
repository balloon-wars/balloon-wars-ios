import UIKit
import SpriteKit
import GameplayKit

protocol GameUpdateDelegate{
    func onUpdate()
}

class GameViewController: UIViewController, GameUpdateDelegate {

    var gameScene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: self.view.bounds.size)
        scene.backgroundColor = .white
        self.gameScene = scene
        if let view = self.view as? SKView {
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.presentScene(scene)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ConnectionFacade.instance.setUpdateReceiver(to: self)
    }
    
    func onUpdate(){
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIDevice.current.userInterfaceIdiom == .phone ? .allButUpsideDown : .all
    }

    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return UIRectEdge.all
    }
}
