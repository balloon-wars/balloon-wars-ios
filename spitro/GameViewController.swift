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
        print("SIZE IS", self.view.bounds.size)
        self.view.backgroundColor = UIColor.white
        let scene = GameScene(size: self.view.bounds.size)
        scene.backgroundColor = .white
        self.gameScene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let view: SKView = {
            let view = SKView()
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.presentScene(self.gameScene)
            
            return view
        }()
        
        self.view.addSubview(view)
        
        view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true

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
