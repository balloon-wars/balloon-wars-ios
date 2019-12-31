import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let moveJoystick = TLAnalogJoystick(withDiameter: 100)
    var moveJoystickHiddenArea: TLAnalogJoystickHiddenArea!
    var playerNode: PlayerNode!
    let remotePlayersNode = SKNode()
    let needlesNode = SKNode()
    
    lazy var fireNode: UIView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onFire))
//        tapGesture.intere
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.orange
        view.addGestureRecognizer(tapGesture)
        view.layer.cornerRadius = view.frame.width / 2
        
        return view
    }()
    
    var cameraController: SKCameraController!
    var viewController: GameViewController!
    
    var mapWidth: CGFloat = 4500
    var mapHeight: CGFloat = 4500
    var mapBounds: CGRect = .zero
    
    var currentGame: Game?
    
    // MARK: - SKScene overrides
    
    override func didMove(to view: SKView) {
        view.isMultipleTouchEnabled = true
        backgroundColor = .white
        
        self.remotePlayersNode.name = "remotePlayersNode"
        self.needlesNode.name = "needlesNode"
        
        self.addChild(self.remotePlayersNode)
        self.addChild(self.needlesNode)
        
        self.setupMap()
        self.setupCamera()
        self.setupFire(on: view)
        self.setupJoystick()
        
    }
    
    // MARK: - Attack
    
    func attack(){
        ConnectionFacade.instance.attack()
    }
    
    @objc func onFire(_ sender: Any){
        self.attack()
    }

    // MARK: - Update helpers

    func clearPlayerNodes(_ existingPlayers: [Player], _ playerNames: [String]) {
        
        for player in existingPlayers {
            if !playerNames.contains(player.getNodeName()) {
                self.remotePlayersNode.childNode(withName: player.getNodeName())?.removeFromParent()
                self.needlesNode.childNode(withName: player.getNeedleNodeName())?.removeFromParent()
            }
        }

    }
    
    func createNewPlayers(_ newPlayers: [Player]) {
        
        for player in newPlayers {
            let newPlayer = PlayerNode(playerId: player.getNodeName(), color: .cyan, circleOfRadius: CGFloat(player.radius))
            let newNeedle = NeedleNode(player.getNeedleNodeName(), circleOfRadius: 20)
                
            if player.id == ConnectionFacade.instance.getCurrentPlayerId() {
            
                self.playerNode = newPlayer
                self.setupPlayer()
            }
            
            self.needlesNode.addChild(newNeedle)
            self.remotePlayersNode.addChild(newPlayer)
        }
    }
    
    func updatePlayers(_ newGame: Game) {
        for player in newGame.players {
            guard let playerNode = remotePlayersNode.childNode(withName: player.getNodeName()) as? PlayerNode else { return }
            
            playerNode.updatePlayer(velocity: player.position.getCGPoint(), rotation: CGFloat(player.direction), scale: player.scale)
        
        }
    }
    
    func updateNeedles(_ newGame: Game){
        for player in newGame.players {
            
            guard let needleNode = needlesNode.childNode(withName: player.getNeedleNodeName()) as? NeedleNode else { return }
            
            needleNode.updateNeedle(position: player.needle.position.getCGPoint(), scale: player.scale)
        }
    }
    
    // MARK: - Updates
    
    override func update(_ currentTime: TimeInterval) {
        guard let cameraController = self.cameraController else { return }
        cameraController.updateCamera()
    }
    
    func updateGame(to newGame: Game) {
        
        guard let remotePlayersNode = self.getRemotePlayersNode() else { return }
        
        let existingPlayers =
            remotePlayersNode.children.map({ (node) -> String in
            return node.name ?? ""
            }).filter { (s) -> Bool in
                return s != ""
        }
                
        let newPlayers = newGame.players.filter { (player) -> Bool in
            return !existingPlayers.contains(player.getNodeName())
        }
        
        let playerNames = newGame.players.map { (p) -> String in
            return p.getNodeName()
        }
        
        
        if let currentGame = self.currentGame {
            self.clearPlayerNodes(currentGame.players, playerNames)
        }
        
        self.createNewPlayers(newPlayers)
        self.updatePlayers(newGame)
        self.updateNeedles(newGame)
        
        self.currentGame = newGame
    }
    
    // MARK: - Utils
    
    func getRemotePlayersNode() -> SKNode? {
        return self.childNode(withName: "remotePlayersNode")
    }
    
    func getNeedlesNode() -> SKNode? {
        return self.childNode(withName: "needlesNode")
    }
    
    
    // MARK: - Touch callbacks
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for t in touches { self.touchDown(atPoint: t.location(in: self.view)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    

        
    //MARK: - Setup methods
        
        func setupMap() {
            self.mapBounds = CGRect(x: 0, y: 0, width: mapWidth, height: mapHeight)
            
            let backgroundNode = SKShapeNode(rect: mapBounds)
    //        backgroundNode.fillTexture = SKTexture(image: UIImage(named: "map")!)
            backgroundNode.fillColor = .white
            
            self.addChild(backgroundNode)
        }
        
        func setupPlayer() {
    //        physicsBody = SKPhysicsBody(edgeLoopFrom: mapBounds)
            
            self.playerNode.position = CGPoint(x: frame.midX, y: frame.midY)
    //        self.addChild(self.playerNode)
            
            self.cameraController.startFollowing(target: playerNode)
            camera?.setScale(2)
        }
        
        func setupFire(on view: UIView) {
            view.addSubview(self.fireNode)
            
            fireNode.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
            fireNode.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10 - (UIDevice.current.hasNotch ? 44 : 0)).isActive = true
            
            fireNode.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.08).isActive = true
            fireNode.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.08).isActive = true
            
        }
        
        func setupCamera() {
            self.cameraController = SKCameraController(cameraRootScene: scene!, lerping: false, startingPosition: CGPoint(x: frame.midX, y: frame.midY), startingScale: 1, mapBounds: mapBounds)
        }
        
        func setupJoystick() {
                moveJoystickHiddenArea = TLAnalogJoystickHiddenArea(rect: CGRect(x: -frame.width/2, y: -frame.height/2, width: frame.width/2, height: frame.height))
                moveJoystickHiddenArea.strokeColor = .init(white: 1, alpha: 0)
                moveJoystickHiddenArea.joystick = moveJoystick
                
                self.moveJoystick.baseImage = UIImage(named: "joystick-base") ?? nil
                self.moveJoystick.handleImage = UIImage(named: "joystick-handle") ?? nil
                self.moveJoystick.isMoveable = false
                self.moveJoystick.alpha = 0.3132
                
                self.cameraController.node.addChild(moveJoystickHiddenArea)
                
                moveJoystick.on(.begin) { [unowned self] _ in
        //            self.playerNode.needsUpdate = true
                }
                
                moveJoystick.on(.move) { [unowned self] joystick in
                    ConnectionFacade.instance.updateDirection(to: joystick.angular)
                }
                
                moveJoystick.on(.end) { [unowned self] _ in
                    self.playerNode.velocity = .zero
                }

            }

}
