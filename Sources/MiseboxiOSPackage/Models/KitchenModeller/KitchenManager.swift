//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import FirebaseFirestore

public final class KitchenManager {
    let firestoreManager = FirestoreManager()
    var rootCollection = "kitchens"
    var listener: ListenerRegistration?

    deinit {
        listener?.remove()
    }
}


