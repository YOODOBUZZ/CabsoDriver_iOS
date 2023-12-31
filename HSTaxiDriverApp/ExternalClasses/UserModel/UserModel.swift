//
//  UserModel.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 10/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    static let shared = UserModel()
    static let userDetails = UserModel().getUserDetails()
    static let admin = UserModel().getAdmin()
    var LANGUAGE_CODE = "en"

    //MARK: store & get user accesstoken
    func setAppLanguage(Language: String){
        UserDefaults.standard.set(Language, forKey: "language_name")
    }
    func getAppLanguage() -> String? {
        return UserDefaults.standard.value(forKey: "language_name") as? String
    }
    
    //MARK: store & get user details
    func setUserModels(userDict: NSDictionary){
        UserDefaults.standard.set(userDict, forKey: "user_dict")
    }
    func getUserDetails() -> NSDictionary {
        return (UserDefaults.standard.value(forKey: "user_dict") as? NSDictionary)!
    }
    
    //MARK: logout user
    func logoutUser(){
        //signout from pushnotification
        let pushObj = UserServices()
        pushObj.pushSignoutService(onSuccess: {response in
        })
        //go offline 
        pushObj.goOnline(status: "offline", onSuccess: {response in
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_FALSE){
                UserModel.shared.setUserOnlineStatus(userID: "offline")
            }
        })
        //remove badge count
        UIApplication.shared.applicationIconBadgeNumber = 0
        //remove all local datas
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.removeObject(forKey: "user_dict")
        UserDefaults.standard.removeObject(forKey: "user_accessToken")
        UserDefaults.standard.removeObject(forKey: "user_profilepic")
        UserDefaults.standard.removeObject(forKey: "admin_approve")
        UserDefaults.standard.removeObject(forKey: "user_online")
        self.removeEmergencyContact()
        
        if #available(iOS 9.0, *) {
            let welcomeObj = WelcomePage()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.setInitialViewController(initialView: welcomeObj)
        }
    }
    
    
    //MARK: Delete user
    func DeleteUser(){
        //signout from pushnotification
        let pushObj = UserServices()
        pushObj.pushSignoutService(onSuccess: {response in
        })
        //go offline
        pushObj.goOnline(status: "offline", onSuccess: {response in
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_FALSE){
                UserModel.shared.setUserOnlineStatus(userID: "offline")
            }
            else if status == "error"{
                print("here of 1")
                UserModel.shared.setUserOnlineStatus(userID: "offline")
            }
        })
        

        //remove badge count
        UIApplication.shared.applicationIconBadgeNumber = 0
        //remove all local datas
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.removeObject(forKey: "user_dict")
        UserDefaults.standard.removeObject(forKey: "user_accessToken")
        UserDefaults.standard.removeObject(forKey: "user_profilepic")
        UserDefaults.standard.removeObject(forKey: "admin_approve")
        UserDefaults.standard.removeObject(forKey: "user_online")
        self.removeEmergencyContact()
        
    }
    
    
    
    
    
    //MARK: store & get user id
    func setUserID(userID: NSString){
        UserDefaults.standard.set(userID, forKey: "user_id")
    }
    func userID() -> NSString? {
        return UserDefaults.standard.value(forKey: "user_id") as? NSString
    }
    
    //MARK: store & get user onlinestatus
    func setUserOnlineStatus(userID: NSString){
        UserDefaults.standard.set(userID, forKey: "user_online")
    }
    func onlineStatus() -> NSString? {
        return UserDefaults.standard.value(forKey: "user_online") as? NSString
    }
    
    //MARK: store & get user accesstoken
    func setAccessToken(userToken: NSString){
        UserDefaults.standard.set(userToken, forKey: "user_accessToken")
    }
    func getAccessToken() -> NSString? {
        return UserDefaults.standard.value(forKey: "user_accessToken") as? NSString
    }
    
    //MARK: store & get user password
    func setPassword(password: NSString){
        UserDefaults.standard.set(password, forKey: "user_password")
    }
    func getPassword() -> NSString? {
        return UserDefaults.standard.value(forKey: "user_password") as? NSString
    }
    
    //MARK: store & get & delete emergency contact
    func setEmergencyContact(contactArray: NSArray){
        UserDefaults.standard.set(contactArray, forKey: "user_emergencyContact")
    }
    func getEmergenctContact() -> NSArray? {
        return UserDefaults.standard.value(forKey: "user_emergencyContact") as? NSArray
    }
    func removeEmergencyContact()  {
        UserDefaults.standard.removeObject(forKey: "user_emergencyContact")
    }
    
    //MARK: store & get profile pic
    func setProfilePic(URL: NSString){
        UserDefaults.standard.set(URL, forKey: "user_profilepic")
    }
    func getProfilePic() -> NSString? {
        return UserDefaults.standard.value(forKey: "user_profilepic") as? NSString
    }
    
    //MARK: store & get fcm notification token
    func setFCMToken(fcm_token: NSString){
        UserDefaults.standard.set(fcm_token, forKey: "fcm_token")
    }
    func getFCMToken() -> NSString? {
        return UserDefaults.standard.value(forKey: "fcm_token") as? NSString
    }
    //MARK: store & get VOIP notification token
    func setVOIPToken(voip_token: NSString){
        UserDefaults.standard.set(voip_token, forKey: "voip_token")
    }
    func getVOIPToken() -> NSString? {
        return UserDefaults.standard.value(forKey: "voip_token") as? NSString
    }
    //MARK: set user info
    func setUserInfo(userDict:NSDictionary)  {
        UserModel.shared.setUserModels(userDict: userDict)
        UserModel.shared.setUserID(userID: userDict.value(forKey: "user_id") as! String as NSString)
        UserModel.shared.setAccessToken(userToken: userDict.value(forKey: "token") as! String as NSString)
        UserModel.shared.setPassword(password:userDict.value(forKey: "password") as! String as NSString )
        if ((userDict["emergency_contact"]) != nil) {
            UserModel.shared.setEmergencyContact(contactArray: userDict.value(forKey: "emergency_contact") as! NSArray)
        }
    }
    
    //MARK: store & get profile pic
    func setAdminData(adminDict: NSDictionary){
        BANNER_AD_ENABLED = adminDict.value(forKey: "admin_enable_ads") as? Bool ?? BANNER_AD_ENABLED
        AD_UNIT_ID = adminDict.value(forKey: "ad_unit_id") as? String ?? AD_UNIT_ID
        UserDefaults.standard.set(adminDict, forKey: "admin_data")
        UserDefaults.standard.set(adminDict.value(forKey: "currencysymbol"), forKey: "default_currency")
        UserDefaults.standard.set(adminDict.value(forKey: "emergencycontact"), forKey: "sos_policeNo")
    }
    func getAdmin() -> NSDictionary {
        return (UserDefaults.standard.value(forKey: "admin_data") as? NSDictionary)!
    }
    
    //MARK: store & get approve details
    func setApproveDict(adminDict: NSDictionary){
        UserDefaults.standard.set(adminDict, forKey: "admin_approve")
    }
    func getApprove() -> NSDictionary {
        return (UserDefaults.standard.value(forKey: "admin_approve") as? NSDictionary)!
    }
    
    //MARK: store & get current lat , lng details
    func setLocation(lat: String, lng:String){
        UserDefaults.standard.set(lat, forKey: "my_lat")
        UserDefaults.standard.set(lng, forKey: "my_lng")
    }
    
    func latitude() -> NSString {
        return (UserDefaults.standard.value(forKey: "my_lat") as? NSString)!
    }
    func longitude() -> NSString {
        return (UserDefaults.standard.value(forKey: "my_lng") as? NSString)!
    }
}
