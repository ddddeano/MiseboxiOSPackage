//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
extension MiseboxUserManager {
    public func checkMiseboxUserExistsInFirestore() async throws -> Bool {
        return try await firestoreManager.checkDocumentExists(collection: rootCollection, documentID: self.id)
    }
    public func setMiseboxUser() async throws  {
        try await firestoreManager.setDoc(collection: rootCollection, entity: self.miseboxUser)
    }
    
    public func documentListener(completion: @escaping (Result<Void, Error>) -> Void) {
        self.listener = firestoreManager.addDocumentListener(for: self.miseboxUser) { result in
            switch result {
            case .success(_):
                self.verify(id: self.id)
                completion(.success(()))
            case .failure(let error):
                print("Document listener failed with error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    public func collectionListener(completion: @escaping (Result<[MiseboxUser], Error>) -> Void) {
        self.listener = firestoreManager.addCollectionListener(collection: rootCollection, completion: completion)
    }
    
    public func update(id: String, data: [String: Any]) {
        firestoreManager.updateDocument(collection: rootCollection, documentID: id, updateData: data)
    }
    public func verify(id: String) {
        let data = ["verified" : true]
        update(id: id, data: data)
    }
}
