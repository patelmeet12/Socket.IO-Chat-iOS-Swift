//
//  MessageViewModel.swift
//  Socket.IO-iOS-Chat
//
//  Created by Apple iQlance on 19/10/2021.
//

import Foundation

final class MessageViewModel {
    
    var arrMessage: KxSwift<[Message]> = KxSwift<[Message]>([])
    
    func getMessagesFromServer() {
        
        SocketHelper.shared.getMessage { [weak self] (message: Message?) in
            
            guard let self = self,
                  let msgInfo = message else {
                return
            }
            
            self.arrMessage.value.append(msgInfo)
        }
    }
}
