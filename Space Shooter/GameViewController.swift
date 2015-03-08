//
//  GameViewController.swift
//  Space Shooter
//
//  Created by rukesh on 3/4/15.
//  Copyright (c) 2015 Rukesh. All rights reserved.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let mySpriteKitView = self.view as SKView
        mySpriteKitView.showsFPS = true
        mySpriteKitView.showsNodeCount = true
        let scene = GameScene(size: mySpriteKitView.bounds.size)
        scene.scaleMode = .AspectFit
        mySpriteKitView.presentScene(scene)
    }

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

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
