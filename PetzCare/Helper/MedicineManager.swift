//
//  MedicineManager.swift
//  PetzCare
//
//  Created by Talita Albuquerque Araújo on 12/04/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class MedicineManager {
    
    static let shared = MedicineManager()
    private init() {}
    
    func saveMedicine(newMedicine: Medicine, petId: String) throws {
        Firestore.firestore().collection("medicines").addDocument(data: [
            "name": newMedicine.name,
            "type": newMedicine.type,
            "dateToApply": newMedicine.dateToApply,
            "duration": newMedicine.duration,
            "wasApplied": newMedicine.wasApplied,
            "petId": petId
        ])
    }
    
    func updateMedicine(medicineToUpdate: Medicine, petId: String) throws {
        var medicineFromDatase = Firestore.firestore().collection("medicines").document(medicineToUpdate.id)
        medicineFromDatase.updateData([
            "name": medicineToUpdate.name,
            "type": medicineToUpdate.type,
            "dateToApply": medicineToUpdate.dateToApply,
            "duration": medicineToUpdate.duration,
            "wasApplied": medicineToUpdate.wasApplied,
            "petId": petId
        ])
    }
    
    func deleteMedicine(medicineToDelete: Medicine) throws {
        var medicineFromDatase = Firestore.firestore().collection("medicines").document(medicineToDelete.id)
        medicineFromDatase.delete()
    }
    
    func loadMedicines(petID: String, completion: @escaping ([Medicine]) -> Void) {
        var medicines: [Medicine] = []
        
        let db = Firestore.firestore()
        var medicinesCollection: CollectionReference { db.collection("medicines") }
        let query = medicinesCollection.whereField("petId", isEqualTo: petID)

        
        query.getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            medicines = documents.compactMap { document in
                let data = document.data()
                let id = document.documentID
                let name = data["name"] as? String ?? ""
                let type = data["type"] as? String ?? ""
                let duration = data["duration"] as? String ?? ""
                let wasApplied = data["wasApplied"] as? Bool ?? false
                let petId = data["petId"] as? String ?? ""
                
                // Assuming dateToApply is stored as a Timestamp in Firestore
                let dateToApplyTimestamp = data["dateToApply"] as? Timestamp ?? Timestamp()
                let dateToApply = dateToApplyTimestamp.dateValue()
                
                return Medicine(id: id, name: name, type: type, dateToApply: dateToApply, wasApplied: wasApplied, duration: duration, petID: petID)
            }
            
            completion(medicines)
        }
    }
}
