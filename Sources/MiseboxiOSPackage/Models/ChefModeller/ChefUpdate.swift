//
//  File.swift
//  
//
//  Created by Daniel Watson on 28.01.2024.
//

extension ChefManager {
    
    
    public func updateChef(fieldName: String, newValue: Any) async throws {
        let updateData = [fieldName: newValue]
        firestoreManager.updateDocument(collection: ChefDocCollection.chef.collection(), documentID: self.chef.id, updateData: updateData)
        try await updateDependants(fieldName: fieldName, newValue: newValue)
    }
    
    public func updateChefProfile(fieldName: String, newValue: Any) async throws {
        let updateData = [fieldName: newValue]
        firestoreManager.updateDocument(collection: ChefDocCollection.chefProfile.collection(), documentID: self.chefProfile.id, updateData: updateData)
  
    }
    
    private func updateDependants(fieldName: String, newValue: Any) async throws {
        switch fieldName {
        case "name": // Example field name
            if let newName = newValue as? String {
                try await updateDependantDocumentsForField("name", newValue: newName)
            }
        case "kitchens": // Example field name
            if let newKitchens = newValue as? [Kitchen] {
                try await updateDependantDocumentsForKitchens(newKitchens)
            }
        default:
            break
        }
    }
    
    private func updateDependantDocumentsForField(_ fieldName: String, newValue: Any) async throws {
        // Example: Updating dependent documents when chef name changes
        // Implement logic specific to Chef dependencies
        print("Updating dependent documents for \(fieldName)")
    }
    
