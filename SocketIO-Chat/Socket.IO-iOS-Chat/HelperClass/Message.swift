//
//  Message.swift
//  Socket.IO-iOS-Chat
//
//  Created by Apple iQlance on 07/10/2021.
//

import Foundation

struct Message: Codable {
    
    var date: String?
    var message: String?
    var nickname: String?
}
