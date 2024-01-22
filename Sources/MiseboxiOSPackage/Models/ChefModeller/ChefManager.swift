//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import FirebaseFirestore

public final class ChefManager: ObservableObject {
        
    var firestoreManager = FirestoreManager()
    var rootCollection = "chefs"
    
    var dependants = ["misebox-users", "chef-profiles"]
    
    var listener: ListenerRegistration?
    deinit {
        listener?.remove()
    }
    
    @Published public var chef: Chef
    
    public init(chef: Chef) {
        self.chef = chef
    }
}
