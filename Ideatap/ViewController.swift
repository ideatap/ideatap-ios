//
//  ViewController.swift
//  Ideatap
//
//  Created by Viktor Gardart on 02/06/15.
//  Copyright (c) 2015 Ideatap. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GPPSignInDelegate {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var username: UILabel!
    
    var fb = Firebase(url: "https://idea-tap.firebaseio.com")
    
    func authenticateWithGoogle() {
        var signIn = GPPSignIn.sharedInstance()
        signIn.shouldFetchGooglePlusUser = true
        signIn.clientID = "519366190805-r2hos4b0b303ke5dobqdor5cab03867l.apps.googleusercontent.com"
        signIn.scopes = ["email"]
        signIn.delegate = self
        signIn.authenticate()
    }
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        if error == nil {
            fb.authWithOAuthProvider("google", token: auth.accessToken,
                withCompletionBlock: { error, authData in
                    if error == nil {
                        // User is now logged in!
                        self.updateUI(true)
                        
                        let newUser = [
                            "provider": authData.provider,
                            "email": authData.providerData["email"] as! String //Should check if exists lol
                        ]
                        self.fb.childByAppendingPath("users")
                            .childByAppendingPath(authData.uid).setValue(newUser)
                    }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if fb.authData != nil {
            updateUI(true)
        }
        
    }
    
    @IBAction func logout(sender: AnyObject) {
        fb.unauth()
        updateUI(false)
    }
    @IBAction func login(sender: AnyObject) {
        authenticateWithGoogle()
    }
    
    func updateUI(isLoggedIn: Bool) {
        if isLoggedIn == true {
            loginBtn.hidden = true
            username.hidden = false
            logoutBtn.hidden = false
            if let fullname = fb.authData.providerData["displayName"] as? String {
                username.text = fullname
            }
        }else {
            loginBtn.hidden = false
            username.hidden = true
            logoutBtn.hidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

