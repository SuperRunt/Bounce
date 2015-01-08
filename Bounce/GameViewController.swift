//
//  GameViewController.swift
//  Bounce
//
//  Created by Stine Richvoldsen on 6/13/14.
//  Copyright (c) 2014 SuperRunt. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import CoreMotion
import GameController
import SpriteKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {
    
    var ball = BallNode()
    var mainCamera = SCNNode()
    var motionManager = CMMotionManager()
    var accelerometer = [UIAccelerationValue](count: 3, repeatedValue: 0.0)
    var orientation = SCNVector3Zero
//    var orientation: Float = 0.0
    
    func setupEnvironment( scene: SCNScene) {
        
        // add ambient light
        var ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = SCNLightTypeAmbient
        ambientLight.light?.color = UIColor(white:0.3, alpha:1.0)
        scene.rootNode.addChildNode(ambientLight)
        
        // add key light
        var lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = SCNLightTypeOmni;
        lightNode.light?.color = UIColor(white:0.8, alpha:1.0)
        lightNode.position = SCNVector3Make(0, 80, 30)
        let rotationRad = Float(-M_PI/2.8)
        lightNode.rotation = SCNVector4Make(1,0,0,rotationRad)
        lightNode.light?.spotInnerAngle = 0
        lightNode.light?.spotOuterAngle = 50
        lightNode.light?.shadowColor = UIColor.blackColor()
        lightNode.light?.zFar = 500
        lightNode.light?.zNear = 50;
        scene.rootNode.addChildNode(lightNode)
        
        var floorNode = SCNNode()
        var floor = SCNFloor()
        floor.reflectionFalloffEnd = 10.0
        floorNode.geometry = floor
        scene.rootNode.addChildNode(floorNode)
        
        var flooring = SCNMaterial()
        flooring.diffuse.contents = UIImage(named: "wood")
        floorNode.geometry?.firstMaterial = flooring
        
        let floorPhysics = SCNPhysicsBody(type: SCNPhysicsBodyType.Static, shape: SCNPhysicsShape(node:floorNode, options: nil))
        floorNode.physicsBody = floorPhysics
        
    }
    
    func setupSceneElements ( scene: SCNScene ) {
        
        // add a couple of blocks
        self.addBlockToScene(scene, imageNamed: "winterdawn", atPosition: SCNVector3Make(-10, 15, 10))
        self.addBlockToScene(scene, imageNamed: "winterdawn", atPosition: SCNVector3Make(-9, 10, 10))
        
        // ceiling
        var ceiling = SCNNode(geometry: (SCNPlane(width: 400, height: 400)))
        ceiling.position = SCNVector3Make(0, 100, 0)
        ceiling.rotation = SCNVector4Make(1, 0, 0, Float(M_PI_2))
        ceiling.geometry?.firstMaterial?.doubleSided = false
        ceiling.castsShadow = false
        ceiling.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
        ceiling.geometry?.firstMaterial?.diffuse.contents = "winterdawn"
        scene.rootNode.addChildNode(ceiling)

        // walls 
        let box = SCNBox(width: 400, height: 100, length: 4, chamferRadius: 0)
        
        var wall = SCNNode(geometry: box)
        wall.geometry?.firstMaterial?.diffuse.contents = "wall"
        wall.geometry?.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Mult(SCNMatrix4MakeScale(24, 2, 1), SCNMatrix4MakeTranslation(0, 1, 0))
        wall.geometry?.firstMaterial?.diffuse.wrapS = SCNWrapMode.Repeat
        wall.geometry?.firstMaterial?.diffuse.wrapT = SCNWrapMode.Mirror
        wall.geometry?.firstMaterial?.doubleSided = false
        wall.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
        wall.castsShadow = false
        wall.position = SCNVector3Make(0, 50, -123)
        wall.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Static, shape: SCNPhysicsShape(node:wall, options: nil))
        scene.rootNode.addChildNode(wall)

        wall = wall.clone() as SCNNode
        wall.position = SCNVector3Make(-120, 50, 0)
        wall.rotation = SCNVector4Make(0, 1, 0, Float(M_PI_2))
        wall.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Static, shape: SCNPhysicsShape(node:wall, options: nil))
        scene.rootNode.addChildNode(wall)
        
        wall = wall.clone() as SCNNode
        wall.position = SCNVector3Make(120, 50, 0)
        wall.rotation = SCNVector4Make(0, 1, 0, Float(-M_PI_2))
        wall.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Static, shape: SCNPhysicsShape(node:wall, options: nil))
        scene.rootNode.addChildNode(wall)
        
