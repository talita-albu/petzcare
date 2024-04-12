//
//  PetsList.swift
//  PetzCare
//
//  Created by Talita Albuquerque Araújo on 09/04/24.
//

import SwiftUI
import Firebase

@MainActor
final class PetViewModel: ObservableObject {
    
    @Published private(set) var user: AuthDataResultModel? = nil
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    @Published var pets: [Pet] = []
    
    @Published var newPet = Pet(id: "", name: "", birthDate: Date(), species: "dog", gender: "male", userID: "0")
    
    func loadCurentUser() throws {
        self.user = try AuthorizationManager.shared.getAuthenticatedUser()
    }
    
    func loadPets() throws {
        try loadCurentUser()
        PetManager.shared.loadPets(userID: user?.uid ?? "0"){ pets in
            self.pets = pets
        }
    }
    
    func maintainPet(petToWork: Pet) {
        do {
            try loadCurentUser()
            let currentUser = self.user?.uid ?? "0"
            
            if petToWork.id.isEmpty {
                try PetManager.shared.savePet(newPet: petToWork, user: currentUser)
            } else {
                try PetManager.shared.updatePet(petToUpdate: petToWork, user: currentUser)
            }
            
            try loadPets()
            
        } catch {
            alertTitle = "Alert"
            alertMessage = "Pet not saved"
            showAlert = true
        }
    }
    
    func deletePet(index: Int) throws {
        let pet = self.pets[index]
        try PetManager.shared.deletePet(petToDelete: pet)
    }
}
    
struct PetsList: View {
    
    @State private var showingAddPetView = false
    @State private var showingSettingsView = false
    @StateObject private var viewModel = PetViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.pets) { pet in
                        HStack {
                            Image(pet.species)
                                .resizable()
                                .font(.largeTitle)
                                .bold()
                                .symbolRenderingMode(.monochrome)
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                            VStack(alignment: .leading) {
                                Text(pet.name)
                                    .font(.title)
                                    .bold()
                                Text(pet.species)
                            }
                            Spacer()
                            Button {
                                viewModel.newPet.id = pet.id
                                viewModel.newPet.gender = pet.gender
                                viewModel.newPet.name = pet.name
                                viewModel.newPet.species = pet.species
                                viewModel.newPet.userID = pet.userID
                                viewModel.newPet.birthDate = pet.birthDate
                                self.showingAddPetView.toggle()
                            } label: {
                                Image(systemName: "pencil")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(height: 30)
                                    .frame(width: 30)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }.sheet(isPresented: $showingAddPetView) {
                                AddPetView(showingAddPetView: $showingAddPetView, newPet: $viewModel.newPet)
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
                        self.showingAddPetView.toggle()
                    } label: {
                        Text("Add Pet")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.cyan)
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $showingAddPetView) {
                        AddPetView(showingAddPetView: $showingAddPetView, newPet: $viewModel.newPet)
                            .onDisappear {
                                if !viewModel.newPet.name.isEmpty {
                                    viewModel.maintainPet(petToWork: viewModel.newPet)
                                }
                            }
                    }.alert(isPresented: $viewModel.showAlert, content: {
                        getAlert()
                    })
                    
//                    NavigationLink {
//                        SettingsView(showSignInView: $showSignInView)
//                    } label: {
//                        Text("Settings")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .frame(height: 55)
//                            .frame(maxWidth: .infinity)
//                            .background(Color.indigo)
//                            .cornerRadius(10)
//                    }
                    
                }.padding()
            }
            .navigationTitle("Pet Registry")
        }
        .onAppear {
            do {
                try viewModel.loadPets()
            } catch {
                viewModel.alertTitle = "Alert"
                viewModel.alertMessage = "Pets not loaded"
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
                try viewModel.deletePet(index: index)
            } catch {
                viewModel.alertTitle = "Alert"
                viewModel.alertMessage = "Error on delete"
                viewModel.showAlert = true
            }
        }
    }
}
    
struct PetsList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PetsList(showSignInView: .constant(false))
        }
    }
}

