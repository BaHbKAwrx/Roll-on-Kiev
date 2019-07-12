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
            if let postImageURL = snapshotValue["pictureURL"] as? String {
                imageURL = postImageURL
            } else {
                imageURL = "https://firebasestorage.googleapis.com/v0/b/roll-on-kiev.appspot.com/o/newsImages%2FRollon_Onovo.jpg?alt=media&token=3035594b-cf50-426b-a782-d1871e6a2bf7"
            }
        } else {
            header = ""
            text = ""
            imageURL = "https://firebasestorage.googleapis.com/v0/b/roll-on-kiev.appspot.com/o/newsImages%2FRollon_Onovo.jpg?alt=media&token=3035594b-cf50-426b-a782-d1871e6a2bf7"
        }
    }
    
}
