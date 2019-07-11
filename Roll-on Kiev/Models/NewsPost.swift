//
//  NewsPost.swift
//  Roll-on Kiev
//
//  Created by Shmygovskii Ivan on 7/8/19.
//  Copyright © 2019 Shmygovskii Ivan. All rights reserved.
//

import Foundation
import Firebase

struct NewsPost {
    
    let header: String?
    let text: String?
    let imageURL: String?
    
    init(snapshot: DataSnapshot) {
        if let snapshotValue = snapshot.value as? [String: AnyObject] {
            header = snapshotValue["header"] as? String
            text = snapshotValue["text"] as? String
            imageURL = snapshotValue["pictureURL"] as? String
        } else {
            header = ""
            text = ""
            imageURL = "//default value"
        }
    }
    
}
