//
//  Pet.swift
//  PetzCare
//
//  Created by Talita Albuquerque Araújo on 09/04/24.
//

import Foundation

struct Pet: Identifiable, Codable {
    var id: String
    var name: String
    var birthDate: Date
    var species: String
    var gender: String
    var userID: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case birthDate
        case species
        case gender
        case userID
    }
    
    static func ==(lhs: Pet, rhs: Pet) -> Bool {
        return lhs.id == rhs.id
    }
}