//        let backWall = SCNNode(geometry: SCNPlane(width: 400, height: 100))
//        backWall.geometry.firstMaterial = wall.geometry.firstMaterial
//        backWall.position = SCNVector3Make(0, 50, 200)
//        backWall.rotation = SCNVector4Make(0, 1, 0, Float(M_PI))
//        backWall.castsShadow = false
//        backWall.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Static, shape: SCNPhysicsShape(node:backWall, options: nil))
//        scene.rootNode.addChildNode(backWall)

        // add a few more blocks
        for ( var i=0; i<3; i++ ) {
            let randX = Float(rand()%60 - 30)
            let randY = Float(rand()%40 - 20)
            self.addBlockToScene(scene, imageNamed: "wheel", atPosition: SCNVector3Make( randX, 20, randY))
        }
    }
    
    func setupBall (scene: SCNScene) {
        scene.rootNode.addChildNode(ball)
    }
    
    func setupScene() -> SCNScene {
        
        var scene = SCNScene()
        self.setupEnvironment(scene)
        self.setupSceneElements(scene)
        
        // add the main camera
        mainCamera.camera = SCNCamera()
        mainCamera.camera?.zFar = 500
        mainCamera.position = SCNVector3Make(0, 60, 50)
        mainCamera.rotation  = SCNVector4Make(1, 0, 0, Float(-M_PI_4*0.75))
        scene.rootNode.addChildNode(mainCamera)
        
        var camanim: CABasicAnimation = CABasicAnimation(keyPath: "rotation")
        camanim.toValue = NSValue(SCNVector4: SCNVector4(x: ball.position.x-10, y: ball.position.y, z: 0, w: Float(M_PI_4*0.75)))
        camanim.duration = 2
        camanim.repeatCount = 0
        mainCamera.addAnimation(camanim, forKey: nil)
    
        return scene
    }
    
    func setUpAccelerometer() {
        var weakSelf = self // TODO: this needs to be weak
//        var initialAttitude = motionManager.deviceMotion.attitude
        if ( GCController.controllers().count == 0 && motionManager.accelerometerAvailable == true ) {
            motionManager.accelerometerUpdateInterval = 1/60.0
            
            motionManager.startAccelerometerUpdatesToQueue( NSOperationQueue.mainQueue(), withHandler: {
                (accelerometerData, error) in
                    weakSelf.accelerometerDidChange(accelerometerData.acceleration)
                })
        }
        
//        motionManager.startDeviceMotionUpdatesToQueue( NSOperationQueue.mainQueue(), withHandler:  {
//            ( motion: CMDeviceMotion!, error: NSError! ) in
//                motion.attitude.multiplyByInverseOfAttitude(initialAttitude)
//        })
    }
    // TODO: change the syntax to addBlockToScene(scene: SCNScene, imageNamed image:NSString, atPosition position:SCNVector3)
    func addBlockToScene(scene: SCNScene, imageNamed: NSString, atPosition:SCNVector3) {
        var block = SCNNode()
        block.position = atPosition;
        block.geometry = SCNBox(width: 5, height: 5, length: 5, chamferRadius: 0)
        block.geometry?.firstMaterial?.diffuse.contents = imageNamed
        
        //turn on mipmapping
        block.geometry?.firstMaterial?.diffuse.mipFilter = SCNFilterMode.Linear
        
        //make it physically based
        block.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Dynamic, shape: SCNPhysicsShape(node:block, options: nil))
        
        //add to the scene
        scene.rootNode.addChildNode(block)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scnView = self.view as SCNView
        scnView.backgroundColor = UIColor.blackColor()
        
        let scene = self.setupScene()
        scnView.scene = scene
        
//        scnView.scene.physicsWorld.speed = 4.0
        
        self.setupBall(scene)
        
        self.setUpAccelerometer()

        scnView.pointOfView = mainCamera
        
        // game logic
        scnView.delegate = self
        
        super.viewDidLoad()
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        var gestureRecognizers: [UITapGestureRecognizer] = [tapGesture]
        gestureRecognizers.append(tapGesture)
