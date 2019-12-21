import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let moveJoystick = TLAnalogJoystick(withDiameter: 100)
    var moveJoystickHiddenArea: TLAnalogJoystickHiddenArea!
    var playerNode: PlayerNode!
    let remotePlayersNode = SKNode()
    
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
    
    deinit {
        ConnectionFacade.instance.disconnect()
    }
    
    func setupMap() {
        self.mapBounds = CGRect(x: 0, y: 0, width: mapWidth, height: mapHeight)
        
        let backgroundNode = SKShapeNode(rect: mapBounds)
//        backgroundNode.fillTexture = SKTexture(image: UIImage(named: "map")!)
        backgroundNode.fillColor = .white
        
        self.addChild(backgroundNode)
    }
    
    func setupPlayer() {
        physicsBody = SKPhysicsBody(edgeLoopFrom: mapBounds)
        
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
    
    func attack(){
        
        self.playerNode.gunNode.run(.sequence([.moveBy(x: 0, y: 100, duration: 0.5), .moveBy(x: 0, y: -100, duration: 0.5)]))
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
            let pVelocity = joystick.velocity
//            let speed = CGFloat(0.12)
//            print("Velocity is", joystick.angular, pVelocity)
            ConnectionFacade.instance.updateDirection(to: joystick.angular)
//            self.playerNode.updatePlayer(velocity: pVelocity, rotation: joystick.angular)
        }
        
        moveJoystick.on(.end) { [unowned self] _ in
            self.playerNode.velocity = .zero
//            self.playerNode.delegatePlayerUpdate()
//            self.playerNode.needsUpdate = false
        }

    }

    
    override func didMove(to view: SKView) {
        view.isMultipleTouchEnabled = true
        backgroundColor = .white

        self.remotePlayersNode.name = "remotePlayersNode"
        self.addChild(self.remotePlayersNode)
        
        self.setupMap()
        self.setupCamera()
        self.setupFire(on: view)
        self.setupJoystick()
        
        
    }

    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    
    @objc func onFire(_ sender: Any){
        self.attack()
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
    
    var lastRemoteUpdate: TimeInterval?
    
    override func update(_ currentTime: TimeInterval) {
//        print("Updating")
        guard let cameraController = self.cameraController else { return }
        cameraController.updateCamera()
//        self.playerNode.update()
//        self.updateRemotePlayers()
//
//        if let last = self.lastRemoteUpdate{
//            let timeDiff = currentTime - last
//
//            if timeDiff > 1/30{
//                self.playerNode.delegatePlayerUpdate()
//                self.lastRemoteUpdate = currentTime
//            }
//        } else {
//            self.playerNode.delegatePlayerUpdate()
//            self.lastRemoteUpdate = currentTime
//        }
//
////        print("Updated")
    }
    
    func updateGame(_ newGame: NetworkGame) {
        
    }
    
    func updateRemotePlayers(){
        for node in self.children{
            if let pNode = node as? PlayerNode{
//                pNode.update()
            }
        }
    }
    
    
    func updatePlayer(_ update: PlayerUpdate){
        guard let node = self.childNode(withName: update.id), let playerNode = node as? PlayerNode else { return }
        playerNode.updatePlayer(velocity: update.velocity, rotation: update.zRotation)
        node.position = update.position
    }
    
    func updateGame(to newGame: _Game) {
        guard let remotePlayersNode = self.getRemotePlayersNode() else { return }
        
        let existingPlayers =
            remotePlayersNode.children.map({ (node) -> String in
            return node.name ?? ""
            }).filter { (s) -> Bool in
                return s != ""
        }
        
        
        let newPlayers = newGame.players.filter { (player) -> Bool in
            return !existingPlayers.contains(player.id)
        }
        
        for player in newPlayers {
            let newPlayer = RemotePlayerNode(playerId: player.id, color: .blue)
            if player.id == ConnectionFacade.instance.getCurrentPlayerId() {
                self.playerNode = newPlayer

                self.setupPlayer()
            }
            remotePlayersNode.addChild(newPlayer)
        }
        
        for player in newGame.players {
            guard let playerNode = remotePlayersNode.childNode(withName: player.id) as? PlayerNode else { return }
            
//            playerNode.position = player.position.getCGPoint()
//            playerNode.angularRotation = -CGFloat(player.direction)
            playerNode.updatePlayer(velocity: player.position.getCGPoint(), rotation: CGFloat(player.direction) - (CGFloat.pi / 2))
            
        }
    }
    
    func getRemotePlayersNode() -> SKNode? {
        return self.childNode(withName: "remotePlayersNode")
    }
}
