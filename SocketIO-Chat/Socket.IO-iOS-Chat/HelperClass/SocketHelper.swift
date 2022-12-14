//
//  SocketHelper.swift
//  Socket.IO-iOS-Chat
//
//  Created by Apple iQlance on 07/10/2021.
//

import UIKit
import Foundation
import SocketIO

let kHost = "http://192.168.1.53:3001"
let kConnectUser = "connectUser"
let kUserList = "userList"
let kExitUser = "exitUser"

class SocketHelper: NSObject {
    
    static let shared = SocketHelper()
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    
    override init() {
        super.init()
        configureSocketClient()
    }
    
    private func configureSocketClient() {
        
        guard let url = URL(string: kHost) else {
            return
        }
        
        manager = SocketManager(socketURL: url, config: [.log(true), .compress])
        
        guard let manager = manager else {
            return
        }
        
        socket = manager.socket(forNamespace: "/chat")
    }
    
    func establishConnection() {
        
        guard let socket = manager?.defaultSocket else {
            return
        }
        
        socket.connect()
    }
    
    func closeConnection() {
        
        guard let socket = manager?.defaultSocket else {
            return
        }
        
        socket.disconnect()
    }
    
    func joinChatRoom(nickname: String, completion: () -> Void) {
        
        guard let socket = manager?.defaultSocket else {
            return
        }
        
        socket.emit(kConnectUser, nickname)
        completion()
    }
    
    func leaveChatRoom(nickname: String, completion: () -> Void) {
        
        guard let socket = manager?.defaultSocket else{
            return
        }
        
        socket.emit(kExitUser, nickname)
        completion()
    }
    
    func participantList(completion: @escaping (_ userList: [User]?) -> Void) {
        
        guard let socket = manager?.defaultSocket else {
            return
        }
        
        socket.on(kUserList) { [weak self] (result, ack) -> Void in
            
            guard result.count > 0,
                  let _ = self,
                  let user = result.first as? [[String: Any]],
                  let data = UIApplication.jsonData(from: user) else {
                return
            }
            
            do {
                let userModel = try JSONDecoder().decode([User].self, from: data)
                completion(userModel)
                
            } catch let error {
                print("Something happen wrong here...\(error)")
                completion(nil)
            }
            
            self?.listenForOtherMessages()
        }
    }
    
    func sendMessage(message: String, withNickname nickname: String) {
        
        guard let socket = manager?.defaultSocket else {
            return
        }
        
        socket.emit("chatMessage", nickname, message)
    }
    
    func getMessage(completion: @escaping (_ messageInfo: Message?) -> Void) {
        
        guard let socket = manager?.defaultSocket else {
            return
        }
        
        socket.on("newChatMessage") { (dataArray, socketAck) -> Void in
            
            var messageInfo = [String: Any]()
            
            guard let nickName = dataArray[0] as? String,
                  let message = dataArray[1] as? String,
                  let date = dataArray[2] as? String else{
                return
            }
            
            messageInfo["nickname"] = nickName
            messageInfo["message"] = message
            messageInfo["date"] = date
            
            guard let data = UIApplication.jsonData(from: messageInfo) else {
                return
            }
            
            do {
                let messageModel = try JSONDecoder().decode(Message.self, from: data)
                completion(messageModel)
                
            } catch let error {
                print("Something happen wrong here...\(error)")
                print("Something is Wrong !! Try Again...")
                completion(nil)
            }
        }
    }
    
    func listenForOtherMessages() {
        
        guard let socket = manager?.defaultSocket else {
            return
        }
        
        socket.on("userTypingUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userTypingNotification"), object: dataArray[0] as? [String: AnyObject])
        }
    }
    
    func startTypingMessage(nickname: String) {
        
        guard let socket = manager?.defaultSocket else {
            return
        }
        
        socket.emit("startType", nickname)
    }
    
    func stopTypingMessage(nickname: String) {
        
        guard let socket = manager?.defaultSocket else {
            return
        }
        
        socket.emit("stopType", nickname)
    }
    
}
