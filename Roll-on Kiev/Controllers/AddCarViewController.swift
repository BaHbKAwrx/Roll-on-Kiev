//
//  AddCarViewController.swift
//  Roll-on Kiev
//
//  Created by Shmygovskii Ivan on 10/6/19.
//  Copyright © 2019 Shmygovskii Ivan. All rights reserved.
//

import UIKit

final class AddCarViewController: UITableViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var carPhotoImageView: UIImageView!
    @IBOutlet private weak var yearTextField: UITextField!
    @IBOutlet private weak var horsePowerTextField: UITextField!
    @IBOutlet private weak var descriptionTextView: UITextView!
    
    private var takenCarImage: UIImage?
    
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
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // checking for all fields entered
        guard !yearTextField.text!.isEmpty, !horsePowerTextField.text!.isEmpty, !descriptionTextView.text.isEmpty, let carImage = takenCarImage else {
            showAlert(title: "Ошибка", message: "Заполните все данные об автомобиле.")
            return
        }
        // adding to the Firebase
        let newCar = Car(image: carImage, year: yearTextField.text!, power: horsePowerTextField.text!, aboutCar: descriptionTextView.text)
        newCar.saveInFirebase() // maybe add completion here ???
        
        performSegue(withIdentifier: Constants.toCarsListSegueName, sender: nil)
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
        takenCarImage = photo
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
