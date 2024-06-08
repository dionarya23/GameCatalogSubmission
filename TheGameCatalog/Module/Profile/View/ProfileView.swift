//
//  ProfileView.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 07/06/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var presenter: ProfilePresenter
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Image("dionMe")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 240, height: 240)
                .clipShape(Circle())
                .overlay(Circle().stroke(.white, lineWidth: 4))
                .shadow(radius: 5)
            Text(presenter.editedName)
                .font(.title)
                .foregroundColor(.white)
                .padding(.top)
            HStack(spacing: 30) {
                ForEach(presenter.socialMediaLogos, id: \.name) { socialMedia in
                    self.presenter.linkBuilder(url: socialMedia.url) {
                        Image(socialMedia.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    }
                }
            }
            .padding(.bottom, 20)
            VStack(alignment: .leading) {
                Text("About Me")
                    .font(.title2)
                Text(presenter.editedAboutMe)
                    .font(.subheadline)
                    .fontWeight(.light)
                    .multilineTextAlignment(.leading)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                editButton
                    .sheet(isPresented: $presenter.isEditProfilePresented) {
                        EditProfileView(
                            editedName: $presenter.editedName,
                            editedAboutMe: $presenter.editedAboutMe,
                            isEditProfilePresented: $presenter.isEditProfilePresented
                        )
                }
            }
        }
        .navigationTitle("About")
        .padding()
    }
}

extension ProfileView {
    var editButton: some View {
        Button(action: {
            presenter.isEditProfilePresented.toggle()
        }, label: {
            Image(systemName: "pencil")
                .foregroundColor(Color("brandColor"))
                .frame(width: 40, height: 40)
                .padding()
        })
    }
}
