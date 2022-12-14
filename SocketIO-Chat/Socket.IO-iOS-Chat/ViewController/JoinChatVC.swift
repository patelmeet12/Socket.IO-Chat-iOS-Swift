//
//  JoinChatVC.swift
//  Socket.IO-iOS-Chat
//
//  Created by Apple iQlance on 07/10/2021.
//

import UIKit

class JoinChatVC: UIViewController {
    
    //MARK:-  Outlets and Variable Declarations
    @IBOutlet weak var txtNickName: UITextField!
    @IBOutlet weak var btnJoinChat: UIButton!
    
    //MARK:- 
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
    }
    
    //MARK:-  Layou setup
    func setUpLayout() {
        
        self.txtNickName.setRadius()
        self.btnJoinChat.setRadius()
    }
    
    //MARK:-  Buttons Clicked Action
    @IBAction func btnJoinChatClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if !(txtNickName.isempty()) {
            
            SocketHelper.shared.joinChatRoom(nickname: txtNickName.text?.trime() ?? "") { [weak self] in
                
                guard let nickName = txtNickName.text?.trime(),
                      let self = self else {
                    return
                }
                //isLoggedIn = true //Login is completed, When app is reopen this variable will be check for set rootviewcontroller
                
                let chatListVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatListVC") as! ChatListVC
                chatListVC.isName = nickName
                self.navigationController?.pushViewController(chatListVC, animated: true)
            }
            // Send Notification
        } else {
            showAlertWithOkButton(message: "Please enter nickname")
        }
        // Clear TextView
        txtNickName.text = ""
    }
    
    //MARK:-  Functions
    
}
