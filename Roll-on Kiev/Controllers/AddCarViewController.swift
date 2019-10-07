//
//  AddCarViewController.swift
//  Roll-on Kiev
//
//  Created by Shmygovskii Ivan on 10/6/19.
//  Copyright © 2019 Shmygovskii Ivan. All rights reserved.
//

import UIKit

class AddCarViewController: UITableViewController {
    
    // MARK: - Properties
    @IBOutlet weak var carPhotoImageView: UIImageView!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var horsePowerTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.layer.cornerRadius = Constants.descriptionTextViewCornerRadius
        carPhotoImageView.layer.cornerRadius = Constants.carPhotoImageViewCornerRadius
        carPhotoImageView.layer.masksToBounds = true
        
        let carPhotoGesture = UITapGestureRecognizer(target: self, action: #selector(openPhotoLibrary))
        carPhotoImageView.addGestureRecognizer(carPhotoGesture)
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tableView.addGestureRecognizer(hideKeyboardGesture)
    }
    
    // MARK: - Methods
    @objc private func openPhotoLibrary() {
        choosePhotoFromLibrary()
    }
    
    @objc private func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Actions
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "returnToCarsList", sender: nil)
        // checking for all fields entered
        // adding to the Firebase
    }

}

// MARK: - ImagePickerControllerDelegate methods
extension AddCarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        carPhotoImageView.image = photo
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
