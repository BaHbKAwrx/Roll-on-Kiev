//
//  CarCell.swift
//  Roll-on Kiev
//
//  Created by Shmygovskii Ivan on 10/10/19.
//  Copyright © 2019 Shmygovskii Ivan. All rights reserved.
//

import UIKit

final class CarCell: UICollectionViewCell {
    
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var carImage: UIImageView!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var powerLabel: UILabel!
    
    static let cellIdentifier = "CarItem"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.layer.cornerRadius = Constants.carCellCornerRadius
        cardView.clipsToBounds = true
    }
}
