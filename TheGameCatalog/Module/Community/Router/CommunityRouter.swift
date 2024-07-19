//
//  CommunityRouter.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 12/07/24.
//

import SwiftUI
import Core
import GameCommunity

class CommunityRouter {
    func makeLoginView() -> some View {
        let loginUseCase: Interactor<
            RequestLogin,
            UserModel,
            LoginRepository<LoginRemoteDataSource>
        > = injection.provideLogin()

        let registerUseCase: Interactor<
            RequestRegister,
            UserModel,
            RegisterRepository<RegisterRemoteDataSource>
        > = injection.provideRegister()

        let getChatUseCase: Interactor<
            String,
            [ChatModel],
            GetChatsRepository<GetChatsRemoteDataSource>
        > = injection.provideChats()

        let getUserUseCase: Interactor<
            String,
            UserModel,
            GetUsersRepository<GetUsersRemoteDataSource>
        > = injection.provideUser()

        let sendChatUseCase: Interactor<
            ChatModel,
            Bool,
            SendChatRepository<SendChatRemoteDataSource>
        > = injection.provideSendChat()

        let presenter = GameCommunityPresenter(
            loginUseCase: loginUseCase,
            chatUseCase: getChatUseCase,
            registerUseCase: registerUseCase,
            userUseCase: getUserUseCase,
            sendChatUseCase: sendChatUseCase
        )

        return LoginView(presenter: presenter)
    }

    func makeRegisterView() -> some View {
        let loginUseCase: Interactor<
            RequestLogin,
            UserModel,
            LoginRepository<LoginRemoteDataSource>
        > = injection.provideLogin()

        let registerUseCase: Interactor<
            RequestRegister,
            UserModel,
            RegisterRepository<RegisterRemoteDataSource>
        > = injection.provideRegister()

        let getChatUseCase: Interactor<
            String,
            [ChatModel],
            GetChatsRepository<GetChatsRemoteDataSource>
        > = injection.provideChats()

        let getUserUseCase: Interactor<
            String,
            UserModel,
            GetUsersRepository<GetUsersRemoteDataSource>
        > = injection.provideUser()

        let sendChatUseCase: Interactor<
            ChatModel,
            Bool,
            SendChatRepository<SendChatRemoteDataSource>
        > = injection.provideSendChat()

        let presenter = GameCommunityPresenter(
            loginUseCase: loginUseCase,
            chatUseCase: getChatUseCase,
            registerUseCase: registerUseCase,
            userUseCase: getUserUseCase,
            sendChatUseCase: sendChatUseCase
        )

        return RegisterView(presenter: presenter)
    }

    func makeChatView() -> some View {
        let loginUseCase: Interactor<
            RequestLogin,
            UserModel,
            LoginRepository<LoginRemoteDataSource>
        > = injection.provideLogin()

        let registerUseCase: Interactor<
            RequestRegister,
            UserModel,
            RegisterRepository<RegisterRemoteDataSource>
        > = injection.provideRegister()

        let getChatUseCase: Interactor<
            String,
            [ChatModel],
            GetChatsRepository<GetChatsRemoteDataSource>
        > = injection.provideChats()

        let getUserUseCase: Interactor<
            String,
            UserModel,
            GetUsersRepository<GetUsersRemoteDataSource>
        > = injection.provideUser()

        let sendChatUseCase: Interactor<
            ChatModel,
            Bool,
            SendChatRepository<SendChatRemoteDataSource>
        > = injection.provideSendChat()

        let presenter = GameCommunityPresenter(
            loginUseCase: loginUseCase,
            chatUseCase: getChatUseCase,
            registerUseCase: registerUseCase,
            userUseCase: getUserUseCase,
            sendChatUseCase: sendChatUseCase
        )

        return ChatView(presenter: presenter)
    }
}
