//
//  MedicineListView.swift
//  PetzCare
//
//  Created by Talita Albuquerque Araújo on 12/04/24.
//

import SwiftUI
import Firebase

@MainActor
final class MedicineListViewModel: ObservableObject {
    
    @Published private(set) var user: AuthDataResultModel? = nil
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    @Published var medicines: [Medicine] = []
    
    @Published var newMedicine = Medicine(id: "", name: "", type: "", dateToApply: Date(), wasApplied: false, duration: "", petID: "")
    
    func loadMedicines(petID: String) throws {
        MedicineManager.shared.loadMedicines(petID: petID){medicines in
            self.medicines = medicines
        }
    }

    func maintainMedicine(medicineToWork: Medicine, petId: String) {
        do {
            if medicineToWork.id.isEmpty {
                try MedicineManager.shared.saveMedicine(newMedicine: medicineToWork, petId: petId)
            } else {
                try MedicineManager.shared.updateMedicine(medicineToUpdate: medicineToWork, petId: petId)
            }

            try loadMedicines(petID: petId)

        } catch {
            alertTitle = "Alert"
            alertMessage = "Pet not saved"
            showAlert = true
        }
    }

    func deleteMedicine(index: Int) throws {
        let medicine = self.medicines[index]
        try MedicineManager.shared.deleteMedicine(medicineToDelete: medicine)
    }
}
    
struct MedicineListView: View {
    @State var petId: String
    @Binding var showingListedicineView: Bool
    @State private var showingAddMedicineView = false
    @StateObject private var viewModel = MedicineListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(viewModel.medicines) { medicine in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(medicine.name)
                                    .font(.title)
                                    .bold()
                                Text(formattedDate(medicine.dateToApply))
                            }
                            Spacer()
                            Button {
                                viewModel.newMedicine.id = medicine.id
                                viewModel.newMedicine.dateToApply = medicine.dateToApply
                                viewModel.newMedicine.name = medicine.name
                                viewModel.newMedicine.type = medicine.type
                                viewModel.newMedicine.wasApplied = medicine.wasApplied
                                viewModel.newMedicine.duration = medicine.duration
                                viewModel.newMedicine.petID = medicine.petID
                                self.showingAddMedicineView.toggle()
                            } label: {
                                Image(systemName: "pencil")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(height: 30)
                                    .frame(width: 30)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }.sheet(isPresented: $showingAddMedicineView) {
                                AddMedicine(showingAddMedicineView: $showingAddMedicineView, newMedicine: $viewModel.newMedicine)
                            }.alert(isPresented: $viewModel.showAlert, content: {
                                getAlert()
                            })
                        }
                        .padding(.bottom, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.white)
                        .cornerRadius(16)
                    }.onDelete(perform: deleteItem)
                }.alert(isPresented: $viewModel.showAlert, content: {
                    getAlert()
                })
                
                HStack {
                    Button {
                        self.showingAddMedicineView.toggle()
                    } label: {
                        Text("Add New Medicine")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.cyan)
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $showingAddMedicineView) {
                        AddMedicine(showingAddMedicineView: $showingAddMedicineView, newMedicine: $viewModel.newMedicine)
                            .onDisappear {
                                if !viewModel.newMedicine.name.isEmpty {
                                    viewModel.maintainMedicine(medicineToWork: viewModel.newMedicine, petId: self.petId)
                                }
                            }
                    }.alert(isPresented: $viewModel.showAlert, content: {
                        getAlert()
                    })

                }.padding()
            }
            .navigationTitle("Medicine Registry")
            .navigationBarItems(trailing: Button("Cancel") {
                self.showingListedicineView.toggle()
            })
        }
        .onAppear {
            do {
                try viewModel.loadMedicines(petID: self.petId)
            } catch {
                viewModel.alertTitle = "Alert"
                viewModel.alertMessage = "Medicines not loaded"
                viewModel.showAlert = true
            }
        }
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text(viewModel.alertTitle),
                     message: Text(viewModel.alertMessage),
                     dismissButton: .default(Text("Ok")))
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    func deleteItem(at offsets: IndexSet) {
        if let index = offsets.first {
            do {
                try viewModel.deleteMedicine(index: index)
            } catch {
                viewModel.alertTitle = "Alert"
                viewModel.alertMessage = "Error on delete"
                viewModel.showAlert = true
            }
        }
    }
}

struct MedicineListView_Previews: PreviewProvider {
    static var previews: some View {
        MedicineListView(petId: "0", showingListedicineView: .constant(true))
    }
}
