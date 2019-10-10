//
//  CarsViewController.swift
//  Roll-on Kiev
//
//  Created by Shmygovskii Ivan on 7/8/19.
//  Copyright © 2019 Shmygovskii Ivan. All rights reserved.
//

import UIKit

final class CarsViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var carsCollection: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func unwindToCarsList(segue: UIStoryboardSegue) {
    }

}

// MARK: - CollectionView delegate, flowLayoutDelegate and dataSource
extension CarsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 13
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarCell.cellIdentifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: carsCollection.frame.width / 2, height: carsCollection.frame.width / 2)
    }
}
