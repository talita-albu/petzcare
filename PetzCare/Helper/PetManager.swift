//
//  PetManager.swift
//  PetzCare
//
//  Created by Talita Albuquerque Araújo on 09/04/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class PetManager {
    
    static let shared = PetManager()
    private init() {}
    
    func savePet(newPet: Pet, user: String) throws {
        Firestore.firestore().collection("pets").addDocument(data: [
            "name": newPet.name,
            "birthDate": newPet.birthDate,
            "species": newPet.species,
            "gender": newPet.gender,
            "userID": user
        ])
    }
    
    func updatePet(petToUpdate: Pet, user: String) throws {
        let petFromDatase = Firestore.firestore().collection("pets").document(petToUpdate.id)
        petFromDatase.updateData([
            "name": petToUpdate.name,
            "birthDate": petToUpdate.birthDate,
            "species": petToUpdate.species,
            "gender": petToUpdate.gender,
            "userID": user
        ])
    }
    
    func deletePet(petToDelete: Pet) throws {
        let petFromDatase = Firestore.firestore().collection("pets").document(petToDelete.id)
        petFromDatase.delete()
    }
    
    func loadPets(userID: String, completion: @escaping ([Pet]) -> Void) {
        var pets: [Pet] = []
        
        let db = Firestore.firestore()
        var petsCollection: CollectionReference { db.collection("pets") }
        let query = petsCollection.whereField("userID", isEqualTo: userID)

        
        query.getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            pets = documents.compactMap { document in
                let data = document.data()
                let id = document.documentID
                let name = data["name"] as? String ?? ""
                let species = data["species"] as? String ?? ""
                let gender = data["gender"] as? String ?? ""
                let userID = data["userID"] as? String ?? ""
                
                // Assuming birthDate is stored as a Timestamp in Firestore
                let birthDateTimestamp = data["birthDate"] as? Timestamp ?? Timestamp()
                let birthDate = birthDateTimestamp.dateValue()
                
                return Pet(id: id, name: name, birthDate: birthDate, species: species, gender: gender, userID: userID)
            }
            
            completion(pets)
        }
    }
}
