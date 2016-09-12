//
//  ViewController.swift
//  Pokedex
//
//  Created by Patrick on 8/26/16.
//  Copyright © 2016 Little Lujan LLC. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil{
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
    }
    
    
    @IBAction func fbBtnPressed(sender: UIButton!){
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self, handler: { (facebookResult: FBSDKLoginManagerLoginResult!, facebookError:  NSError!) -> Void in
            if facebookError != nil{
                print("Facebook login failed. Error \(facebookError)")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Successfully logged into facebook \(accessToken)")
                
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                
                FIRAuth.auth()?.signInWithCredential(credential, completion: { (user, error) in
                    if error != nil {
                        print("login Failed")
                    } else {
                        print("Login Success! \(user)")
                        
                        let userData = ["provider": credential.provider]
                        DataService.ds.createFirebaseUser(user!.uid, user: userData)
                        
                        NSUserDefaults.standardUserDefaults().setValue(user!.uid, forKey: KEY_UID)
                        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                    }
                    
                })
                
                
            }
        })
    }
    
    @IBAction func attemptLogin(sender: UIButton){
        
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
            
            FIRAuth.auth()?.signInWithEmail(email, password: pwd, completion: { (user, error) in
                
                if error != nil {
                    print(error)
                    
                    if error!.code == STATUS_ACCOUNT_NONEXIST {
                        FIRAuth.auth()?.createUserWithEmail(email, password: pwd, completion: { (user, error) in
                            
                            if error != nil {
                                self.showErrorAlert("Could not create account", msg: "Problem creating account. Try something else. Password must be 6 characters minimum.")
                            } else {
                                NSUserDefaults.standardUserDefaults().setValue(user?.uid, forKey: KEY_UID)
                                
                                let userData = ["provider": "email"]
                                DataService.ds.createFirebaseUser(user!.uid, user: userData)
                                
                                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                                
                            }
                            
                        })
                    } else {
                        self.showErrorAlert("Could not log in", msg: "Please check username or password")
                    }
                    
                } else {
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
                
            })
            
        } else {
            showErrorAlert("Email and Password Required", msg: "You must enter an email and password")
        }
    }
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}
