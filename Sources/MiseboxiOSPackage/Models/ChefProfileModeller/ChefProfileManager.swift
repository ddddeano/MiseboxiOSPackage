//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import FirebaseFirestore


public final class ChefProfileManager: ObservableObject {
    
    var firestoreManager = FirestoreManager()
    var rootCollection = "chef-profiles"
    
    var listener: ListenerRegistration?
    deinit {
        listener?.remove()
    }
    @Published public var chefProfile: ChefProfile
    
    public init(chefProfile: ChefProfile) {
        self.chefProfile = chefProfile
    }
}
    
    
