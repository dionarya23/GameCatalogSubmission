//
//  LoginView.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 12/07/24.
//

import SwiftUI
import Core
import GameCommunity

struct LoginView: View {
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

    var body: some View {
        NavigationStack {
            VStack {
                if self.presenter.isLoading {
                    loadingIndicator
                } else {
                    Image("gameIcon")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .padding(.vertical, 32)
                    Text("Login to join Community")
                        .padding()
                    formView
                        .padding(.horizontal)
                        .padding(.top, 12)
                    buttonLogin
                    Spacer()
                    linkBuilderRegister {
                        HStack {
                            Text("Don't have an account?")
                            Text("Sign Up")
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        }
                        .foregroundColor(Color("brandColor"))
                        .font(.system(size: 14))
                    }
                }
            }
            .navigationDestination(isPresented: $presenter.isChatViewActive) {
                ChatView(presenter: presenter)
            }
            .alert(item: $presenter.alertItem) { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
            }
        }
    }
}

extension LoginView {
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
            InputView(text: $presenter.password,
                      title: "Password",
                      placeholder: "Enter your password",
                      isSecuredField: true)
            .autocapitalization(.none)
        }
    }
    var buttonLogin: some View {
        Button {
            presenter.signIn()
        } label: {
            HStack {
                Text("SIGN IN")
                    .fontWeight(.semibold)
                Image(systemName: "arrow.right")
            }
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width - 32, height: 48)
        }
        .background(
            presenter.email.isEmpty
            || presenter.password.isEmpty
            || presenter.password.count < 6
            ? Color("brandColor").opacity(0.5)
            : Color("brandColor")
        )
        .cornerRadius(10)
        .padding(.top, 24)
        .disabled(
            presenter.email.isEmpty
            && presenter.password.isEmpty
            && presenter.password.count < 6
        )
    }
    func linkBuilderRegister<Content: View>(
        @ViewBuilder content: () -> Content
      ) -> some View {
        NavigationLink(
            destination: CommunityRouter().makeRegisterView()
        ) { content() }
      }
}
