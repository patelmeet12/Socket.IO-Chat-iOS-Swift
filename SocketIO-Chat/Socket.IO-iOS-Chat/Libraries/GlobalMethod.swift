//
//  GlobalMethod.swift
//  Socket.IO-iOS-Chat
//
//  Created by Apple iQlance on 07/10/2021.
//

import UIKit
import Foundation

//MARK:-  APP LEVEL CONSTANT
let userdef = UserDefaults.standard
let APPDEL = UIApplication.shared.delegate as! AppDelegate
let APPFIRST = UIApplication.shared.windows.first
let kAppName = "Socket IO Chat"

struct USERDEFAULTS {
    public static let isWalkthroughCompleted = "isWalkthroughCompleted"
    public static let isLoggedIn = "isLoggedIn"
    public static let currentUser = "currentUser"
}

struct StoryBoard {
    public static let landing = UIStoryboard(name: "Main", bundle: nil)
}

struct LoginType {
    static let google: String = "google"
    static let facebook: String = "facebook"
    static let apple: String = "apple"
}

extension UITextField {
    
    func isempty() -> Bool {
        return (self.text ?? "").trime().isEmpty
    }
}

extension String {
    
    func trime() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    func toInt() -> Int? {
        return NumberFormatter().number(from: self)?.intValue
    }
    
    func toBool() -> Bool? {
        let lowercaseSelf = self.lowercased()
        
        switch lowercaseSelf {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
    //MARK:-  Parse into NSDate
    func dateFromFormat(_ format: String) -> Date? {
        
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.calendar = Calendar.autoupdatingCurrent
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}

extension Date {
    
    func DateToString(dateFormat format  : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension Int {
    func toString() -> String {
        let myString = String(self)
        return myString
    }
}

extension Double{
    func DtoString() -> String {
        let myString = String(self)
        return myString
    }
}

extension UIViewController {
    
    func showAlertWithOkButton(message : String) {
        let alert = UIAlertController(title: kAppName, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(OKAction)
        
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
}

extension UIView {
    
    func setRadius(){
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
    }
    
    func setCornerRaius(corners: UIRectCorner, radious: CGFloat) {
        
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radious, height: radious))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

//below variables used for set rootviewcontrollers
var isWalkthroughCompleted: Bool {
    get {
        return userdef.bool(forKey: USERDEFAULTS.isWalkthroughCompleted)
    }
    set {
        userdef.set(newValue, forKey: USERDEFAULTS.isWalkthroughCompleted)
    }
}

var isLoggedIn: Bool {
    get {
        return userdef.bool(forKey: USERDEFAULTS.isLoggedIn)
    }
    set {
        userdef.set(newValue, forKey: USERDEFAULTS.isLoggedIn)
    }
}
