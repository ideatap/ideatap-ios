//
//  loginModel.swift
//  
//
//  Created by Viktor Gardart on 05/06/15.
//
//

class LoginHelper : NSObject {
    
    let fb: Firebase = Firebase(url: "https://idea-tap.firebaseio.com")
    let delegate: GPPSignInDelegate?
    
    static var isLoggedIn: Bool {
        let fb = Firebase(url: "https://idea-tap.firebaseio.com")
        if fb.authData != nil {
            return true
        }else {
            return false
        }
    }
    
    var closure = {() -> () in
        return
    }
    
    func authenticateWithGoogle() {
        var googlePlus = GPPSignIn.sharedInstance()
        googlePlus.shouldFetchGooglePlusUser = true
        googlePlus.clientID = "519366190805-r2hos4b0b303ke5dobqdor5cab03867l.apps.googleusercontent.com"
        googlePlus.scopes = ["email", "profile"]
        googlePlus.delegate = delegate
        googlePlus.authenticate()
    }
    
    func authenticateWithTwitter() {
        let twitterAuthHelper = TwitterAuthHelper(firebaseRef: fb, apiKey:"wMtuQIoT7PCA5RSSDmjw3nnBu")
        twitterAuthHelper.selectTwitterAccountWithCallback { error, accounts in
            if error != nil {
                println("error retriving twitter accs")
                // Error retrieving Twitter accounts
            } else if accounts.count >= 1 {
                // Select an account. Here we pick the first one for simplicity
                let account = accounts[0] as? ACAccount
                twitterAuthHelper.authenticateAccount(account, withCallback: {
                    error, authData in
                    
                    if error != nil {
                        // Error authenticating account
                    } else {
                        // User logged in!
                        self.register("twitter", authData: authData)
                    }
                })
            }
        }
    }
    
    func authenticateWithFacebook() {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logInWithReadPermissions(["email"], handler: {
            (result, error) -> Void in
            
            if error != nil {
                println("error")
            }else if result.isCancelled {
                println("user cancelled")
                self.closure()
            }else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                self.register("facebook", authData: accessToken)
            }
        })
        
    }
    
    func register(provider: String, authData: AnyObject) {
        if provider == "google" || provider == "facebook" {
            var accessToken: String = {
                if provider == "facebook" {
                    return authData as! String
                }else {
                    return authData.accessToken
                }
            }()
            fb.authWithOAuthProvider(provider, token: accessToken,
                withCompletionBlock: {
                    error, authData in
                    
                    if error == nil {
                        // All of this should be done better!!
                        var newUser = ["":""]
                        if provider == "facebook" {
                            newUser = [
                                "provider": authData.provider,
                                "email": authData.providerData["email"] as! String,
                                "name": authData.providerData["displayName"] as! String,
                                "provider_id": authData.providerData["id"] as! String,
                            ]
                        }else {
                            newUser = [
                                "provider": authData.provider,
                                "provider_id": authData.providerData["id"] as! String,
                                "email": authData.providerData["email"] as! String,
                                "username": authData.providerData["displayName"] as! String,
                                "first_name": authData.providerData["cachedUserProfile"]!["given_name"] as! String,
                                "last_name": authData.providerData["cachedUserProfile"]!["family_name"] as! String,
                                "locale": authData.providerData["cachedUserProfile"]!["locale"] as! String,
                                "image": authData.providerData["cachedUserProfile"]!["picture"] as! String,
                            ]
                        }
                        self.fb.childByAppendingPath("users")
                            .childByAppendingPath(authData.uid).setValue(newUser)
                        self.closure()
                    }else {
                        println(error)
                    }
            })
        }else if provider == "twitter" {
            var authData = authData as! FAuthData
            var newUser = [
                "provider": authData.provider,
                "name": authData.providerData["displayName"] as! String,
                "username": authData.providerData["username"] as! String,
                "provider_id": authData.providerData["id"] as! String
            ]
            
            self.fb.childByAppendingPath("users")
                .childByAppendingPath(authData.uid).setValue(newUser)
            self.closure()
        }
    }
    
    func login(provider: String, closure: () -> ()) {
        self.closure = closure
        
        switch provider {
        case "google":
            authenticateWithGoogle()
            break;
        case "facebook":
            authenticateWithFacebook()
            break;
        case "twitter":
            authenticateWithTwitter()
            break;
        default:
            break;
        }
    }
    
    static func signOut() {
        let fb = Firebase(url: "https://idea-tap.firebaseio.com")
        fb.unauth()
    }
    
    init(delegate: loginViewController) {
        self.delegate = delegate
        
        super.init()
    }
   
}
