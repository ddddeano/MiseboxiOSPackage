import Foundation

extension MiseboxUserManager {

    public func updateMiseboxUser(fieldName: String, newValue: Any) async throws {
        let updateData = [fieldName: newValue]
       firestoreManager.updateDocument(collection: MiseboxUserDocCollectionMarker.miseboxUser.collection(), documentID: self.id, updateData: updateData)
        try await updateDependants(fieldName: fieldName, newValue: newValue)
    }
    
    public func updateMiseboxUserProfile(fieldName: String, newValue: Any) async throws {
        let updateData = [fieldName: newValue]
        firestoreManager.updateDocument(collection: MiseboxUserDocCollectionMarker.miseboxUserProfile.collection(), documentID: self.id, updateData: updateData)
    
    }

    private func updateDependants(fieldName: String, newValue: Any) async throws {
        switch fieldName {
        case "username":
            if let newUsername = newValue as? String {
                try await updateDependantDocumentsForField("username", newValue: newUsername)
            }
        case "user_roles":
            if let newUserRoles = newValue as? [UserRole] {
                try await updateDependantDocumentsForRoles(newUserRoles)
            }
        default:
            break
        }
    }

    private func updateDependantDocumentsForField(_ fieldName: String, newValue: Any) async throws {
        for role in [UserDependantDocCollection.chef, .recruiter] {
            let collection = role.collection()
            firestoreManager.updateDocument(
                collection: collection,
                documentID: self.id,
                updateData: ["miseboxUser.\(fieldName)": newValue]
            )
        }
    }

    private func updateDependantDocumentsForRoles(_ newUserRoles: [UserRole]) async throws {
        // Implement logic to update dependent documents when user roles change
        print("Updating dependent documents for role changes")
    }
}
