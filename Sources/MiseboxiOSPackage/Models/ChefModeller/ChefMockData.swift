//
//  ChefMockData.swift
//  Created by Daniel Watson on 25.01.24.
//

import Foundation
import FirebaseFirestore

extension ChefManager {
    static let tinyImg = "https://firebasestorage.googleapis.com/v0/b/misebox-78f9c.appspot.com/o/avatars%2Fdog5.jpg?alt=media&token=c1bf2892-b854-4078-9bed-c8266c5362d9"
    
    static let mockMiseboxUserManager = MiseboxUserManager.mockMiseboxUserManager()

    static func mockKitchen1() -> KitchenManager.Kitchen {
        let primaryKitchen = KitchenManager.Kitchen()
        primaryKitchen.id = "primaryKitchenId"
        primaryKitchen.name = "Gourmet Haven"
        return primaryKitchen
    }
    static func mockKitchen2() -> KitchenManager.Kitchen {
        let kitchen2 = KitchenManager.Kitchen()
        kitchen2.id = "kitchen2Id"
        kitchen2.name = "Culinary Delights"
        return kitchen2
    }
    static func mockKitchen3() -> KitchenManager.Kitchen {
        let kitchen3 = KitchenManager.Kitchen()
        kitchen3.id = "kitchen3Id"
        kitchen3.name = "The Flavor Lab"
        return kitchen3
    }
    
    // MARK: - Helper Mock Methods for ChefProfile
    
    static let chefMiseboxUser = ChefManager.MiseboxUser(miseboxUser: mockMiseboxUserManager.miseboxUser)
    
    static let chefKitchen1 = ChefManager.Kitchen(kitchen: mockKitchen1())
    static let chefKitchen2 = ChefManager.Kitchen(kitchen: mockKitchen2())
    static let chefKitchen3 = ChefManager.Kitchen(kitchen: mockKitchen3())
    
    static func mockGeneralInfo() -> GeneralInfo {
        var info = GeneralInfo()
        info.name = mockMiseboxUserManager.fullName
        info.username = mockMiseboxUserManager.username
        info.imageUrl = tinyImg
        info.nickname = "Nickname"
        return info
    }
 
    static func mockNationality() -> Nationality {
        var nationality = Nationality()
        nationality.country = "Mock Country"
        nationality.flagCode = "MC"
        return nationality
    }
    
    static func mockAboutMeBio() -> AboutMeBio {
        var bio = AboutMeBio()
        bio.aboutMe = "Mock About Me"
        bio.bio = "Mock Bio"
        return bio
    }
    
    static func mockGalleryImage() -> GalleryImage {
        GalleryImage(name: "Mock Image", imageUrl: tinyImg)
    }
    static func mockGalleryImage2() -> GalleryImage {
        GalleryImage(name: "Mock Image 2", imageUrl: tinyImg)
    }
    static func mockPreviousEmployment() -> PreviousEmployment {
        var employment = PreviousEmployment()
        employment.employerName = "Mock Employer"
        employment.role = "Mock Role"
        employment.startDate = "2022-01-01"
        employment.endDate = "2023-01-01"
        employment.description = "Mock Job Description"
        return employment
    }
    
    static func mockQualification() -> Qualification {
        var qualification = Qualification()
        qualification.docURL = "https://example.com/certificate.pdf"
        qualification.institution = "Mock Institution"
        qualification.name = "Mock Qualification"
        qualification.level = "Expert"
        return qualification
    }
    
    static func mockSpokenLanguage() -> SpokenLanguage {
        var language = SpokenLanguage()
        language.lang = "English"
        language.level = "Native"
        return language
    }

    public static func mockChef() -> Chef {
        let chef = Chef()
        chef.id = mockMiseboxUserManager.id
        chef.name = mockMiseboxUserManager.name
        chef.generalInfo = mockGeneralInfo()
        chef.miseboxUser = chefMiseboxUser
        chef.primaryKitchen = chefKitchen1
        chef.kitchens = [chefKitchen1, chefKitchen2, chefKitchen3]
        return chef
    }
    
    public static func mockChefProfile() -> ChefProfile {
        let profile = ChefProfile()
        profile.id = mockChef().id
        profile.nationality = mockNationality()
        profile.aboutMeBio = mockAboutMeBio()
        profile.gallery = [mockGalleryImage(), mockGalleryImage2()]
        profile.previousEmployment = [mockPreviousEmployment(), mockPreviousEmployment()]
        profile.qualifications = [mockQualification(), mockQualification()]
        return profile
    }
    
    public static func mockChefManager() -> ChefManager {
        let mockChef = ChefManager.mockChef()
        let mockChefProfile = ChefManager.mockChefProfile()
        let mockChefManager = ChefManager(chef: mockChef, chefProfile: mockChefProfile)
        return mockChefManager
    }
}
