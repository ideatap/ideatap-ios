//
//  ViewController.swift
//  Ideatap
//
//  Created by Viktor Gardart on 02/06/15.
//  Copyright (c) 2015 Ideatap. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if(!LoginHelper.isLoggedIn) {
            let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("loginView") as! loginViewController
            self.presentViewController(loginVC, animated: false, completion: nil)
            return
        }
        let fb: Firebase = Firebase(url: "https://idea-tap.firebaseio.com")
        if let displayName = fb.authData.providerData["displayName"] as? String {
            usernameLabel.text = "\(displayName) via:\(fb.authData.provider as String)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signOut(sender: AnyObject) {
        LoginHelper.signOut()
        let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("loginView") as! loginViewController
        self.presentViewController(loginVC, animated: false, completion: nil)
    }

}

