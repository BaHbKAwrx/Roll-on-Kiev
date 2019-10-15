//
//  Constants.swift
//  Roll-on Kiev
//
//  Created by Shmygovskii Ivan on 7/6/19.
//  Copyright © 2019 Shmygovskii Ivan. All rights reserved.
//

import UIKit

struct Constants {
    
    // authVC constants
    static let spinningImageName = "wheel"
    static let spinningImageHeight: CGFloat = 100
    static let spinAnimationDuration = 1.2
    static let numberOfSpins = 1.5
    
    static let toMenuSegueName = "menuSegue"
    
    static let textFieldAnimationDuration = 0.6
    static let authViewBottomConstraintConstant: CGFloat = 100
    static let authViewFadeAnimationDuration = 0.5
    
    static let buttonBorderWidth: CGFloat = 2
    static let buttonCornerRadius: CGFloat = 8
    static let buttonBorderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
    
    // newsVC constants
    static let defaultPostImageURL = "https://firebasestorage.googleapis.com/v0/b/roll-on-kiev.appspot.com/o/newsImages%2FRollon_Onovo.jpg?alt=media&token=3035594b-cf50-426b-a782-d1871e6a2bf7"
    static let postCellCornerRadius: CGFloat = 10
    static let loadedImageFadeDuration = 0.7
    static let postsLimit: UInt = 10
    
    // addCarVC constants
    static let descriptionTextViewCornerRadius: CGFloat = 8
    static let carPhotoImageViewCornerRadius: CGFloat = 12
    static let toCarsListSegueName = "returnToCarsList"
    
    // carsVC constants
    static let carCellCornerRadius: CGFloat = 8
    static let defaultCarPhotoURL = "https://firebasestorage.googleapis.com/v0/b/roll-on-kiev.appspot.com/o/carsImages%2Fplaceholder.jpg?alt=media&token=6a75430b-e143-4578-8b42-3b2f17679303"
}
