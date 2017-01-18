//
//  CameraViewController.swift
//  Selfieasy
//
//  Created by omer on 18.01.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {

    var cameraView: CameraView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cameraView = CameraView(frame: self.view.frame)
        view.addSubview(cameraView!)
    }
    

}
