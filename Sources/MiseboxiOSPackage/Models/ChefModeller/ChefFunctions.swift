//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
extension ChefManager {
    public func checkChefExistsInFirestore() async throws -> Bool {
        return try await firestoreManager.checkDocumentExists(collection: rootCollection, documentID: self.id)
    }
    

    public func setChef(miseboxUser: MiseboxUserManager.MiseboxUser) async throws {
        // Setting the chef's user details
        self.chef.id = miseboxUser.id
        self.chef.miseboxUser = ChefManager.MiseboxUser(fromMiseboxUser: miseboxUser)
        self.chef.imageUrl = miseboxUser.imageUrl
        self.chef.username = miseboxUser.username
                
        try await firestoreManager.setDoc(collection: rootCollection, entity: self.chef)
        
        let newChefProfile = ChefProfileManager.ChefProfile(chef: self.chef)
        try await firestoreManager.setDoc(collection: "chef-profiles", entity: newChefProfile)
        print("[ChefManager] creating chef profile with \(newChefProfile)")
        // Adding role to MiseboxUser
        let role =  MiseboxUserManager.Role(role: "chef", username: username)
        
        await firestoreManager.updateDocumentDependant(
            collection: "misebox-users",
            documentID: miseboxUser.id,
            field: "roles",
            value: role.toFirestore(),
            operation: .arrayUnion
        )
        
        try await addToFeed(postType: .chefCreated)
        
        print("Chef created with ID: \(self.chef.id)")
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
        
        let sender = PostManager.Sender(id: self.id, username: self.username, role: "Chef", imageUrl: image)
        let subject = PostManager.PostSubject(subjectId: self.id, collectionName: rootCollection)
        let content = PostManager.PostContent(title: title, body: body, imageUrl: image)
        
        let chefFeedEntry = PostManager.Chef(sender: sender, subject: subject, content: content, postType: postType)
        
        try await firestoreManager.createFeedEntry(entry: chefFeedEntry)
    }
    
    
    public func documentListener() {
        self.listener = firestoreManager.addDocumentListener(for: self.chef) { result in
            switch result {
            case .success(_):
                print("Listening to Chef \(self.username) success")
            case .failure(let error):
                print("Document listener failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    public func collectionListener(completion: @escaping (Result<[Chef], Error>) -> Void) {
        self.listener = firestoreManager.addCollectionListener(collection: rootCollection, completion: completion)
    }
    
    public func update(data: [String: Any]) async throws  {
        firestoreManager.updateDocument(collection: rootCollection, documentID: id, updateData: data)
    }
    
    public func deleteChef() async throws {
        try await firestoreManager.deleteDocument(collection: rootCollection, documentID: self.id)
        try await firestoreManager.deleteDocument(collection: "chef-profiles", documentID: self.id)
        await firestoreManager.updateDocumentDependant(
            collection: "misebox-users",
            documentID: self.id,
            field: "roles",
            value: "chef",
            operation: .arrayRemove)
        try await addToFeed(postType: .chefDeleted)
    }
}
