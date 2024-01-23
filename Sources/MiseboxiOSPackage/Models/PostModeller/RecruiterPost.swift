//
//  File.swift
//  
//
//  Created by Daniel Watson on 23.01.24.
//

import Foundation
import FirebaseFirestore

extension PostManager {
    
    public struct Recruiter: Identifiable, Postable {
        
        public var id = ""
        public var sender: Sender
        public var subject: PostSubject
        public var content: PostContent
        public var timestamp: Date
        public var postType: PostManager.RecruiterPostType
        
        public init(sender: PostManager.Sender, subject: PostManager.PostSubject, content: PostManager.PostContent, postType: any PostType) {
            self.sender = sender
            self.subject = subject
            self.content = content
            if let recruiterPostType = postType as? PostManager.RecruiterPostType {
                self.postType = recruiterPostType
            } else {
                self.postType = .empty
            }
            self.timestamp = Date()
        }
        
        public init?(documentSnapshot: DocumentSnapshot) {
            guard let data = documentSnapshot.data() else { return nil }
            self.id = documentSnapshot.documentID
            self.sender = Sender(fromDictionary: data["sender"] as? [String: Any])
            self.subject = PostSubject(fromDictionary: data["subject"] as? [String: Any])
            self.content = PostContent(fromDictionary: data["content"] as? [String: Any])
            self.timestamp = data["timestamp"] as? Date ?? Date()
            self.postType = PostManager.RecruiterPostType(rawValue: data["post_type"] as? String ?? "") ?? .recruiterCreated
        }
        
        public func toFeedEntry() -> [String: Any] {
            [
                "id": id,
                "sender": sender.toFirestore(),
                "subject": subject.toFirestore(),
                "content": content.toFirestore(),
                "timestamp": timestamp,
                "post_type": postType.rawValue
            ]
            
        }
    }
}
