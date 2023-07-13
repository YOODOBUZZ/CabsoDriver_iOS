//
//  Utility.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 09/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import SystemConfiguration

class Utility: NSObject {
    
    static let shared = Utility()
    static let language = Utility().getLanguage()
    
    //MARK: Configure app language
    func configureLanguage()  {
        if let path = Bundle.main.path(forResource:UserModel.shared.getAppLanguage(), ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                self.setDefaultLanguage(languageDict: jsonResult as! NSDictionary)
            } catch {
                // handle error
            }
        }
    }
    //MARK: Show normal alertview
    func showAlert(msg:String, status: String)  {
        AJAlertController.initialization().showAlertWithOkButton(aStrMessage: msg, status: status, completion: { (index, title) in
            
        })
    }
    
    
    //MARK: Network rechability
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        return ret
    }
    //MARK: Convert string to dict
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    //get random number
    func random() -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< 10 {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        let userData = UserModel.shared.userID()
        return "\(userData as String? ?? "")\(randomString)"
    }
    //convert timestamp with required format
    func timeStamp(stamp:Double,format:String) -> String {
        let dateNew = Date(timeIntervalSince1970:stamp)
        let dateFormat = DateFormatter()
        dateFormat.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        if UserModel.shared.getAppLanguage() == "Arabic" {
                dateFormat.locale = NSLocale.init(localeIdentifier: "ar_DZ") as Locale
        }else{
                dateFormat.locale = NSLocale.current
        }
        dateFormat.dateFormat = format
        return dateFormat.string(from: dateNew)
    }
    //MARK: Convert string to double

    func convertToDouble(string:String) -> Double {
        let doubleValue = Double()
        if let distance = Double(string) {
            print(distance)
            return distance
        } else {
            print("Not a valid string for conversion")
        }
        return doubleValue
    }
    //MARK: date format
    func formattedDate(date:String) -> String {
        //iso format
        let format = ISO8601DateFormatter()
        var newDate = NSDate()
        let trimmedIsoString = date.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        newDate = format.date(from: trimmedIsoString)! as NSDate
        
        //new format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy"
        return dateFormatter.string(from:newDate as Date)
    }
    //MARK:set App language
    func setDefaultLanguage(languageDict: NSDictionary){
        UserDefaults.standard.set(languageDict, forKey: "app_language")
    }
    func getLanguage() -> NSDictionary? {
        return UserDefaults.standard.value(forKey: "app_language") as? NSDictionary
    }
    
    //MARK: move to home page
    func goToHomePage()  {
        if #available(iOS 9.0, *) {
            let homeObj = menuContainerPage()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.setInitialViewController(initialView: homeObj)
        }
    }
    //MARK: move to offline
    func goToOffline()  {
        let offLineViewObj = OfflinePage()
        offLineViewObj.modalPresentationStyle = .fullScreen
        UIApplication.shared.keyWindow?.rootViewController?.present(offLineViewObj, animated: false, completion: nil)
    }
    //regisert for push services
    func registerPushServices()  {
        let pushObj = UserServices()
        pushObj.registerForNotification(onSuccess: {response in
        })
    }
    
    //MARK: OS compatilbity Check
    func SYSTEM_VERSION_EQUAL_TO(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version,
                                                      options: NSString.CompareOptions.numeric) == ComparisonResult.orderedSame
    }
    
    func SYSTEM_VERSION_GREATER_THAN(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version,
                                                      options: NSString.CompareOptions.numeric) == ComparisonResult.orderedDescending
    }
    
    func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version,
                                                      options: NSString.CompareOptions.numeric) != ComparisonResult.orderedAscending
    }
    
    func SYSTEM_VERSION_LESS_THAN(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version,
                                                      options: NSString.CompareOptions.numeric) == ComparisonResult.orderedAscending
    }
    
    func SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version,
                                                      options: NSString.CompareOptions.numeric) != ComparisonResult.orderedDescending
    }
    
    
    func checkApprovedStatus()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        print("rsponse \(UserModel.shared.getApprove())")
        if UserModel.shared.getApprove().value(forKey:"vehicle_details") as! String == "InComplete" || UserModel.shared.getApprove().value(forKey:"payment_details") as! String == "InComplete" || UserModel.shared.getApprove().value(forKey:"vehicle_inspection") as! String == "InComplete" || UserModel.shared.getApprove().value(forKey:"security_deposit") as! String == "InComplete" || UserModel.shared.getApprove().value(forKey:"vehicle_approval") as! String == "pending" || UserModel.shared.getApprove().value(forKey:"vehicle_approval") as! String == "rejected"{
            appDelegate.setInitialViewController(initialView: SignupValidationPage())
        }else{
            appDelegate.setInitialViewController(initialView: menuContainerPage())
        }
    }
    
    //MARK: get profile information
    func getStatusService()  {
        let signinServiceObj = LoginWebServices()
        let phoneNo = UserModel.shared.getUserDetails().value(forKey: "phone_number") as? String ?? "\(UserModel.shared.getUserDetails().value(forKey: "phone_number") as? NSNumber ?? 0)"
        print(phoneNo)

        signinServiceObj.signInService(email:  UserModel.shared.getUserDetails().value(forKey: "email") as! String, password: UserModel.shared.getPassword()! as String,country_code:UserModel.shared.getUserDetails().value(forKey: "country_code") as! String,phone_no:phoneNo,type:"withphone",onSuccess: {response in
            HPLActivityHUD.dismiss()
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                UserModel.shared.removeEmergencyContact()
                UserModel.shared.setUserInfo(userDict: response)
                UserModel.shared.setApproveDict(adminDict: response)
                Utility.shared.checkApprovedStatus()
            }else{
            }
        })
    }
    
    //MARK: admin data sevice
    func fetchAdminData()  {
        let loginServiceObj = LoginWebServices()
        loginServiceObj.getAdminData(onSuccess: {response in
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                UserModel.shared.setAdminData(adminDict: response)
            }
        })
    }
    
    //MARK: get currency
    func currency() -> String {
        return UserDefaults.standard.value(forKey: "default_currency") as! String
    }
    //MARK: get police no
    func policeNo() -> NSString? {
        return UserDefaults.standard.value(forKey: "sos_policeNo") as? NSString
    }
    
    //MARK: Get Bar Chart Max value
    func rangeMax(max:CGFloat) -> CGFloat! {
        if max < 10 {
            return 10
        }else if max < 20 {
            return 20
        }else if max < 25 {
            return 25
        }else if max < 50{
            return 50
        }else if max < 75{
            return 75
        }else if max < 100{
            return 100
        }else{
            return max
        }
        return max
    }
    
    func distanceString(for distance: Double) -> Double {
        let distanceMeters = Measurement(value: distance, unit: UnitLength.kilometers)
        let distanceMiles = distanceMeters.converted(to: UnitLength.miles)
        let miles = distanceMeters.converted(to: UnitLength.miles).value
        return miles
    }
    
    func removeSuffic(_ getDistance: String, _ changeString: String) -> String{
        if getDistance.hasSuffix(changeString) {
            let name = getDistance.prefix(getDistance.count - changeString.count)
            print(name)
            return String(name)
        }
        return getDistance
    }
}

extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
