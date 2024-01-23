//
//  File.swift
//  
//
//  Created by Daniel Watson on 23.01.24.
//

import Foundation
import FirebaseFirestore

extension RecruiterManager {
    
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
                print("Listening to Recruiter \(self.name) success")
            case .failure(let error):
                print("Document listener failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    public func checkRecruiterExistsInFirestore() async throws -> Bool {
        return try await firestoreManager.checkDocumentExists(collection: rootCollection, documentID: self.id)
    }
    public func deleteRecruiter() async throws {
        // Delete recruiter document
        try await firestoreManager.deleteDocument(collection: rootCollection, documentID: self.id)
        
        // Delete from recruiter-profiles
        try await firestoreManager.deleteDocument(collection: "recruiter-profiles", documentID: self.id)
        
        // Remove role from misebox user
        await firestoreManager.updateDocumentDependant(
              collection: "misebox-users",
              documentID: self.id,
              field: "roles",
              value: "recruiter", // Adjust the role as needed
              operation: .arrayRemove
          )
        
        // Add logic to handle additional cleanup if needed for recruiters
        
        // Add to feed
        try await addToFeed(postType: .recruiterDeleted)
    }

    public func addToFeed(postType: PostManager.RecruiterPostType) async throws {
        var title: String
        var image: String
        var body: String
        
        switch postType {
        case .recruiterCreated:
            title = "Welcome \(self.name)"
            body = "Join the Misebox network and find great opportunities! 👋 "
            image = imageUrl
        case .recruiterDeleted:
            title = "Farewell \(self.name)"
            body = "Goodbye, \(self.name). 👋 We appreciate your contributions."
            image = self.imageUrl
        case .empty: // Handle the empty case
                title = "Default Title"
                body = "Default Body"
                image = "Default Image"
            }
        
        let sender = PostManager.Sender(id: self.id, name: self.name, role: "Recruiter", imageUrl: image)
        let subject = PostManager.PostSubject(subjectId: self.id, collectionName: rootCollection)
        let content = PostManager.PostContent(title: title, body: body, imageUrl: image)
        
        let recruiterFeedEntry = PostManager.Recruiter(sender: sender, subject: subject, content: content, postType: postType)
        
        try await firestoreManager.createFeedEntry(entry: recruiterFeedEntry)
    }
}
