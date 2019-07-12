//
//  NewsViewController.swift
//  Roll-on Kiev
//
//  Created by Shmygovskii Ivan on 7/8/19.
//  Copyright © 2019 Shmygovskii Ivan. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class NewsViewController: UIViewController {
    
    @IBOutlet weak var newsTable: UITableView!
    
    var databaseRef: DatabaseReference!
    var news = [NewsPost]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference().child("posts")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // getting data from reference
        databaseRef.queryLimited(toFirst: 10).observe(.value) { [weak self] (snapshot) in
            self?.news = []
            for item in snapshot.children {
                if let item = item as? DataSnapshot {
                    let post = NewsPost(snapshot: item)
                    self?.news.append(post)
                }
            }
            // ???? Dispatch queeue main
            self?.newsTable.reloadData()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseRef.removeAllObservers()
    }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = newsTable.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsPostCell {
            let newsPost = news[indexPath.row]
            
            // !!! remove to cell class
            
            cell.postHeader.text = newsPost.header
            cell.postText.text = newsPost.text
            
            // downloading image via Kingfisher
            if let imageURL = newsPost.imageURL {
                let url = URL(string: imageURL)
                cell.postImage.kf.indicatorType = .activity
                cell.postImage.kf.setImage(with: url, options: [.transition(.fade(0.7))])
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
