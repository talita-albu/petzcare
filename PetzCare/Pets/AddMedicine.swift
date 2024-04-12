//
//  AddMedicine.swift
//  PetzCare
//
//  Created by Talita Albuquerque Araújo on 12/04/24.
//

import SwiftUI

struct AddMedicine: View {
    @Binding var showingAddMedicineView: Bool
    @Binding var newMedicine: Medicine
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Medicine Name", text: $newMedicine.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Picker("Type", selection: $newMedicine.type) {
                    Text("Vermifuge").tag("vermifuge")
                    Text("Anti-fleas").tag("antiFleas")
                }
                .pickerStyle(SegmentedPickerStyle())
                
                DatePicker("Date To Apply", selection: $newMedicine.dateToApply, displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                
                Toggle("Was Applied", isOn: $newMedicine.wasApplied)
                                .padding()
                
                TextField("Duration of Effect (Days)", text: $newMedicine.duration)
                                .padding()
                                .keyboardType(.numberPad) // Use number pad keyboard
                                .onChange(of: newMedicine.duration) { newValue in
                                    // Filter out non-numeric characters
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    if filtered != newValue {
                                        newMedicine.duration = filtered
                                    }
                                }
                
                Button("Save") {
                    self.showingAddMedicineView.toggle()
                }
                .padding()
            }
            .navigationBarTitle("Add Medicine")
            .navigationBarItems(trailing: Button("Cancel") {
                self.showingAddMedicineView.toggle()
            })
        }
    }
}

struct AddMedicine_Previews: PreviewProvider {
    static var previews: some View {
        var newMedicine = Medicine(id: "", name: "", type: "", dateToApply: Date(), wasApplied: false, duration: "", petID: "")
        
        AddMedicine(showingAddMedicineView: .constant(true), newMedicine: .constant(newMedicine))
    }
}
