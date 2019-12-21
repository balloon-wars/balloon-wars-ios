import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var gameScene: GameScene!
    var remotePlayers: [RemotePlayerNode]! = [RemotePlayerNode]()
    
    override func viewDidLoad() {
        ConnectionFacade.instance.setupConnection()
        super.viewDidLoad()
        print("SIZE IS", self.view.bounds.size)
        self.view.backgroundColor = UIColor.white
        let scene = GameScene(size: self.view.bounds.size)
        scene.backgroundColor = .white
        scene.viewController = self
        self.gameScene = scene
//        NotificationCenter.default.addObserver(self, selector: #selector(self.onUpdate(_:)), name: ConnectionFacade.Notifications[.playerUpdated], object: nil)
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
        
    }
    
    @objc func onUpdate(_ notification: NSNotification){
        guard let update = notification.userInfo?["updates"] as? PlayerUpdate else { return }
        print("Player", update)
        
        if !self.remotePlayers.map({$0.remotePlayerId}).contains(update.id) {
            let newPlayer = RemotePlayerNode(playerId:  update.id, color: UIColor.green)
            self.gameScene.addChild(newPlayer)
            self.remotePlayers.append(newPlayer)
        }
        
        self.gameScene.updatePlayer(update)
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
