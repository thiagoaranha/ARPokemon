//
//  ViewController.swift
//  ARPokemon
//
//  Created by Thiago on 16/03/2019.
//  Copyright © 2019 Thiago. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/Pokemon.dae")!
        
        // Set the scene to the view
//        sceneView.scene = scene
        
    }
    
    private func createBulba(planeNode: SCNNode, vector: SCNVector3){
        
        let scene = SCNScene(named: "art.scnassets/Pokemon.dae")!
        
        if let node = scene.rootNode.childNode(withName: "Render", recursively: true){
            node.position = vector //SCNVector3(0, 0, -3)
            node.runAction(SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi), z: 0, duration: 0))
            
//            let action = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi * 2), z: 0, duration: 7)
//
//            let forever = SCNAction.repeatForever(action)
            
            sceneView.scene.rootNode.addChildNode(node)
            
            nodes.append((planeNode, node))
        }
        
        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/Pokemon.dae")!
//
//        scene.rootNode.position = vector //SCNVector3(0, 0, -8)
//        scene.rootNode.runAction(SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi), z: 0, duration: 0))
//
//        sceneView.scene.rootNode.addChildNode(scene.rootNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let anchor = anchor as? ARPlaneAnchor{
            createPlane(node: node, anchor: anchor)
            createBulba(planeNode: node, vector: SCNVector3(anchor.transform.columns.3.x, anchor.transform.columns.3.y + 0.01, anchor.transform.columns.3.z))
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let anchor = anchor as? ARPlaneAnchor {
            print("called")
        }
    }
    
    var nodes = [(SCNNode, SCNNode)]()
    
    private func createPlane(node: SCNNode, anchor: ARPlaneAnchor){
        
        let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        let planeNode = SCNNode()
        
        planeNode.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.clear
        
        plane.materials = [material]
        planeNode.geometry = plane
        
        node.addChildNode(planeNode)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
              let touchLocation = touch.location(in: sceneView)
//
//            let results = sceneView.hitTest(touchLocation, types: ARHitTestResult.ResultType.existingPlaneUsingExtent)
//
//            if let hitResult = results.first {
//
//                let vector = SCNVector3(
//                    hitResult.worldTransform.columns.3.x,
//                    hitResult.worldTransform.columns.3.y ,
//                    hitResult.worldTransform.columns.3.z
//                )
//
//                //createBulba(vector: vector)
//
//            }
            
            let resultPk = sceneView.hitTest(touchLocation, options: nil)

            if let node = resultPk.first?.node {
                //node.runAction(SCNAction.fadeOut(duration: 1))

                nodes.removeAll { (tuple) -> Bool in
                    if node == tuple.1 {
                        
                        tuple.0.removeFromParentNode()
                        tuple.1.removeFromParentNode()
                        
                        return true
                    }
                    
                    return false
                }
                
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
