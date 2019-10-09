//
//  Car.swift
//  Roll-on Kiev
//
//  Created by Shmygovskii Ivan on 10/8/19.
//  Copyright © 2019 Shmygovskii Ivan. All rights reserved.
//

import UIKit
import Firebase

final class Car {
    
    var year: String?
    var power: String?
    var aboutCar: String?
    var imageURL: String?
    private var image: UIImage?
    
    init(image: UIImage, year: String, power: String, aboutCar: String) {
        self.image = image
        self.year = year
        self.power = power
        self.aboutCar = aboutCar
    }
    
    func saveInFirebase() {
        // getting references
        let newCarRef = Database.database().reference().child("cars").childByAutoId()
        if let newCarKey = newCarRef.key, let imageData = self.image?.jpegData(compressionQuality: 0.6) {
            let carImagesStorageRef = Storage.storage().reference().child("carsImages")
            let newCarImageRef = carImagesStorageRef.child(newCarKey)
            // saving image to storage
            newCarImageRef.putData(imageData).observe(.success) { (snapshot) in
                // saving car to database
                newCarImageRef.downloadURL(completion: { (url, error) in
                    self.imageURL = url?.absoluteString
                    let newCarDictionary = [
                        "year": self.year,
                        "power": self.power,
                        "aboutCar": self.aboutCar,
                        "imageURL": self.imageURL
                    ]
                    newCarRef.setValue(newCarDictionary)
                })
            }
        }
    }
    
}
