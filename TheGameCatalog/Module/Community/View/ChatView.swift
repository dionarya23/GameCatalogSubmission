//
//  ChatView.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 12/07/24.
//

import Core
import GameCommunity
import SwiftUI
import FirebaseAuth

struct ChatView: View {
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
            ZStack {
                if self.presenter.isLoading {
                    loadingIndicator
                } else if self.presenter.isError {
                    errorIndicator
                } else {
                    Color(.black)
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        if Auth.auth().currentUser?.uid != nil {
                            communityChat
                            textfield
                        } else {
                            authIndicator
                        }
                    }
                }
        }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Community Chats")
                        .font(.title2)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
                if Auth.auth().currentUser?.uid != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            presenter.signOut()
                        }, label: {
                            Image(systemName: "power")
                                .foregroundColor(Color("brandColor"))
                                .frame(width: 24, height: 24)
                                .padding()
                        })
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            if Auth.auth().currentUser?.uid != nil && presenter.chats == nil {
                presenter.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.presenter.fetchChats()
                    self.presenter.fetchCurrentUser(request: Auth.auth().currentUser?.uid ?? "")
                }
            }
        }
    .alert(item: $presenter.alertItem) { alertItem in
        Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
    }
  }
}

extension ChatView {
    var loadingIndicator: some View {
      VStack {
        Text("Loading...")
        ProgressView()
      }
    }
    var errorIndicator: some View {
      CustomEmptyView(
        image: "assetNotFound",
        title: presenter.errorMessage
      ).offset(y: 80)
    }
    var authIndicator: some View {
        VStack {
            Image("gameIcon")
            Text("You have not joined the community")
                .font(.headline)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .multilineTextAlignment(.center)
            Text("Log in or sign up to join and chat with the community")
                .font(.subheadline)
                .fontWeight(.light)
                .multilineTextAlignment(.center)
                .padding(.top, 12)
            linkBuilderLogin {
                HStack {
                    Text("Log In or Sign Up")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color("brandColor"))
            .cornerRadius(20)
            .padding(.top, 12)
        }
    }
    var communityChat: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array(presenter.chats?.enumerated() ?? [].enumerated()), id: \.element) { index, chatMessage in
                    BubbleChat(chatMessage: chatMessage, chats_: presenter.chats ?? [], index: index)
                }
            }
            .padding()
        }
    }
    var textfield: some View {
        HStack {
            TextField("Write here", text: $presenter.newMessage)
                .padding(10)
                .background(Color.black)
                .cornerRadius(20)
                .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
                .overlay(
                    Capsule().stroke(Color("brandColor"), lineWidth: 1)
                )
                .overlay(
                    Button(action: {
                        presenter.sendChat()
                }, label: {
                    Image(systemName: "arrow.up")
                        .padding(5)
                        .background(presenter.newMessage.isEmpty
                                    ? Color("brandColor").opacity(0.4)
                                    : Color("brandColor"))
                        .foregroundColor(.white)
                        .cornerRadius(50)
                        .offset(x: -12, y: 0)
                    })
                    .disabled(presenter.newMessage.isEmpty),
                    alignment: .trailing
                )
                .padding(.horizontal)
        }
    }
    func linkBuilderLogin<Content: View>(
        @ViewBuilder content: () -> Content
      ) -> some View {
        NavigationLink(
            destination: CommunityRouter().makeLoginView()
        ) { content() }
      }
}
