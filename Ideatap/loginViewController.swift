//
//  loginViewController.swift
//  Ideatap
//
//  Created by Viktor Gardart on 05/06/15.
//  Copyright (c) 2015 Ideatap. All rights reserved.
//

import UIKit

class loginViewController: UIViewController, GPPSignInDelegate {
    
    var loginHelper: LoginHelper?
    
    @IBOutlet weak var googleBtn: LoginButton!
    @IBOutlet weak var twitterBtn: LoginButton!
    @IBOutlet weak var facebookBtn: LoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginHelper = LoginHelper()
        loginHelper!.delegate = self
        
        googleBtn.setFontIcon(String.fontAwesomeIconWithName(.GooglePlus))
        twitterBtn.setFontIcon(String.fontAwesomeIconWithName(.Twitter))
        facebookBtn.setFontIcon(String.fontAwesomeIconWithName(.Facebook))
        
        var bgImage: UIImageView = UIImageView(image: UIImage(named: "login-bg")!)
        bgImage.frame = CGRectMake(0, 0, view.frame.width, view.frame.height)
        bgImage.contentMode = .ScaleAspectFill
        view.addSubview(bgImage)
        view.sendSubviewToBack(bgImage)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        googleBtn.center.x   -= view.bounds.width
        twitterBtn.center.x  -= view.bounds.width
        facebookBtn.center.x -= view.bounds.width
        
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.8, options: nil, animations: {
                self.googleBtn.center.x += self.view.bounds.width
        }, completion: nil)
        UIView.animateWithDuration(0.7, delay: 0.2, usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.8, options: nil, animations: {
                self.twitterBtn.center.x += self.view.bounds.width
        }, completion: nil)
        UIView.animateWithDuration(0.7, delay: 0.4, usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.8, options: nil, animations: {
                self.facebookBtn.center.x += self.view.bounds.width
        }, completion: nil)
        
        loadCloud()
        
        NSTimer.scheduledTimerWithTimeInterval(45.0, target: self, selector: Selector("loadCloud"), userInfo: nil, repeats: true)
    }
    
    func loadCloud() {
        var cloudView = UIView(frame: CGRectMake(0, 0, view.bounds.width, view.bounds.height))

        var imageArray: [UIImage] = [ UIImage(named: "cloud-1.png")!, UIImage(named: "cloud-2.png")!]
        var image = imageArray[random() % 1]
        var cloud: CALayer = CALayer()
        cloud.contents = image.CGImage
        cloud.bounds = CGRectMake(0, 0, image.size.width, image.size.height)
        cloud.position = CGPointMake(view.bounds.size.width / 2, image.size.height / 2)
        cloudView.layer.addSublayer(cloud)
        view.insertSubview(cloudView, atIndex: 1)
        
        var startPt: CGPoint = CGPointMake(view.bounds.size.width + (1 + CGFloat(random()) % view.bounds.size.width), cloud.position.y)
        var endPt: CGPoint = CGPointMake(cloud.bounds.size.width / -2, cloud.position.y);
        
        var anim: CABasicAnimation = CABasicAnimation(keyPath: "position")
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        anim.fromValue = NSValue(CGPoint: startPt)
        anim.toValue = NSValue(CGPoint: endPt)
        anim.repeatCount = Float.infinity
        anim.duration = 90.0
        
        var fadeIn: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        fadeIn.fromValue = NSNumber(int: 0)
        fadeIn.toValue = NSNumber(int: 1)
        fadeIn.duration = 0.4
        
        cloud.addAnimation(fadeIn, forKey: "opacity")
        cloud.addAnimation(anim, forKey: "position")
    }
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        if loginHelper != nil {
            loginHelper!.register("google", authData: auth)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginBtn(sender: AnyObject) {
        if let provider = sender.restorationIdentifier! {
            if loginHelper != nil {
                view.userInteractionEnabled = false
                loginHelper!.login(provider, closure: {
                    self.view.userInteractionEnabled = true
                    self.dismissViewControllerAnimated(false, completion: nil)
                })
            }
        }
    }
}
