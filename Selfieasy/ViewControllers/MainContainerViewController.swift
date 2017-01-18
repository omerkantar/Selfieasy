//
//  MainContainerViewController.swift
//  Selfieasy
//
//  Created by omer on 18.01.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit

class MainContainerViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    
    
    var cameraVC: CameraViewController?
    
    var containerViewTapGR: UITapGestureRecognizer?
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        cameraVC = CameraViewController()
        containerView.addSubview((cameraVC?.view)!)
    
        
        containerViewTapGR = UITapGestureRecognizer(target: self, action: #selector(tappedContainerView))
     
        containerView.addGestureRecognizer(containerViewTapGR!)
        
        
        infoLabel.text = "Saved Photo to Albums"
    }
    
    
    
    // MARK: - Action
    func tappedContainerView() {
        containerView.isUserInteractionEnabled = false
        
        
        cameraVC?.cameraView?.takePhoto(completion: { (img) in
            
            
        })
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.containerView.alpha = 0.0
            
        }) { (fns) in
            
            UIView.animate(withDuration: 0.2, animations: { 
                
                self.containerView.alpha = 1.0
                
            }, completion: { (fns2) in
                
                self.containerView.isUserInteractionEnabled = true

            })
        }
        
        
    }
    
  

    

    
    
}
