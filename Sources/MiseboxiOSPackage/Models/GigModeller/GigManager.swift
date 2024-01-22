//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import FirebaseFirestore

class GigsManager {
    
    public let gigUrl = "https://unsplash.com/photos/a-group-of-people-standing-in-front-of-a-restaurant-k21a9naJr04"
    
    let firestoreManager = FirestoreManager ()
    var postManager = PostManager()
    var rootCollection = "chefs"
    var listener: ListenerRegistration?
    
    @Published public var gig: Gig
    
    public init(gig: Gig) {
        self.gig = gig
    }
    
    public var id: String {
        return gig.id
    }
    public var title: String {
        return gig.title
    }
    
    public func addSlowGig(gig: Gig) async throws {
        try await firestoreManager.setDoc(collection: rootCollection, entity: self.gig)
        try await addToFeed(postType: .slowGig)
    }
    
    public func addToFeed(postType: PostManager.GigPostType) async throws {
        // Create a Sender object
        let sender = PostManager.Sender(id: self.id, name: "userName", role: "User") // Adjust the name and role as needed

        // Assuming you have a way to create subject and content for Gigs similar to Chefs
        let subject = PostManager.PostSubject(subjectId: self.id, collectionName: "Your_Collection_Name") // Replace with actual collection name
        let content = PostManager.PostContent(title: "Title", body: "Content", imageUrl: self.gigUrl) // Replace "Title" and "Content" as needed

        // Create a Gig feed entry
        let gigFeedEntry = PostManager.Gig(sender: sender, subject: subject, content: content, postType: postType)

        // Add to Firestore
        try await firestoreManager.createFeedEntry(entry: gigFeedEntry)
    }

    public func deleteGig(gigId: String) async throws {
        try await firestoreManager.deleteDocument(collection: "gigs", documentID: gigId)
        //try await addToFeed(postType: .gigDeleted) // Assuming you have a method to add to the feed
    }
    
    public func update(data: [String: Any]) async throws  {
        firestoreManager.updateDocument(collection: rootCollection, documentID: id, updateData: data)
    }
    
}

