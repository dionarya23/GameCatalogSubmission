//
//  BubbleChat.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 12/07/24.
//

import SwiftUI
import FirebaseAuth
import GameCommunity

struct BubbleChat: View {
    var chatMessage: ChatModel
    var chats_: [ChatModel]?
    var index: Int
    var body: some View {
        VStack(alignment:
                chatMessage.userId != Auth.auth().currentUser?.uid
               ? .leading
               : .trailing, spacing: 5) {
        if index == 0 || (index > 0 && chats_?[index - 1].userId != chatMessage.userId) {
            Text(chatMessage.fullname)
                .font(.footnote)
                .foregroundColor(.gray)
            }
            Text(chatMessage.message)
                .padding(10)
                .background(
                    chatMessage.userId != Auth.auth().currentUser?.uid
                    ? Color.gray.opacity(0.2)
                    : Color("brandColor").opacity(0.2))
                .foregroundColor(.white)
                .cornerRadius(10)
                .frame(maxWidth: .infinity,
                       alignment: chatMessage.userId != Auth.auth().currentUser?.uid
                       ? .leading
                       : .trailing)
        }
    }
}
