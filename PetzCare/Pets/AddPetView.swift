//
//  AddPetView.swift
//  PetzCare
//
//  Created by Talita Albuquerque Araújo on 09/04/24.
//

import SwiftUI

struct AddPetView: View {
    @Binding var showingAddPetView: Bool
    @Binding var newPet: Pet
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Pet Name", text: $newPet.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                DatePicker("Birth Date", selection: $newPet.birthDate, displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                
                Picker("Type", selection: $newPet.type) {
                    Text("Dog").tag("dog")
                    Text("Cat").tag("cat")
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Picker("Gender", selection: $newPet.gender) {
                    Text("Male").tag("male")
                    Text("Female").tag("female")
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Button("Save") {
                    self.showingAddPetView.toggle()
                }
                .padding()
            }
            .navigationBarTitle("Add Pet")
            .navigationBarItems(trailing: Button("Cancel") {
                self.showingAddPetView.toggle()
            })
        }
    }
}

struct AddPetView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            var newPet = Pet(id: "", name: "", birthDate: Date(), type: "dog", gender: "male", userID: "0")
            AddPetView(showingAddPetView: .constant(true), newPet: .constant(newPet))
        }
    }
}
