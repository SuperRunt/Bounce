//
//  ScrollingNode.swift
//  Bounce
//
//  Created by Stine Richvoldsen on 6/13/14.
//  Copyright (c) 2014 SuperRunt. All rights reserved.
//

//import UIKit
//import QuartzCore
//import SceneKit
//
//class ScrollingNode: SCNNode {
//    
//    var scrollingSpeed: Float = 1.0
//    var contW: Float = 0.0
//    
//    class func nodeWithImageNamed(name: String, containerWidth: Float) -> ScrollingNode {
//        
//        let planeNode = ScrollingNode()
//        planeNode.contW = containerWidth
//        let image = UIImage(named: name)
//        let imgHt: Float = Float(image.size.height)
//        let imgWt: Float = Float(image.size.width)
//        
//        planeNode.geometry = SCNPlane(width: containerWidth, height: imgHt)
//        let planeMatr = SCNMaterial()
//        planeMatr.diffuse.contents = UIImage(named: "bg")
//        planeNode.geometry.firstMaterial = planeMatr
//        
//        var total: Float = 0
//        
//        while ( total < (containerWidth + imgWt) ) {
//            
//            let childNode = ScrollingNode()
//            childNode.geometry = SCNPlane(width: containerWidth, height: imgHt)
//            
//            childNode.geometry.firstMaterial = planeMatr
//            
//            childNode.position = SCNVector3Make(total, 0, 0)
//            
//            planeNode.addChildNode(childNode)
//            
//            total += imgWt;
//        }
//        
//        return planeNode
//    }
//    
//    func update(currentTime: NSTimeInterval) {
//        
//        self.enumerateChildNodesUsingBlock ({
//            ( child, stop: CMutablePointer) in
//            
//            let xPos = child.position.x
//            let yPos = child.position.y
//            child.position = SCNVector3Make( xPos-self.scrollingSpeed, yPos, 0);
//            
//            if ( xPos <= -self.contW ) {
//                let delta = xPos + self.contW;
//                var cnt = Float(self.childNodes.count) - 1.0
//                
//                child.position = SCNVector3Make(self.contW*cnt+delta , yPos, 0)
//            }
//            
//        })
//    }
//    
//}