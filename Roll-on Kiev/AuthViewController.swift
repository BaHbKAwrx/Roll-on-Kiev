//
//  AuthViewController.swift
//  Roll-on Kiev
//
//  Created by Shmygovskii Ivan on 6/30/19.
//  Copyright © 2019 Shmygovskii Ivan. All rights reserved.
//

import UIKit
import Firebase

class AuthViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var stateChangeHandler: AuthStateDidChangeListenerHandle?
    var databaseRef: DatabaseReference?
    let segueIdentifier = "menuSegue"

    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = Database.database().reference(withPath: "users")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Automatic entering for signed users
//        stateChangeHandler = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
//            if user != nil {
//                self?.performSegue(withIdentifier: (self?.segueIdentifier)!, sender: nil)
//            }
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let handler = stateChangeHandler else { return }
        Auth.auth().removeStateDidChangeListener(handler)
    }
    
    // MARK: - Button actions
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            guard let self = self else { return }
            
            if user != nil {
                self.performSegue(withIdentifier: self.segueIdentifier, sender: nil)
            }
        }
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            guard let self = self else { return }
            
            guard let user = user, error == nil else { return }
            let userRef = self.databaseRef?.child(user.user.uid)
            userRef?.setValue(["email": user.user.email])
        }
    }
    
    @IBAction func stayAnonymTapped(_ sender: UIButton) {
        Auth.auth().signInAnonymously { [weak self] (user, error) in
            guard let self = self, error == nil else { return }
            
            self.performSegue(withIdentifier: self.segueIdentifier, sender: nil)
        }
    }
    
}
