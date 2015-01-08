//
//  BallNode.swift
//  FunAndGames
//
//  Created by Stine Richvoldsen on 6/12/14.
//  Copyright (c) 2014 Focus43. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class BallNode: SCNNode {
    
    override init() {
        super.init()
        setSpecs()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSpecs() {
        self.geometry = SCNSphere(radius: 10)
        self.position = SCNVector3Make(0, 0, 5)
        
        // create and configure a material
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "texture")
        material.specular.contents = UIColor.grayColor()
        material.locksAmbientWithDiffuse = true
        
        // set the material to the 3d object geometry
        self.geometry?.firstMaterial = material
        
        // animate the 3d object
        //        let animation: CABasicAnimation = CABasicAnimation(keyPath: "rotation")
        //        animation.toValue = NSValue(SCNVector4: SCNVector4(x: 1, y: 1, z: 0, w: Float(M_PI)*2))
        //        animation.duration = 5
        //        animation.repeatCount = MAXFLOAT //repeat forever
        //        ballNode.addAnimation(animation, forKey: nil)
        
        
        // create and add physics objcets
        let ballPhysics = SCNPhysicsBody(type: SCNPhysicsBodyType.Dynamic, shape: SCNPhysicsShape(node:self, options: nil))
        ballPhysics.angularVelocity = SCNVector4(x: 1, y: 1, z: 0, w: Float(M_PI))
        ballPhysics.mass = 3.0
        ballPhysics.restitution = 0.75
        
        self.physicsBody = ballPhysics
        
    }    
}
