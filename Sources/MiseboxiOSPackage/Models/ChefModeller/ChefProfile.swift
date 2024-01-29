//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import FirebaseFirestore

extension ChefManager {
    
    public final class ChefProfile: ObservableObject, Identifiable, Listenable {
            public var collectionName = "chef-profiles"
            
            @Published public var id = ""
            @Published public var nationality = Nationality()
            @Published public var aboutMeBio = AboutMeBio()
            @Published public var gallery: [GalleryImage] = []
            @Published public var previousEmployment: [PreviousEmployment] = []
            @Published public var qualifications: [Qualification] = []
            @Published public var spokenLanguages: [SpokenLanguage] = []
            
            public init() {}
            
            public required init?(documentSnapshot: DocumentSnapshot) {
                guard let data = documentSnapshot.data() else { return nil }
                self.id = documentSnapshot.documentID
                update(with: data)
            }

            public func update(with data: [String: Any]) {
                self.nationality = fireObject(from: data["nationality"] as? [String: Any] ?? [:], using: Nationality.init) ?? Nationality()
                self.aboutMeBio = fireObject(from: data["about_me_bio"] as? [String: Any] ?? [:], using: AboutMeBio.init) ?? AboutMeBio()
                self.gallery = fireArray(from: data["gallery"] as? [[String: Any]] ?? [], using: GalleryImage.init)
                self.previousEmployment = fireArray(from: data["previous_employment"] as? [[String: Any]] ?? [], using: PreviousEmployment.init)
                self.qualifications = fireArray(from: data["qualifications"] as? [[String: Any]] ?? [], using: Qualification.init)
                self.spokenLanguages = fireArray(from: data["spoken_languages"] as? [[String: Any]] ?? [], using: SpokenLanguage.init)
            }

            public func toFirestore() -> [String: Any] {
                [
                    "nationality": nationality.toFirestore(),
                    "about_me_bio": aboutMeBio.toFirestore(),
                    "gallery": gallery.map { $0.toFirestore() },
                    "previous_employment": previousEmployment.map { $0.toFirestore() },
                    "qualifications": qualifications.map { $0.toFirestore() },
                    "spoken_languages": spokenLanguages.map { $0.toFirestore() }
                ]
            }
        }
}
