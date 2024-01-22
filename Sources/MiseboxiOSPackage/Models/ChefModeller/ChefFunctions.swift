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
        self.chef.imageUrl = "https://firebasestorage.googleapis.com:443/v0/b/misebox-78f9c.appspot.com/o/avatars%2FNewChef.jpg?alt=media&token=401c6a03-bc6f-4ecd-8d3b-e2ec96bc6aed"
        
        // TODO image = misebox.image
        
        // Saving chef details to Firestore
        try await firestoreManager.setDoc(collection: rootCollection, entity: self.chef)
        
        // Creating and saving chef profile
        let newChefProfile = ChefProfileManager.ChefProfile(chef: self.chef)
        try await firestoreManager.setDoc(collection: "chef-profiles", entity: newChefProfile)
        
        // Adding role to MiseboxUser
        let role =  MiseboxUserManager.Role(role: "chef", name: name)
        
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
            title = "Welcome \(self.name)"
            body = "Enjoy the Misebox Ecosystem 👋 "
            image = imageUrl
        case .chefDeleted:
            title = "u Revoir Chef \(self.name)"
            body = "A \(self.name). 👋 Good Luck in the future."
            image = self.imageUrl
        }
        
        let sender = PostManager.Sender(id: self.id, name: self.name, role: "Chef", imageUrl: image)
        let subject = PostManager.PostSubject(subjectId: self.id, collectionName: rootCollection)
        let content = PostManager.PostContent(title: title, body: body, imageUrl: image)
        
        let chefFeedEntry = PostManager.Chef(sender: sender, subject: subject, content: content, postType: postType)
        
        try await firestoreManager.createFeedEntry(entry: chefFeedEntry)
    }
    
    
    public func documentListener() {
        self.listener = firestoreManager.addDocumentListener(for: self.chef) { result in
            switch result {
            case .success(_):
                print("Listening to Chef \(self.name) success")
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
        // await miseboxUserManager.removeRole()
        // archive
        try await firestoreManager.deleteDocument(collection: rootCollection, documentID: self.id)
        try await addToFeed(postType: .chefDeleted)
    }
}
