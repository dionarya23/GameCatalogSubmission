//
//  RegisterView.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 12/07/24.
//

import SwiftUI
import Core
import GameCommunity

struct RegisterView: View {
    @ObservedObject var presenter: GameCommunityPresenter<
        Interactor<RequestLogin, UserModel, LoginRepository<
            LoginRemoteDataSource
        >>,
        Interactor<String, [ChatModel], GetChatsRepository<
            GetChatsRemoteDataSource
        >>,
        Interactor<RequestRegister, UserModel, RegisterRepository<
           RegisterRemoteDataSource
        >>,
        Interactor<String, UserModel, GetUsersRepository<
            GetUsersRemoteDataSource
        >>,
        Interactor<ChatModel, Bool, SendChatRepository<
            SendChatRemoteDataSource
        >>
    >

    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            if self.presenter.isLoading {
                loadingIndicator
            } else {
                Image("gameIcon")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .padding(.vertical, 32)
                Text("Register to join Community")
                    .padding()
                formView
                    .padding(.horizontal)
                    .padding(.top, 12)
                buttonRegister
                Spacer()
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Text("Already have an account?")
                        Text("Sign In")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    .foregroundColor(Color("brandColor"))
                    .font(.system(size: 14))
                }
                .padding(.top, 24)
            }
        }
        .navigationDestination(isPresented: $presenter.isChatViewActive) {
            ChatView(presenter: presenter)
        }
        .alert(item: $presenter.alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
        .navigationBarBackButtonHidden(true)
    }
}

extension RegisterView {
    var loadingIndicator: some View {
      VStack {
        Text("Loading...")
        ProgressView()
      }
    }
    var formView: some View {
        VStack(spacing: 24) {
            InputView(text: $presenter.email,
                      title: "Email Address",
                      placeholder: "name@example.com")
            .autocapitalization(.none)
            InputView(text: $presenter.fullName,
                      title: "Full Name",
                      placeholder: "Enter your name")
            InputView(text: $presenter.password,
                      title: "Password",
                      placeholder: "Enter your password",
                      isSecuredField: true)
            InputView(text: $presenter.confirmPassword,
                      title: "Confirm Password",
                      placeholder: "Confirm your password",
                      isSecuredField: true)
        }
    }
    var buttonRegister: some View {
        Button(action: {
            presenter.createUser()
        }, label: {
            HStack {
                Text("SIGN UP")
                    .fontWeight(.semibold)
                Image(systemName: "arrow.right")
            }
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width - 32, height: 48)
        })
        .background(
            presenter.email.isEmpty
            || presenter.password.isEmpty
            || presenter.password.count < 6
            || presenter.fullName.isEmpty
            || presenter.confirmPassword.isEmpty
            || presenter.confirmPassword.count < 6
            || presenter.confirmPassword != presenter.password
            ? Color("brandColor").opacity(0.5)
            : Color("brandColor")
        )
        .cornerRadius(10)
        .padding(.top, 24)
        .disabled(
            presenter.email.isEmpty
            && presenter.password.isEmpty
            && presenter.password.count < 6
            && presenter.fullName.isEmpty
            && presenter.confirmPassword.isEmpty
            && presenter.confirmPassword.count < 6
            && presenter.confirmPassword != presenter.password
        )
    }
}
