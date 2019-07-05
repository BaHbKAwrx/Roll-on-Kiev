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
    
    @IBOutlet var buttonsArray: [UIButton]!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var authView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var authViewBottomConstraint: NSLayoutConstraint!
    
    lazy var wheelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "wheel")
        imageView.frame.size.height = 100
        imageView.frame.size.width = 100
        imageView.contentMode = .scaleAspectFit
        imageView.center.x = view.bounds.midX
        imageView.center.y = view.bounds.midY
        return imageView
    }()
    
    var stateChangeHandler: AuthStateDidChangeListenerHandle?
    var databaseRef: DatabaseReference?
    let segueIdentifier = "menuSegue"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authView.alpha = 0
        
        view.addSubview(wheelImageView)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        registerForKeyboardNotifications()
        
        setButtonsLook()
        
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
        startWheelAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let handler = stateChangeHandler else { return }
        Auth.auth().removeStateDidChangeListener(handler)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - Keyboard Notification selectors
    @objc private func kbDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else {
            return
        }
        
        authViewBottomConstraint.constant = keyboardHeight - authView.frame.height / 2
        UIView.animate(withDuration: 0.6) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func kbDidHide() {
        authViewBottomConstraint.constant = 100
        UIView.animate(withDuration: 0.6) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Private methods
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    private func startWheelAnimation() {
        
        var wheelAnimations = [CABasicAnimation]()
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = -3 * Double.pi
        rotateAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        wheelAnimations.append(rotateAnimation)
        
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 1
        fadeAnimation.toValue = 0
        wheelAnimations.append(fadeAnimation)
        
        let wheelAnimationGroup = CAAnimationGroup()
        wheelAnimationGroup.delegate = self
        wheelAnimationGroup.duration = 1.2
        wheelAnimationGroup.animations = wheelAnimations
        wheelImageView.layer.add(wheelAnimationGroup, forKey: nil)
        
    }
    
    private func setButtonsLook() {
        for button in buttonsArray {
            button.layer.borderWidth = 2
            button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            button.layer.cornerRadius = 8
        }
    }
    
    private func showAlertWithMessage(_ text: String) {
        let alert = UIAlertController(title: "Ошибка входа!", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func toggleActivityIndicator(on: Bool) {
        authView.isHidden = on
        
        if on {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Button actions
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            showAlertWithMessage("Заполните данные")
            return
        }
        
        toggleActivityIndicator(on: true)
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            guard let self = self else { return }
            
            self.toggleActivityIndicator(on: false)
            
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
        
        toggleActivityIndicator(on: true)
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            guard let self = self else { return }
            
            self.toggleActivityIndicator(on: false)
            
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
        toggleActivityIndicator(on: true)
        
        Auth.auth().signInAnonymously { [weak self] (_, error) in
            guard let self = self else { return }
            
            self.toggleActivityIndicator(on: false)
            
            if let error = error {
                self.showAlertWithMessage(error.localizedDescription)
                return
            }
            
            self.performSegue(withIdentifier: self.segueIdentifier, sender: nil)
        }
    }
    
}

// MARK: - TextField Delegate Methods

extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - Animation Delegate Methods
extension AuthViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        wheelImageView.removeFromSuperview()
        UIView.animate(withDuration: 0.5, animations: {
            self.authView.alpha = 1
        }) { (_) in
            self.emailTextField.becomeFirstResponder()
        }
    }
}