    private func updateDependantDocumentsForKitchens(_ newKitchens: [Kitchen]) async throws {
        // Implement logic to update dependent documents when kitchens list changes
        print("Updating dependent documents for kitchens changes")
    }
}

    
    
    /*
    public func updateChef(data: [String: Any]) async throws {
        firestoreManager.updateDocument(collection: ChefDocCollection.chef.collection(), documentID: self.chef.id, updateData: data)
        
        for (key, value) in data {
        
        }
    }
    
    public func updateChefProfile(data: [String: Any]) async throws {
        firestoreManager.updateDocument(collection: ChefDocCollection.chefProfile.collection(), documentID: self.chef.id, updateData: data)
        
        for (key, value) in data {

        }
    }
    
    // Helper function to update dependent documents
    private func updateDependentDocuments(fieldName: String, newValue: Any, dependentCollection: ChefDependentCollections) async throws {
        let collectionName = dependentCollection.rawValue
        // Implement the logic to update dependent collections
        firestoreManager.updateDocumentDependant(
            collection: collectionName,
            documentID: self.chef.id,
            field: fieldName,
            value: newValue,
            operation: .arrayUnion // or .arrayRemove, .set, etc., depending on the operation needed
        )
    }
}

    
    
    public struct Update {
        var source: ChefDocCollection
        var field: ChefField
        var dependantsToUpdate: [ChefDependentCollections] {
            switch field {
            case .name:
                return []
            default:
                return []
            }
        }
        
        enum ChefField {
            case name(String)
            case generalInfo(GeneralInfo)
            case primaryKitchen(Kitchen)
            case kitchens([Kitchen])
            case nationality(Nationality)
            case aboutMeBio(AboutMeBio)
            case gallery([GalleryImage])
            case previousEmployment([PreviousEmployment])
            case qualifications([Qualification])
            case spokenLanguages([SpokenLanguage])
            
            var key: String {
                switch self {
                case .name: return "name"
                case .generalInfo: return "general_info"
                case .primaryKitchen: return "primary_kitchen"
                case .kitchens: return "kitchens"
                case .nationality: return "nationality"
                case .aboutMeBio: return "about_me_bio"
                case .gallery: return "gallery"
                case .previousEmployment: return "previous_employment"
                case .qualifications: return "qualifications"
                case .spokenLanguages: return "spoken_languages"
                }
            }
            
            var value: Any {
                switch self {
                case .name(let value):
                    return value
                case .generalInfo(let value):
                    return value.toFirestore()
                case .primaryKitchen(let value):
                    return value.toFirestore()
                case .kitchens(let value):
                    return value.map { $0.toFirestore() }
                case .nationality(let value):
                    return value.toFirestore()
                case .aboutMeBio(let value):
                    return value.toFirestore()
                case .gallery(let value):
                    return value.map { $0.toFirestore() }
                case .previousEmployment(let value):
                    return value.map { $0.toFirestore() }
                case .qualifications(let value):
                    return value.map { $0.toFirestore() }
                case .spokenLanguages(let value):
                    return value.map { $0.toFirestore() }
                }
            }
        }
        
        init(source: ChefDocCollection, field: ChefField) {
            self.field = field
        }
    }
    
    public func update(update: Update) async throws {
         // Preparing the data to update
         let updateData = [update.field.key: update.field.value]

         // Updating the main document (either chef or chef profile)
         firestoreManager.updateDocument(collection: update.source.collection(), documentID: self.chef.id, updateData: updateData)

         // Updating dependent collections if any
         for dependent in update.dependantsToUpdate {
             let collectionName = dependent.collection()
             // Implement the logic to update dependent collections.
             // For example, you might want to update a field inside an array of documents:
             try await firestoreManager.updateDocumentDependant(
                 collection: collectionName,
                 documentID: self.chef.id,
                 field: dependent.doc(),
                 value: update.field.value,
                 operation: .arrayUnion // or .arrayRemove, .set, etc., depending on the operation needed
             )
         }
     }
 }
}
    
    
    
        // Method to perform an update on Chef
        public func update(chefId: String, update: Update) async throws {
            // ... implementation ...
        }

        // Method for updating Misebox user role
        public func updateMiseboxUserRole(miseboxUserId: String) async {
            // ... implementation ...
        }

        // Methods for adding and removing kitchens from a chef
        public func addKitchenToChef(kitchen: Kitchen) async {
            // ... implementation ...
        }

        public func removeKitchenFromChef(kitchenId: String, chefId: String) async {
            // ... implementation ...
        }

        // Function to delete a chef
        public func deleteChef() async throws {
            // ... implementation ...
        }

        // Function to set a chef's primary kitchen
        public func setChefPrimaryKitchen(kitchen: Kitchen) async throws {
            // ... implementation ...
        }
    }

    
    public func update(chefId: String, update: Update) async throws {
        let updateData = [update.field.key: update.field.value]
        firestoreManager.updateDocument(collection: ChefCollections.chefs.rawValue, documentID: chefId, updateData: updateData)
        
        update.rolesToUpdate.forEach { roleCollection in
            let collection = roleCollection.toCollectionAndDocument().collection
            firestoreManager.updateDocument(collection: collection, documentID: chefId, updateData: ["miseboxUser.\(update.field.key)": update.field.value])
        }
    }

    // ... other update related methods ...
}

await firestoreManager.updateDocumentDependant(
    collection: "misebox-users",
    documentID: miseboxUserManager.id,
    field: "roles",
    value: toMiseboxUser,
    operation: .arrayUnion
)

public func update(data: [String: Any], for collection: ChefCollections) async throws  {
    switch collection {
    case .chefs:
        firestoreManager.updateDocument(collection: collection.rawValue, documentID: id, updateData: data)
    case .chefProfiles:
        firestoreManager.updateDocument(collection: collection.rawValue, documentID: id, updateData: data)
    }
}
public func deleteChef() async throws {
    try await firestoreManager.deleteDocument(collection: ChefCollections.chefs.rawValue, documentID: self.id)
    try await firestoreManager.deleteDocument(collection: ChefCollections.chefProfiles.rawValue, documentID: self.id)
    
    // Update dependent collections
    for collection in ChefDependentCollections.allCases {
        switch collection {
        case .miseboxUsers:
            await firestoreManager.updateDocumentDependant(
                collection: collection.rawValue,
                documentID: self.id,
                field: "roles",
                value: collection. ,
                operation: .arrayRemove
            )
        case .kitchens: break
            // Perform the necessary update for kitchens
            // Example: remove the chef from the kitchen's chef list
            // Adjust the logic based on how kitchens are related to chefs in your database
        }
    }

    try await addToFeed(postType: .chefDeleted)
}
public func setChefPrimaryKitchen(kitchen: Kitchen) async throws {
    let updateData: [String: Any] = ["primary_kitchen": kitchen.toFirestore()]
    try await self.update(data: updateData, for: .chefs)
}


public func updateSection(section: String, data: [[String: Any]]) async throws {
    firestoreManager.updateDocumentSection(
        collection: ChefCollections.chefProfiles.rawValue,
        documentID: self.id,
        section: section,
        updateData: data
    )
}
public func addKitchenToChef(kitchen: Kitchen) async {
    await firestoreManager.updateDocumentDependant(
        collection: ChefCollections.chefs.rawValue,
        documentID: self.id,
        field: "kitchens",
        value: kitchen.toFirestore(),
        operation: .arrayUnion
    )
}

public func removeKitchenFromChef(kitchenId: String, chefId: String) async {
    let kitchenData: [String: Any] = ["id": kitchenId]
    await firestoreManager.updateDocumentDependant(
        collection: ChefCollections.chefs.rawValue,
        documentID: chefId,
        field: "kitchens",
        value: kitchenData,
        operation: .arrayRemove
    )
}
public func updateMiseboxUserRole(miseboxUserId: String) async {
    let roleData = ["role": "chef", "username": username]
    await firestoreManager.updateDocumentDependant(
        collection: "misebox-users",
        documentID: miseboxUserId,
        field: "roles",
        value: roleData,
        operation: .arrayUnion
    )
}
}
*/
