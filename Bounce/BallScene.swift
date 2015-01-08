//
//  BallScene.swift
//  Bounce
//
//  Created by Stine Richvoldsen on 6/13/14.
//  Copyright (c) 2014 SuperRunt. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class BallScene: SCNScene {
    
    func createAndAddBall() {
        let ballNode = BallNode()
        self.rootNode.addChildNode(ballNode)
    }
   
}
