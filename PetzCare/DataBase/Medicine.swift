//
//  Medicine.swift
//  PetzCare
//
//  Created by Talita Albuquerque Araújo on 12/04/24.
//

import Foundation


struct Medicine: Identifiable, Codable {
    var id: String
    var name: String
    var type: String
    var dateToApply: Date
    var wasApplied: Bool
    var duration: String
    var petID: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case dateToApply
        case wasApplied
        case duration
        case petID
    }
    
    static func ==(lhs: Medicine, rhs: Medicine) -> Bool {
        return lhs.id == rhs.id
    }
}
