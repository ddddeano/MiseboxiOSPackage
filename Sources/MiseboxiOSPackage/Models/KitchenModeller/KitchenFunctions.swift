//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
extension KitchenManager {
    
    public func createKitchen(kitchen: Kitchen) async throws -> String {
        let documentId = try await firestoreManager.createDoc(collection: rootCollection, entity: kitchen)
        return documentId
    }
    
    public func documentListener(kitchen: Kitchen) {
        self.listener = firestoreManager.addDocumentListener(for: kitchen) { result in
            switch result {
            case .success(_):
                self.verify(id: kitchen.id)
            case .failure(let error):
                print("Document listener failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    public func collectionListener(completion: @escaping (Result<[Kitchen], Error>) -> Void) {
        self.listener = firestoreManager.addCollectionListener(collection: rootCollection, completion: completion)
    }
    
    public func update(id: String, data: [String: Any]) {
        print("KitchenManager[update] Updating kitchen with ID: \(id)")
        firestoreManager.updateDocument(collection: rootCollection, documentID: id, updateData: data)
    }
    public func verify(id: String) {
        let data = ["verified" : true]
        update(id: id, data: data)
    }
}
