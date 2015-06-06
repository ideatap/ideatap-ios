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

    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginHelper = LoginHelper(delegate: self)
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
                loader.hidden = false
                view.userInteractionEnabled = false
                loginHelper!.login(provider, closure: {
                    self.loader.hidden = true
                    self.view.userInteractionEnabled = true
                    self.dismissViewControllerAnimated(false, completion: nil)
                })
            }
        }
    }
}
