//
//  ProfilePresenter.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 07/06/24.
//

import SwiftUI

class ProfilePresenter: ObservableObject {
    private let router = ProfileRouter()
    @Published var socialMediaLogos: [SocialMedia] = [
        SocialMedia(name: "GitHub", imageName: "githubLogo", url: "https://github.com/dionarya23"),
        SocialMedia(name: "LinkedIn", imageName: "linkedinLogo", url: "https://linkedin.com/in/dionarya"),
        SocialMedia(name: "Website", imageName: "websiteLogo", url: "https://dionpamungkas.com")
    ]
    @Published var isEditProfilePresented = false
    @Published var editedName = UserDefaults.standard.string(forKey: "userName") ?? "Dion Pamungkas"
    @Published var editedAboutMe = UserDefaults.standard.string(forKey: "userAboutMe") ??
    "I'm a Software Engineer Backend based in Indonesia 🇮🇩. " +
    "I have a strong affinity for creating beautiful and highly functional websites."
    func linkBuilder<Content: View>(
      url: String,
      @ViewBuilder content: () -> Content
    ) -> some View {
      NavigationLink(destination: router.makeDetailSocMedView(url: url)) { content() }
    }
}
