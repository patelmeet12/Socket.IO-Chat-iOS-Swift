//
//  ChatIncomingTextTableViewCell.swift
//  Socket.IO-iOS-Chat
//
//  Created by Apple iQlance on 19/10/2021.
//

import UIKit

class ChatIncomingTextTableViewCell: UITableViewCell {
    
    //MARK:-  Outlets and Variable Declarations
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        viewMessage.layoutIfNeeded()
        viewMessage.setCornerRaius(corners: [.topRight, .bottomLeft, .bottomRight], radious: 15)
    }
    
    //MARK:-  Buttons Clicked Action
    
    //MARK:-  Functions
    func configureCell(_ message: Message) {
        
        self.lblMessage.text = message.message ?? ""
        let time = message.date?.dateFromFormat("MM/dd/yyyy, h:mm:ss a")?.DateToString(dateFormat: "MMM d, h:mm a") ?? ""
        self.lblTime.text = time
    }
    
}
