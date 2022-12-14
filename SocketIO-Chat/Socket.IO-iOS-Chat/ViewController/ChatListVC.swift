//
//  ChatListVC.swift
//  Socket.IO-iOS-Chat
//
//  Created by Apple iQlance on 07/10/2021.
//

import UIKit

class ChatListVC: UIViewController {
    
    var onDidSelect: ((User) -> Void)?
    
    //MARK:-  Outlets and Variable Declarations
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tblUserList: UITableView!
    @IBOutlet weak var btnLogout: UIButton!
    
    var isName : String?
    private var chatViewModel: ChatViewModel = ChatViewModel()

    //MARK:- 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initWithObjects()
        self.configureViewModel()
    }
    
    //MARK:-  Functions
    @objc private func initWithObjects() {
        //self.lblName.text = isName
        self.tblUserList.delegate = self
        self.tblUserList.dataSource = self
        self.btnLogout.setRadius()
    }
    
    private func configureViewModel() {
        
        guard let name = isName else {
            return
        }
        
        chatViewModel.arrUsers.subscribe {[weak self] (result: [User]) in
            
            guard let self = self else {
                return
            }
            
            self.tblUserList.reloadData()
        }
        
        chatViewModel.fetchParticipantList(name)
    }
    
    //MARK:-  Buttons Clicked Action
    @IBAction func btnBackClicked(_ sender: UIButton) {
        guard let name = isName else {
            return
        }
        
        SocketHelper.shared.leaveChatRoom(nickname: name) { [weak self] in
            guard let self = self else {
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnLogoutClicked(_ sender: UIButton) {
        let confirmationAlert = UIAlertController(title: kAppName, message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        
        confirmationAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            guard let name = self.isName else {
                return
            }
            
            SocketHelper.shared.leaveChatRoom(nickname: name) { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.navigationController?.popViewController(animated: true)
            }
        }))
        
        confirmationAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(confirmationAlert, animated: true, completion: nil)
    }
    
}

//MARK:-  UITableViewDataSource Methods
extension ChatListVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatViewModel.arrUsers.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatUserListTableViewCell") as! ChatUserListTableViewCell
        
        let user: User = chatViewModel.arrUsers.value[indexPath.row]
        cell.configureCell(user)
        
        return cell
    }
}

//MARK:-  UITableViewDelegate Methods
extension ChatListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user: User = chatViewModel.arrUsers.value[indexPath.row]
        onDidSelect?(user)
        print("UserChat ->", user)
        
        let chatVC = storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        chatVC.user = user
        chatVC.isName = self.isName ?? ""
        chatVC.userID = user.id ?? ""
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}