//        gestureRecognizers += scnView.gestureRecognizers
        scnView.gestureRecognizers = gestureRecognizers
    }
    
    func accelerometerDidChange ( acceleration: CMAcceleration ) {
        let kFilteringFactor = 0.5
        //Use a basic low-pass filter to only keep the gravity in the accelerometer values
        accelerometer[0] = acceleration.x * kFilteringFactor + accelerometer[0] * (1.0 - kFilteringFactor)
        accelerometer[1] = acceleration.y * kFilteringFactor + accelerometer[1] * (1.0 - kFilteringFactor)
        accelerometer[2] = acceleration.z * kFilteringFactor + accelerometer[2] * (1.0 - kFilteringFactor)
    
        orientation = SCNVector3Make(Float(acceleration.x), Float(acceleration.y), Float(acceleration.z))
    }
    
    
// gesture recognizers
    
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        var scnView = self.view as SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.locationInView(scnView)
        let hitResults = scnView.hitTest(p, options: nil)
        
        // check that we clicked on at least one object
        if hitResults?.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject! = hitResults?[0]
            
            // get its material
            let material = result.node!.geometry?.firstMaterial
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(0.5)
            
            // on completion - unhighlight
            SCNTransaction.setCompletionBlock {
                SCNTransaction.begin()
                SCNTransaction.setAnimationDuration(0.5)
                
                material?.emission.contents = UIColor.blackColor()
                
                SCNTransaction.commit()
            }
            
            material?.emission.contents = UIColor.redColor()
            
            // if dynamic physics body => bounce it
            if result.node!.physicsBody?.type == SCNPhysicsBodyType.Dynamic {
                var node = result.node as SCNNode
                let physicsBody = node.physicsBody
                result.node!.physicsBody?.applyForce(SCNVector3Make(10, 5, -10), impulse: true)
            }
            
            SCNTransaction.commit()
        }
    }
    
// delegate methods
    func renderer(aRenderer: SCNSceneRenderer!, didSimulatePhysicsAtTime time: NSTimeInterval) {
        
        var controllers = GCController.controllers;
        
        //controller support
//        if (controllers && controllers.count() > 0) {
//            let controller = controllers[0];
////            let pad = [controller gamepad];
////            GCControllerDirectionPad *dpad = [pad dpad];
//            
//            static orientationCum: Float = 0;
//            
//            let INCR_ORIENTATION = 0.03
//            let DECR_ORIENTATION = 0.8
//            
////            if (dpad.right.pressed) {
////                if (orientationCum < 0) orientationCum *= DECR_ORIENTATION;
////                orientationCum += INCR_ORIENTATION;
////                if (orientationCum > 1) orientationCum = 1;
////            }
////            else if (dpad.left.pressed) {
////                if (orientationCum > 0) orientationCum *= DECR_ORIENTATION;
////                orientationCum -= INCR_ORIENTATION;
////                if (orientationCum < -1) orientationCum = -1;
////            }
////            else {
////                orientationCum *= DECR_ORIENTATION;
////            }
////            
////            orientation = orientationCum;
////            
////            if (pad.buttonX.pressed) {
////                engineForce = defaultEngineForce;
////                _reactor.birthRate = _reactorDefaultBirthRate;
////            }
////            else if (pad.buttonA.pressed) {
////                engineForce = -defaultEngineForce;
////                _reactor.birthRate = 0;
////            }
////            else if (pad.buttonB.pressed) {
////                brakingForce = 100;
////                _reactor.birthRate = 0;
////            }
////            else {
////                brakingForce = defaultBrakingForce;
////                _reactor.birthRate = 0;
////            }
//        }
        //        ball.physicsBody.velocity = SCNVector3Make(orientation.x*10, orientation.y*10, 0)
        ball.physicsBody?.velocity = SCNVector3Make(orientation.y*30, orientation.z*10, orientation.x*30)
        
//        let camanim: CABasicAnimation = CABasicAnimation(keyPath: "rotation")
//        camanim.toValue = NSValue(SCNVector4: SCNVector4(x: ball.position.x-10, y: ball.position.y, z: 0, w: Float(M_PI_4*0.75)))
//        camanim.duration = 25
//        camanim.repeatCount = 0
//        mainCamera.addAnimation(camanim, forKey: nil)
        
    }
    
// overrides
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
