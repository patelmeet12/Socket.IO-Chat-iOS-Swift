//
//  User.swift
//  Socket.IO-iOS-Chat
//
//  Created by Apple iQlance on 07/10/2021.
//

import UIKit
import Foundation

struct User: Codable {
    
    var id: String?
    var isConnected: Bool?
    var nickname: String?
}
