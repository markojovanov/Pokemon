//
//  ViewController.swift
//  Poke3
//
//  Created by Marko Jovanov on 27.8.21.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARImageTrackingConfiguration()
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards",
                                                               bundle: Bundle.main) {
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 2
        }
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        if let imageAnchor = anchor as? ARImageAnchor {
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                                 height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0,
                                                            alpha: 0.3)
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode(planeNode)
            if imageAnchor.referenceImage.name == "eevee" {
                pokemonNode(pokeName: "eevee", planeNode: planeNode)
            } else if imageAnchor.referenceImage.name == "oddish" {
                pokemonNode(pokeName: "oddish", planeNode: planeNode)
            }
        }
        return node
    }
    func pokemonNode(pokeName: String, planeNode: SCNNode)  {
        if let pokeScene = SCNScene(named: "art.scnassets/\(pokeName).scn") {
            if let pokeNode = pokeScene.rootNode.childNodes.first {
                pokeNode.eulerAngles.x = .pi / 2
                planeNode.addChildNode(pokeNode)
            }
        }
    }
}
