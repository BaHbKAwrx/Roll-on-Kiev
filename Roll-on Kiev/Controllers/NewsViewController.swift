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

final class NewsViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var newsTable: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var databaseRef: DatabaseReference!
    private var news = [NewsPost]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference().child("posts")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
        
        // getting data from databaseReference
        getNewsPosts(count: Constants.postsLimit)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseRef.removeAllObservers()
    }
    
    // MARK: - Private methods
    private func getNewsPosts(count: UInt) {
        // checking for valid value
        guard count > 0 else { return }
        
        databaseRef.queryLimited(toFirst: count).observe(.value) { [weak self] (snapshot) in
            guard let self = self else { return }
            self.news = []
            for item in snapshot.children {
                if let item = item as? DataSnapshot {
                    let post = NewsPost(snapshot: item)
                    self.news.append(post)
                }
            }
            self.activityIndicator.stopAnimating()
            self.newsTable.reloadData()
        }
    }
}

// MARK: - TableView delegate and dataSource
extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = newsTable.dequeueReusableCell(withIdentifier: NewsPostCell.cellIdentifier, for: indexPath) as? NewsPostCell {
            let newsPost = news[indexPath.row]
            cell.configure(with: newsPost)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
