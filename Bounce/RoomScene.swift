//
//  Scene.swift
//  Bounce
//
//  Created by Stine Richvoldsen on 6/13/14.
//  Copyright (c) 2014 SuperRunt. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class RoomScene: SCNScene {
    
    // scene creation
    
//    func createAndAddFloor() {
//        let floorNode = SCNNode()
//        let floor = SCNFloor()
//        floor.reflectionFalloffEnd = 10.0
//        floorNode.geometry = floor
//        self.rootNode.addChildNode(floorNode)
//        
//        let flooring = SCNMaterial()
//        flooring.diffuse.contents = UIImage(named: "bg")
//        floorNode.geometry.firstMaterial = flooring
//        
//        let floorPhysics = SCNPhysicsBody(type: SCNPhysicsBodyType.Static, shape: SCNPhysicsShape(node:floorNode, options: nil))
//        floorNode.physicsBody = floorPhysics
//    }
//    
    func createAndAddBackground( viewWidth: Float ) {
        let backWallNode = SCNNode()
        let wallPhysics = SCNPhysicsBody(type: SCNPhysicsBodyType.Static, shape: SCNPhysicsShape(node:backWallNode, options: nil))
        backWallNode.physicsBody = wallPhysics
        self.rootNode.addChildNode(backWallNode)
    }
    
    
}
