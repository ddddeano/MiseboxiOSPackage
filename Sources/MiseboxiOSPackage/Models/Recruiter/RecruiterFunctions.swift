//
//  File.swift
//  
//
//  Created by Daniel Watson on 23.01.24.
//

import Foundation
import FirebaseFirestore

extension RecruiterManager {
    public func checkRecruiterExistsInFirestore() async throws -> Bool {
        return try await firestoreManager.checkDocumentExists(collection: rootCollection, documentID: self.id)
    }
    
    public func setRecruiter(miseboxUser: MiseboxUserManager.MiseboxUser) async throws {
        self.recruiter.id = miseboxUser.id
        self.recruiter.miseboxUser = RecruiterManager.MiseboxUser(fromMiseboxUser: miseboxUser)
        self.recruiter.imageUrl = miseboxUser.imageUrl
        self.recruiter.username = miseboxUser.username
        
        try await firestoreManager.setDoc(collection: rootCollection, entity: self.recruiter)
        
        let newRecruiterProfile = RecruiterProfileManager.RecruiterProfile(recruiter: self.recruiter)
        
    }
    
    public func update(data: [String: Any]) async throws {
        firestoreManager.updateDocument(collection: rootCollection, documentID: id, updateData: data)
    }
    
    public func collectionListener(completion: @escaping (Result<[Recruiter], Error>) -> Void) {
        self.listener = firestoreManager.addCollectionListener(collection: rootCollection, completion: completion)
    }
    
    public func documentListener() {
        self.listener = firestoreManager.addDocumentListener(for: self.recruiter) { result in
            switch result {
            case .success(_):
                print("Listening to Recruiter \(self.username) success")
            case .failure(let error):
                print("Document listener failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    public func deleteRecruiter() async throws {
        try await firestoreManager.deleteDocument(collection: rootCollection, documentID: self.id)
        try await firestoreManager.deleteDocument(collection: "recruiter-profiles", documentID: self.id)
        await firestoreManager.updateDocumentDependant(
              collection: "misebox-users",
              documentID: self.id,
              field: "roles",
              value: "recruiter",
              operation: .arrayRemove
          )

        try await addToFeed(postType: .recruiterDeleted)
    }

    public func addToFeed(postType: PostManager.RecruiterPostType) async throws {
        var title: String
        var image: String
        var body: String
        
        switch postType {
        case .recruiterCreated:
            title = "Welcome \(self.username)"
            body = "Join the Misebox network and find great opportunities! 👋 "
            image = imageUrl
        case .recruiterDeleted:
            title = "Farewell \(self.username)"
            body = "Goodbye, \(self.username). 👋 We appreciate your contributions."
            image = self.imageUrl
        case .empty:
                title = "Default Title"
                body = "Default Body"
                image = "Default Image"
            }
        
        let sender = PostManager.Sender(id: self.id, username: self.username, role: "Recruiter", imageUrl: image)
        let subject = PostManager.PostSubject(subjectId: self.id, collectionName: rootCollection)
        let content = PostManager.PostContent(title: title, body: body, imageUrl: image)
        
        let recruiterFeedEntry = PostManager.Recruiter(sender: sender, subject: subject, content: content, postType: postType)
        
        try await firestoreManager.createFeedEntry(entry: recruiterFeedEntry)
    }
}
