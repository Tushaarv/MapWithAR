//
//  ARViewController.swift
//  MapsWithAR
//
//  Created by Tushar Vengurlekar on 06/01/18.
//  Copyright © 2018 Tushar's. All rights reserved.
//

import UIKit
import ARKit

class ARViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    var selectedAR:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBox()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func addBox() {
        let box = SCNBox(width: CGFloat(0.1 * selectedAR!), height: CGFloat(0.1 * selectedAR!), length: 0.1, chamferRadius: 0)
        
        let boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.position = SCNVector3(0, 0, -0.2)
        
        let scene = SCNScene()
        scene.rootNode.addChildNode(boxNode)
        sceneView.scene = scene
    }
}
