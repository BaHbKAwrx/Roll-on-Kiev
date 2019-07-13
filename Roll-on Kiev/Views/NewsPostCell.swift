//
//  NewsPostCell.swift
//  Roll-on Kiev
//
//  Created by Shmygovskii Ivan on 7/8/19.
//  Copyright © 2019 Shmygovskii Ivan. All rights reserved.
//

import UIKit

final class NewsPostCell: UITableViewCell {
    
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var postHeader: UILabel!
    @IBOutlet private weak var postText: UILabel!
    @IBOutlet private weak var postImage: UIImageView!
    
    static let cellIdentifier = "NewsCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.layer.cornerRadius = Constants.postCellCornerRadius
        cardView.clipsToBounds = true
        postImage.layer.cornerRadius = Constants.postCellCornerRadius
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImage.image = nil
        postImage.kf.cancelDownloadTask()
    }
    
    func configure(with newsPost: NewsPost) {
        postHeader.text = newsPost.header
        postText.text = newsPost.text
        
        // downloading image via Kingfisher
        if let imageURL = newsPost.imageURL {
            let url = URL(string: imageURL)
            postImage.kf.indicatorType = .activity
            postImage.kf.setImage(with: url, options: [.transition(.fade(Constants.loadedImageFadeDuration))])
        }
    }
}
