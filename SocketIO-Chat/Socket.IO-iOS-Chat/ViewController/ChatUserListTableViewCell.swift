//
//  ChatUserListTableViewCell.swift
//  Socket.IO-iOS-Chat
//
//  Created by Apple iQlance on 19/10/2021.
//

import UIKit

class ChatUserListTableViewCell: UITableViewCell {
    
    //MARK:-  Outlets and Variable Declarations
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblNotificationCount: UILabel!
    @IBOutlet weak var lblOnlineStatus: UILabel!
    
    var onDidSelect: ((User) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:-  Layou setup
    func setUpLayout() {
        
        self.viewMain.setRadius()
        self.lblOnlineStatus.layer.masksToBounds = true
        self.lblOnlineStatus.clipsToBounds = true
        self.lblOnlineStatus.layer.cornerRadius = 3
    }
    
    func configureCell(_ user: User) {
        lblUsername.text = user.nickname ?? ""
        //lblOnlineStatus.isHidden = !(user.isConnected ?? false)
        lblOnlineStatus.textColor = !(user.isConnected ?? false) ? UIColor.green : UIColor.red
    }

}
