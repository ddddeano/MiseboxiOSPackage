//
//  ChefManagerFunctions.swift
//
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import Firebase

extension ChefManager {
    
    public func checkDocumentExistsInFirestore(doc: ChefDocCollectionMarker) async throws -> Bool {
        return try await firestoreManager.checkDocumentExists(collection: doc.collection(), documentID: self.id)
    }
    
    public func setChefAndCreateProfile(miseboxUserManager: MiseboxUserManager) async throws {
        
        try await firestoreManager.setDoc(inCollection: ChefDocCollectionMarker.chef.collection(), entity: self.chef)
        
        self.chefProfile.gallery.append(GalleryImage(name: "default", imageUrl: imageUrl))
        
        self.chefProfile.id = self.id
        try await firestoreManager.setDoc(inCollection: ChefDocCollectionMarker.chefProfile.collection(), entity: self.chefProfile)
        
        let chefRole = MiseboxUserManager.UserRole(role: .chef, name: self.chef.generalInfo.name)
        
        let updateData = ["user_roles": FieldValue.arrayUnion([chefRole.toFirestore()])]
        firestoreManager.updateDocument(
            collection: MiseboxUserManager.MiseboxUserDocCollectionMarker.miseboxUser.collection(),
            documentID: self.id,
            updateData: updateData
        )
        
        
        try await addToFeed(postType: .chefCreated)
        
        print("Chef created with ID: \(self.chef.id)")
    }
    
    public func documentListener(for doc: ChefDocCollectionMarker, completion: @escaping (Result<Void, Error>) -> Void) {
        switch doc {
        case .chef:
            self.listener = firestoreManager.addDocumentListener(for: self.chef) { result in
                switch result {
                case .success(_):
                    self.chefExists = true
                case .failure(let error):
                    self.chefExists = false
                }
            }
            
        case .chefProfile:
            self.listener = firestoreManager.addDocumentListener(for: self.chefProfile) { result in
                switch result {
                case .success(_):
                    print("Listening to Chef Profile success")
                case .failure(let error):
                    print("Chef Profile document listener failed with error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    public func collectionListener(for collection: ChefDocCollectionMarker, completion: @escaping (Result<[Chef], Error>) -> Void) {
        switch collection {
        case .chef:
            self.listener = firestoreManager.addCollectionListener(collection: collection.collection(), completion: completion)
        case .chefProfile:
            self.listener = firestoreManager.addCollectionListener(collection: collection.collection(), completion: completion)
        }
    }
    
    
    public func addToFeed(postType: PostManager.ChefPostType) async throws {
        
        var title: String
        var image: String
        var body: String
        
        switch postType {
        case .chefCreated:
            title = "Welcome \(self.username)"
            body = "Enjoy the Misebox Ecosystem 👋 "
            image = self.imageUrl
        case .chefDeleted:
            title = "u Revoir Chef \(self.username)"
            body = "A \(self.username). 👋 Good Luck in the future."
            image = self.imageUrl
        case .empty:
            title = "Default Title"
            body = "Default Body"
            image = "Default Image"
        }
        
        let sender = PostManager.Sender(id: self.id, username: self.username, role: ChefDocCollectionMarker.chef.doc(), imageUrl: image)
        let subject = PostManager.PostSubject(subjectId: self.id, collectionName: ChefDocCollectionMarker.chef.collection())
        let content = PostManager.PostContent(title: title, body: body, imageUrl: image)
        
        let chefFeedEntry = PostManager.Chef(sender: sender, subject: subject, content: content, postType: postType)
        
        try await firestoreManager.createFeedEntry(entry: chefFeedEntry)
    }
    
}
 
