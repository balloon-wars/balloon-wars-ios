import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var playerNode: SKSpriteNode = SKSpriteNode(color: .green, size: CGSize(width: 200, height: 200))
    let moveJoystick = TLAnalogJoystick(withDiameter: 100)
    
    var cameraController: SKCameraController?
    
    var mapWidth: CGFloat = 4500
    var mapHeight: CGFloat = 4500
    var mapBounds: CGRect = .zero
    
    override func didMove(to view: SKView) {
        mapBounds = CGRect(x: 0, y: 0, width: mapWidth, height: mapHeight)
        let bgNode = SKShapeNode(rect: mapBounds)
        bgNode.fillTexture = SKTexture(image: UIImage(named: "map")!)
        bgNode.fillColor = .white
        
        self.addChild(bgNode)
        
        backgroundColor = .white
        physicsBody = SKPhysicsBody(edgeLoopFrom: mapBounds)
        
        let texture = SKTexture(image: UIImage(named: "balloon")!)
        playerNode.position = CGPoint(x: frame.midX, y: frame.midY)
        playerNode.texture = texture
        playerNode.physicsBody = SKPhysicsBody(texture: texture, size: playerNode.size)
        playerNode.physicsBody!.affectedByGravity = false
        
        let moveJoystickHiddenArea = TLAnalogJoystickHiddenArea(rect: CGRect(x: -frame.width/2, y: -frame.height/2, width: frame.width/2, height: frame.height))
        moveJoystickHiddenArea.strokeColor = .init(white: 1, alpha: 0)
        moveJoystickHiddenArea.joystick = moveJoystick
        
        moveJoystick.baseImage = UIImage(named: "joystick-base") ?? nil
        moveJoystick.handleImage = UIImage(named: "joystick-handle") ?? nil
        moveJoystick.isMoveable = false
        moveJoystick.alpha = 0.3132
        
        
        self.createCamera()
        camera?.setScale(3)
        
        addChild(playerNode)
        cameraController?.node.addChild(moveJoystickHiddenArea)
        
        
        moveJoystick.on(.begin) { [unowned self] _ in
            
        }
        
        moveJoystick.on(.move) { [unowned self] joystick in
            let pVelocity = joystick.velocity
            let speed = CGFloat(0.118948192)
            
            self.playerNode.position = CGPoint(x: self.playerNode.position.x + (pVelocity.x * speed), y: self.playerNode.position.y + (pVelocity.y * speed))
        }
        
        
        moveJoystick.on(.end) { [unowned self] _ in
            
        }
        
        
    }
    
    
    func createCamera() {
        self.cameraController = SKCameraController(cameraRootScene: scene!, lerping: true, startingPosition: playerNode.position, startingScale: 1, mapBounds: mapBounds)
        self.cameraController?.startFollowing(target: playerNode)
    }

    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        guard let cameraController = self.cameraController else { return }
        cameraController.updateCamera()
    }
}
