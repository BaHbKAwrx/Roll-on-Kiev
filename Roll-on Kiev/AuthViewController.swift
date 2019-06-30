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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let handler = stateChangeHandler else { return }
        Auth.auth().removeStateDidChangeListener(handler)
    }
    
    // MARK: - Private methods
    
    private func showAlertWithMessage(_ text: String) {
        let alert = UIAlertController(title: "Ошибка входа!", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Button actions
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            showAlertWithMessage("Заполните данные")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlertWithMessage(error.localizedDescription)
                return
            }
            
            if let _ = user {
                self.performSegue(withIdentifier: self.segueIdentifier, sender: nil)
            }
        }
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            showAlertWithMessage("Заполните данные")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlertWithMessage(error.localizedDescription)
                return
            }
            
            guard let user = user else { return }
            let userRef = self.databaseRef?.child(user.user.uid)
            userRef?.setValue(["email": user.user.email])
        }
    }
    
    @IBAction func stayAnonymTapped(_ sender: UIButton) {
        Auth.auth().signInAnonymously { [weak self] (_, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlertWithMessage(error.localizedDescription)
                return
            }
            
            self.performSegue(withIdentifier: self.segueIdentifier, sender: nil)
        }
    }
    
}
