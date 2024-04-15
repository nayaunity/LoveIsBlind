//
//  User.swift
//  LoveIsBlind
//
//  Created by Nyaradzo Bere on 3/16/24.
//
import Foundation

struct User: Identifiable, Codable {
    var id: String
    var email: String
    var name: String
    var sex: String
    var genderIdentity: String
    var describeYourself: String
    var occupation: String
    var hobbies: String
    var whyAreYouSingle: String
    var roleModels: String
    var dealBreakers: String
    var profilePictureUrl: String
    var profileCompleted: Bool
    var profileReviewed: Bool
    var bioSubmitted: Bool

    // Custom initializer with only id and name as required parameters
    // and providing default values for all other parameters
    init(id: String, name: String, email: String = "", sex: String = "", genderIdentity: String = "", describeYourself: String = "", occupation: String = "", hobbies: String = "", whyAreYouSingle: String = "", roleModels: String = "", dealBreakers: String = "", profilePictureUrl: String = "", profileCompleted: Bool = false, profileReviewed: Bool = false, bioSubmitted: Bool = false) {
        self.id = id
        self.name = name
        self.email = email
        self.sex = sex
        self.genderIdentity = genderIdentity
        self.describeYourself = describeYourself
        self.occupation = occupation
        self.hobbies = hobbies
        self.whyAreYouSingle = whyAreYouSingle
        self.roleModels = roleModels
        self.dealBreakers = dealBreakers
        self.profilePictureUrl = profilePictureUrl
        self.profileCompleted = profileCompleted
        self.profileReviewed = profileReviewed
        self.bioSubmitted = bioSubmitted
    }
}
