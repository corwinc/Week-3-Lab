//
//  CanvasViewController.swift
//  Week 3 Lab
//
//  Created by Corwin Crownover on 2/23/16.
//  Copyright © 2016 Corwin Crownover. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // OUTLETS
    @IBOutlet weak var trayView: UIView!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceInitialCenter: CGPoint!
    
    // VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trayDownOffset = 176
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x, y: trayView.center.y + trayDownOffset)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    // FUNCTIONS
    @IBAction func didPanTray(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == .Began {
            trayOriginalCenter = trayView.center
            
            
            
        } else if sender.state == .Changed{
            if trayView.center.y >= trayUp.y {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
                
            } else if trayView.center.y < trayUp.y {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayUp.y + translation.y * 0.1)
            }
            
        
            
        } else if sender.state == .Ended {
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                if velocity.y > 0 {
                    self.trayView.center = self.trayDown
                    self.arrowImageView.transform = CGAffineTransformMakeRotation(180 * CGFloat(M_PI) / 180)
                    
                } else if velocity.y < 0 {
                    self.trayView.center = self.trayUp
                    self.arrowImageView.transform = CGAffineTransformMakeRotation(0)
                }
                
                }, completion: nil)
        }
    }
    
    
    
    @IBAction func didPanFace(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let imageView = sender.view as! UIImageView


        if sender.state == .Began {
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newlyCreatedFaceInitialCenter = newlyCreatedFace.center
            
            newlyCreatedFace.userInteractionEnabled = true
            
            let panGesture = UIPanGestureRecognizer(target: self, action: "didPanNewlyCreatedFace:")
            newlyCreatedFace.addGestureRecognizer(panGesture)
            
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: "didPinchNewlyCreatedFace:")
            newlyCreatedFace.addGestureRecognizer(pinchGesture)
            pinchGesture.delegate = self
            
            let rotateGesture = UIRotationGestureRecognizer(target: self, action: "didRotateNewlyCreatedFace:")
            newlyCreatedFace.addGestureRecognizer(rotateGesture)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: "didDoubleTapNewlyCreatedFace:")
            newlyCreatedFace.addGestureRecognizer(tapGesture)
            tapGesture.numberOfTapsRequired = 2
            
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.newlyCreatedFace.transform = CGAffineTransformMakeScale(1.8, 1.8)
            })
            
        
        } else if sender.state == .Changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceInitialCenter.x + translation.x, y: newlyCreatedFaceInitialCenter.y + translation.y)
        
        } else if sender.state == .Ended {
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                self.newlyCreatedFace.transform = CGAffineTransformMakeScale(1.6, 1.6)
                }, completion: nil)
            
            if newlyCreatedFace.center.y >= 358 {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.newlyCreatedFace.center = self.newlyCreatedFaceInitialCenter
                    self.newlyCreatedFace.transform = CGAffineTransformMakeScale(1, 1)
                    self.newlyCreatedFace.removeFromSuperview()
                })
            }
            
        }
      

    }
    

    @IBAction func didPanNewlyCreatedFace(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        
        if sender.state == .Began {
            print("new face pan began")
            
            newlyCreatedFace = sender.view as! UIImageView
            newlyCreatedFaceInitialCenter = newlyCreatedFace.center
            newlyCreatedFace.transform = CGAffineTransformMakeScale(1.8, 1.8)
            
            
        } else if sender.state == .Changed {
            print("new face is panning")
            
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceInitialCenter.x + translation.x, y: newlyCreatedFaceInitialCenter.y + translation.y)
            
        } else if sender.state == .Ended {
            print("new face finished panning")
            newlyCreatedFace.transform = CGAffineTransformMakeScale(1.6, 1.6)

            if newlyCreatedFace.center.y >= 358  {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.newlyCreatedFace.center = self.newlyCreatedFaceInitialCenter
                })
            }
            
        }
        
    }
    
    
    @IBAction func didPinchNewlyCreatedFace(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        print("\(scale)")
        
        newlyCreatedFace = sender.view as! UIImageView
        newlyCreatedFace.transform = CGAffineTransformScale(newlyCreatedFace.transform, scale, scale)
        sender.scale = 1
    }
    
    
    @IBAction func didRotateNewlyCreatedFace(sender: UIRotationGestureRecognizer) {
        let rotation = sender.rotation
        
        newlyCreatedFace = sender.view as! UIImageView
        newlyCreatedFace.transform = CGAffineTransformRotate(newlyCreatedFace.transform, rotation)
        sender.rotation = 0
    }
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    @IBAction func didDoubleTapNewlyCreatedFace(sender: UITapGestureRecognizer) {
        newlyCreatedFace = sender.view as! UIImageView
        newlyCreatedFace.removeFromSuperview()
    }
    
    
    
    
    
    

}
