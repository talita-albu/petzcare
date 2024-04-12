//
//  AddPetView.swift
//  PetzCare
//
//  Created by Talita Albuquerque Araújo on 09/04/24.
//

import SwiftUI

struct AddPetView: View {
    @State private var showingAddMedicineView = false
    @Binding var showingAddPetView: Bool
    @Binding var newPet: Pet
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Pet Name", text: $newPet.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                DatePicker("Birth Date", selection: $newPet.birthDate, displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                
                Picker("Species", selection: $newPet.species) {
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
                
                if !$newPet.id.isEmpty {
                    Button {
                        self.showingAddMedicineView.toggle()
                    } label: {
                        Text("Add Medicine")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.cyan)
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $showingAddMedicineView) {
                        MedicineListView(petId: newPet.id, showingListedicineView: $showingAddMedicineView)
                    }
                }
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
            var newPet = Pet(id: "", name: "", birthDate: Date(), species: "dog", gender: "male", userID: "0")
            AddPetView(showingAddPetView: .constant(true), newPet: .constant(newPet))
        }
    }
}
