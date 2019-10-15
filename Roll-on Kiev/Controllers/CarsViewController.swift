//
//  CarsViewController.swift
//  Roll-on Kiev
//
//  Created by Shmygovskii Ivan on 7/8/19.
//  Copyright © 2019 Shmygovskii Ivan. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

final class CarsViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var carsCollection: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var databaseRef: DatabaseReference!
    private var cars = [Car]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference().child("cars")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
        
        // getting data from databaseReference
        getCarsList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseRef.removeAllObservers()
    }
    
    @IBAction func unwindToCarsList(segue: UIStoryboardSegue) {
    }
    
    // MARK: - Private methods
    private func getCarsList() {
        databaseRef.observe(.value) { [weak self] (snapshot) in
            guard let self = self else { return }
            self.cars = []
            for item in snapshot.children {
                if let item = item as? DataSnapshot {
                    let car = Car(snapshot: item)
                    self.cars.append(car)
                }
            }
            self.activityIndicator.stopAnimating()
            self.carsCollection.reloadData()
        }
    }

}

// MARK: - CollectionView delegate, flowLayoutDelegate and dataSource
extension CarsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarCell.cellIdentifier, for: indexPath) as? CarCell {
            let car = cars[indexPath.item]
            cell.configure(with: car)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: carsCollection.frame.width / 2, height: carsCollection.frame.width / 2)
    }
}
