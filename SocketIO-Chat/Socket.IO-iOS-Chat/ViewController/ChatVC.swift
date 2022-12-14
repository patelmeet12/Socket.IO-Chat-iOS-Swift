//
//  ChatVC.swift
//  Socket.IO-iOS-Chat
//
//  Created by Apple iQlance on 19/10/2021.
//

import UIKit

class ChatVC: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    //MARK:-  Outlets and Variable Declarations
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var viewSendMessageBottom: NSLayoutConstraint!
    @IBOutlet weak var lblTyping: UILabel!
    
    var isName = String()
    var user: User?
    private var messageViewModel: MessageViewModel = MessageViewModel()
    var userID = String()

    //MARK:- 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initWithObjects()
        configureViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblTyping.isHidden = true
        lblTyping.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    //MARK:-  Functions
    @objc private func initWithObjects() {
        
        self.txtMessage.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserTypingNotification(notification:)), name: Notification.Name("userTypingNotification"), object: nil)
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipeGestureRecognizer.direction = UISwipeGestureRecognizer.Direction.down
        swipeGestureRecognizer.delegate = self
        view.addGestureRecognizer(swipeGestureRecognizer)
        
        self.viewMessage.setRadius()
        self.lblUserName.text = user?.nickname
        self.tblChat.delegate = self
        self.tblChat.dataSource = self
        
//        SocketHelper.shared.getMessage { message in
//            print("Message =>", message ?? "")
//        }
//        SocketHelper.shared.getMessage(completion: { (messageInfo) -> Void in
//            DispatchQueue.main.async {
//                self.messageViewModel.arrMessage.value.append(messageInfo ?? Message())
//                self.tblChat.reloadData()
//                print("Message =>", messageInfo as Any)
//            }
//        })
    }
    
    private func configureViewModel() {
        
        messageViewModel.arrMessage.subscribe { [weak self] (result: [Message]) in
            
            guard let self = self else {
                return
            }
            
            self.tblChat.reloadData()
            self.tblChat.scrollToBottom(animated: false)
        }
        
        messageViewModel.getMessagesFromServer()
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        
        if let userInfo = (sender as NSNotification).userInfo {
            if let _ = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                self.viewSendMessageBottom.constant =  0
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        
        if let userInfo = (sender as NSNotification).userInfo {
            if let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                self.view.layoutIfNeeded()
                if #available(iOS 11.0, *) {
                    self.viewSendMessageBottom.constant = (keyboardHeight - (APPDEL.window?.safeAreaInsets.bottom ?? 0) - 0)
                    DispatchQueue.main.async {
                        self.reloadTable()
                    }
                } else {
                    self.viewSendMessageBottom.constant = (keyboardHeight - 0)
                    //tblChat.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                }
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    private func reloadTable() {
        
        self.tblChat.reloadData()
        if self.messageViewModel.arrMessage.value.count > 0 {
            self.tblChat.scrollToRow(at: IndexPath(row: messageViewModel.arrMessage.value.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    @objc func handleUserTypingNotification(notification: NSNotification) {
        
        if let typingUsersDictionary = notification.object as? [String: AnyObject] {
            var names = ""
            var totalTypingUsers = 0
            for (typingUser, _) in typingUsersDictionary {
                if typingUser != isName {
                    names = (names == "") ? typingUser : "\(names), \(typingUser)"
                    totalTypingUsers += 1
                }
            }
     
            if totalTypingUsers > 0 {
                let verb = (totalTypingUsers == 1) ? "is" : "are"
                
                lblTyping.isHidden = false
                lblTyping.text = "\(names) \(verb) now typing a message..."
            } else {
                lblTyping.isHidden = true
            }
        }
    }
    
    @objc func dismissKeyboard() {
        if txtMessage.isFirstResponder {
            txtMessage.resignFirstResponder()
            
            SocketHelper.shared.stopTypingMessage(nickname: isName)
        }
    }
    
    //MARK:-  UITextViewDelegate Methods
    private func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        SocketHelper.shared.startTypingMessage(nickname: isName)
        return true
    }
    
    //MARK:-  UIGestureRecognizerDelegate Methods
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //MARK:-  Buttons Clicked Action
    @IBAction func btnBackClicked(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSendClicked(_ sender: UIButton) {
        
        if !(txtMessage.isempty()) {
            let message = txtMessage.text ?? ""
            let name = isName
            
            txtMessage.resignFirstResponder()
            SocketHelper.shared.sendMessage(message: message, withNickname: name)
            txtMessage.text = nil
        } else {
            showAlertWithOkButton(message: "Please type your message.")
        }
    }
    
}

//MARK:-  UITableViewDelegate Methods
extension ChatVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

//MARK:-  UITableViewDataSource Methods
extension ChatVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageViewModel.arrMessage.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message: Message = messageViewModel.arrMessage.value[indexPath.row]
        
        if message.nickname == isName {
            //Outgoing
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatOutgoingTextTableViewCell") as! ChatOutgoingTextTableViewCell
            
            cell.configureCell(message)
            
            return cell
        } else {
            //Incoming
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatIncomingTextTableViewCell") as! ChatIncomingTextTableViewCell
            
            cell.configureCell(message)
            
            return cell
        }
    }
}
