//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 13/07/24.
//

import Foundation
import Combine
import Core
import SwiftUI
import FirebaseAuth

public class GameCommunityPresenter<
    LoginUseCase: UseCase,
    ChatUseCase: UseCase,
    RegisterUseCase: UseCase,
    UserUseCase: UseCase,
    SendChatUseCase: UseCase
>: ObservableObject where
LoginUseCase.Request == RequestLogin,
LoginUseCase.Response == UserModel,
ChatUseCase.Request == String,
ChatUseCase.Response == [ChatModel],
RegisterUseCase.Request == RequestRegister,
RegisterUseCase.Response == UserModel,
UserUseCase.Request == String,
UserUseCase.Response == UserModel,
SendChatUseCase.Request == ChatModel,
SendChatUseCase.Response == Bool
{
    private var cancellables: Set<AnyCancellable> = []

    private let loginUseCase: LoginUseCase
    private let chatUseCase: ChatUseCase
    private let registerUseCase: RegisterUseCase
    private let userUseCase: UserUseCase
    private let sendChatUseCase: SendChatUseCase
    
    @Published public var chats: [ChatModel]?
    @Published public var errorMessage: String = ""
    @Published public var isLoading: Bool = false
    @Published public var isError: Bool = false
    @Published public var isChatViewActive: Bool = false

    @Published public var email = ""
    @Published public var fullName = ""
    @Published public var password = ""
    @Published public var confirmPassword = ""
    @Published public var newMessage = ""
    @Published public var currentUser: UserModel?
    @Published public var alertItem: AlertItem?

    public init(
        loginUseCase: LoginUseCase,
        chatUseCase: ChatUseCase,
        registerUseCase: RegisterUseCase,
        userUseCase: UserUseCase,
        sendChatUseCase: SendChatUseCase
    ) {
      self.loginUseCase = loginUseCase
      self.chatUseCase = chatUseCase
      self.registerUseCase = registerUseCase
      self.userUseCase = userUseCase
      self.sendChatUseCase = sendChatUseCase
    }
    public func sendChat() {
        isLoading = true
        let newMessage = ChatModel(
            userId: currentUser?.userId ?? "",
            fullname: currentUser?.fullname ?? "",
            message: newMessage,
            createdAt: Date().timeIntervalSince1970)
        self.sendChatUseCase.execute(request: newMessage)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
              switch completion {
              case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.isError = true
                self.isLoading = false
                self.newMessage = ""
              case .finished:
                self.isLoading = false
              }
            }, receiveValue: { isSuccess in
              self.isLoading = !isSuccess
              self.newMessage = ""
            })
            .store(in: &cancellables)
    }
    public func signIn() {
        if !email.isEmpty && !password.isEmpty {
            isLoading = true
            let requestLogin = RequestLogin(email: email, password: password)
            self.loginUseCase.execute(request: requestLogin)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                  switch completion {
                  case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isError = true
                    self.showAlert(description: error.localizedDescription)
                    self.isLoading = false
                    self.email = ""
                    self.password = ""
                  case .finished:
                    self.isLoading = false
                  }
                }, receiveValue: { user in
                    self.currentUser = user
                    self.email = ""
                    self.password = ""
                    self.isChatViewActive.toggle()
                })
                .store(in: &cancellables)
        }
    }
    public func createUser() {
        if !email.isEmpty
            && !password.isEmpty
            && !fullName.isEmpty
            && !confirmPassword.isEmpty {
            if password != confirmPassword {
                errorMessage = "Password dan confirm password tidak sama"
            } else {
            isLoading = true
                let requestRegister = RequestRegister(email: email, password: password, fullName: fullName)
                self.registerUseCase.execute(request: requestRegister)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                        self.showAlert(description: error.localizedDescription)
                        self.isError = true
                        self.isLoading = false
                        self.email = ""
                        self.password = ""
                        self.confirmPassword = ""
                        self.fullName = ""
                    case .finished:
                        self.isLoading = false
                    }
                }, receiveValue: { user in
                    self.currentUser = user
                    self.email = ""
                    self.password = ""
                    self.confirmPassword = ""
                    self.fullName = ""
                    self.isChatViewActive.toggle()
                })
                .store(in: &cancellables)
            }
        }
    }
    
    public func fetchChats() {
        self.chatUseCase.execute(request: nil)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                        self.isError = true
                        self.isLoading = false
                    case .finished:
                        self.isLoading = false
                    }
                }, receiveValue: { chats in
                    self.isLoading = false
                    self.chats = chats
                })
                .store(in: &cancellables)
    }
    
    public func fetchCurrentUser(request: UserUseCase.Request) {
       self.userUseCase.execute(request: request)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
              switch completion {
              case .failure(let error):
                self.errorMessage = error.localizedDescription
                  print(self.errorMessage)
                self.isError = true
                self.isLoading = false
              case .finished:
                self.isLoading = false
              }
            }, receiveValue: { user in
              self.currentUser = user
            })
            .store(in: &cancellables)
    }
    
    public func signOut() {
        do {
            try Auth.auth().signOut()
            self.currentUser = nil
            self.isChatViewActive = false
        } catch let singOutError as NSError {
            print("Error signOut: \(singOutError)")
            isError = true
        }
    }
    
    private func showAlert(description: String) {
         alertItem = AlertItem(title: Text("Gagal!"),
                               message: Text(description),
                               dismissButton: .default(Text("Ok")))
     }
}
