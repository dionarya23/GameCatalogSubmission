//
//  EditProfileView.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 07/06/24.
//

import SwiftUI

struct EditProfileView: View {
    @Binding var editedName: String
    @Binding var editedAboutMe: String
    @Binding var isEditProfilePresented: Bool
    var body: some View {
        VStack {
            TextField("Name", text: $editedName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextEditor(text: $editedAboutMe)
                .frame(height: 200)
                .padding()
            Button("Save") {
                UserDefaults.standard.set(editedName, forKey: "userName")
                UserDefaults.standard.set(editedAboutMe, forKey: "userAboutMe")
                isEditProfilePresented.toggle()
            }
            .padding()
        }
    }
}
