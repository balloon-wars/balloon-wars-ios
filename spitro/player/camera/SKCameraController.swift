//
//  SKCameraController.swift
//  spaceProgram
//
//  Created by Enzo Maruffa Moreira on 23/08/19.
//  Copyright © 2019 minichallenge. All rights reserved.
//

import SpriteKit

class SKCameraController {
    
    var node: SKCameraNode
    var mode: SKCameraMode
    
    var lerping: Bool
    var lerpFactor: CGFloat = 0.03
    
    var followedTarget: SKNode?
    var stillTarget: CGPoint?
    
    var mapBounds: CGRect?
    var cameraBounds: CGRect?
    
    weak var cameraRootScene: SKScene?
    
    var scaleLerping: Bool = false
    var scaleLerpFactor: CGFloat = 0.05
    
    var cameraXScale: CGFloat {
        get {
            return node.xScale
        }
        set {
            if scaleLerping {
                node.xScale = lerp(a: node.xScale, b: newValue, interpolation: lerpFactor)
            } else {
                node.xScale = newValue
            }
            
            if cameraBounds != nil {
                setBounds(cameraRoot: node.scene!, mapBounds: mapBounds!)
            }
        }
    }
    var cameraYScale: CGFloat {
        get {
            return node.yScale
        }
        set {
            if scaleLerping {
                node.yScale = lerp(a: node.yScale, b: newValue, interpolation: lerpFactor)
            } else {
                node.yScale = newValue
            }
            
            if cameraBounds != nil {
                setBounds(cameraRoot: node.scene!, mapBounds: mapBounds!)
            }
        }
    }
    
    var cameraPosition: CGPoint {
        get {
            return node.position
        }
        set {
            if let bounds = cameraBounds {
                
                var newX: CGFloat
                var newY: CGFloat
                
                if newValue.x < bounds.minX {
                    newX = bounds.minX
                } else if newValue.x > bounds.maxX {
                    newX = bounds.maxX
                } else {
                    newX = newValue.x
                }
                
                if newValue.y < bounds.minY {
                    newY = bounds.minY
                } else if newValue.y > bounds.maxY {
                    newY = bounds.maxY
                } else {
                    newY = newValue.y
                }
                
                node.position = CGPoint(x: newX, y: newY)
            }
        }
    }
    
    init(cameraRootScene: SKScene, lerping: Bool, startingPosition: CGPoint = .zero, startingScale: CGFloat = 1, mapBounds: CGRect? = nil) {
        node = SKCameraNode()
        
        cameraRootScene.addChild(node)
        cameraRootScene.camera = node
        self.cameraRootScene = cameraRootScene
        
        mode = SKCameraMode.still
        
        self.lerping = lerping
        
        if mapBounds != nil {
            self.mapBounds = mapBounds
            setBounds(cameraRoot: cameraRootScene, mapBounds: mapBounds!)
        }
        
        self.cameraPosition = startingPosition
        self.cameraXScale = startingScale
        self.cameraYScale = startingScale
    }
    
    func setBounds(cameraRoot: SKNode, mapBounds: CGRect) {
        // get the scene size as scaled by `scaleMode = .AspectFill`
        
        if let scene = cameraRootScene {
            
            let scaledScreenSize = scene.viewSizeInLocalCoordinates()
            
            // inset that frame from the edges of the level
            // inset by `scaledSize / 2 - 100` to show 100 pt of black around the level
            // (no need for `- 100` if you want zero padding)
            // use min() to make sure we don't inset too far if the level is small
            let xInset = min((scaledScreenSize.width / 2),mapBounds.width / 2)
            let yInset = min((scaledScreenSize.height / 2), mapBounds.height / 2)
            
            //print(xInset, yInset)
            
            let insetContentRect = mapBounds.insetBy(dx: xInset, dy: yInset)
            
            //        print("insetContentRect", insetContentRect)
            
            self.cameraBounds = insetContentRect
            
            
            // use the corners of the inset as the X and Y range of a position constraint
            //        let xRange = SKRange(lowerLimit: insetContentRect.minX, upperLimit: insetContentRect.maxX)
            //        let yRange = SKRange(lowerLimit: insetContentRect.minY, upperLimit: insetContentRect.maxY)
            //        let levelEdgeConstraint = SKConstraint.positionX(xRange, y: yRange)\
            //
            //        levelEdgeConstraint.referenceNode = cameraRoot
            
        }
    }
    
    func updateCamera() {
        
        if mode == .following {
            
            guard let target = followedTarget else {
                return print("Please, set the to be followed target")
            }
            
            if target.rootNode != node.rootNode {
                return print("Both the camera and the target must be in the same scene!")
            }
            
            if lerping {
                self.cameraPosition = lerp(a: node.positionInScene!, b: target.positionInScene!, interpolation: lerpFactor)
            } else {
                self.cameraPosition = target.positionInScene!
            }
            
        }
    }
    
    private func lerp(a: CGPoint, b: CGPoint, interpolation: CGFloat) -> CGPoint {
        return CGPoint(x: a.x + ((b.x - a.x) * interpolation), y: a.y + ((b.y - a.y) * interpolation))
    }
    
    private func lerp(a: CGFloat, b: CGFloat, interpolation: CGFloat) -> CGFloat {
        return a + ((b - a) * interpolation)
    }
    
    func startFollowing(target: SKNode) {
        self.mode = .following
        self.followedTarget = target
    }
    
    func setScale(to scale: CGFloat) {
        
        if scaleLerping {
            let newScale = lerp(a: node.yScale, b: scale, interpolation: lerpFactor)
            node.xScale = newScale
            node.yScale = newScale
        } else {
            node.xScale = scale
            node.yScale = scale
        }
        
        if cameraBounds != nil {
            setBounds(cameraRoot: node.scene!, mapBounds: mapBounds!)
        }
    }
    
}
