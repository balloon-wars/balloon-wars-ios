import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let moveJoystick = TLAnalogJoystick(withDiameter: 100)
    var moveJoystickHiddenArea: TLAnalogJoystickHiddenArea!
    let playerNode: LocalPlayerNode = LocalPlayerNode(color: .green, size: CGSize(width: 200, height: 200))
    
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
    
    var mapWidth: CGFloat = 4500
    var mapHeight: CGFloat = 4500
    var mapBounds: CGRect = .zero
    
    
    func setupMap() {
        self.mapBounds = CGRect(x: 0, y: 0, width: mapWidth, height: mapHeight)
        
        let backgroundNode = SKShapeNode(rect: mapBounds)
        backgroundNode.fillTexture = SKTexture(image: UIImage(named: "map")!)
        backgroundNode.fillColor = .white
        
        self.addChild(backgroundNode)
    }
    
    func setupPlayer() {
        physicsBody = SKPhysicsBody(edgeLoopFrom: mapBounds)
        
        self.playerNode.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(self.playerNode)
        
    }
    
    func setupFire(on view: UIView) {
        view.addSubview(self.fireNode)
        
        fireNode.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        fireNode.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10 - (UIDevice.current.hasNotch ? 44 : 0)).isActive = true
        
        fireNode.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.08).isActive = true
        fireNode.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.08).isActive = true
        
    }
    
    func setupCamera() {
        self.cameraController = SKCameraController(cameraRootScene: scene!, lerping: false, startingPosition: playerNode.position, startingScale: 1, mapBounds: mapBounds)
        self.cameraController.startFollowing(target: playerNode)
        camera?.setScale(2)
        
        
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
            
        }
        
        moveJoystick.on(.move) { [unowned self] joystick in
            let pVelocity = joystick.velocity
            let speed = CGFloat(0.12)
            
            if pVelocity.x != 0 && pVelocity.y != 0 {
                self.playerNode.zRotation = joystick.angular
            }
            
            self.playerNode.position = CGPoint(x: self.playerNode.position.x + (pVelocity.x * speed), y: self.playerNode.position.y + (pVelocity.y * speed))
        }
        
        moveJoystick.on(.end) { [unowned self] _ in
            
        }

    }

    
    override func didMove(to view: SKView) {
        view.isMultipleTouchEnabled = true
        backgroundColor = .white

        
        self.setupMap()
        self.setupPlayer()
        self.setupCamera()
        self.setupFire(on: view)
        self.setupJoystick()
    }

    
    func touchDown(atPoint pos : CGPoint) {
//        if fireNode.contains(pos) {
//            print("1")
//        }
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
    
    
    override func update(_ currentTime: TimeInterval) {
        guard let cameraController = self.cameraController else { return }
        cameraController.updateCamera()
    }
    
    func updatePlayer(_ update: PlayerUpdate){
        guard let node = self.childNode(withName: update.id) else { return }
        node.position = update.position
        node.zRotation = update.zRotation
    }
}
