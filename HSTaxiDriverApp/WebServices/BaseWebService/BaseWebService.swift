//
//  BaseWebService.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 20/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
public typealias Parameters = [String: Any]

class BaseWebService: NSObject {
    // POST METHOD
    public func baseService(subURl: String, params: Parameters!, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        let BaseUrl = URL(string: demoBaseUrl+subURl)
        print("BASE URL : \(demoBaseUrl+subURl)")
        print("PARAMETER : \(params!)")
        if Utility().isConnectedToNetwork(){
            var header:HTTPHeaders? =  nil
            if(UserModel.shared.getAccessToken() != nil) {
                header = self.getHeaders()
            }

            //webservice call
            Alamofire.request(BaseUrl!, method:.post, parameters: params!, encoding: URLEncoding.httpBody, headers: header).responseJSON { response in
                //sucesss block
                let JSON = response.result.value as? NSDictionary
                switch response.result {
                case .success:
                    print("RESPONSE SUCCESS: \(JSON!)")
                    success(JSON!)
                    
                    if let status = JSON?.value(forKey: "status") as? NSString {
                        print("daddy:\(status)")
                        
                        if status == "error"{
                        
                            var message = "account_deleted"
                            if let delete_type = JSON?.value(forKey: "deleted_type") as? NSString{
                                if delete_type == "driver"{
                                    //message = "account_has_deleted"
                                }
                            }else{
                                
                                AJAlertController.initialization().showAlertWithOkButton(aStrMessage: message, status: "", completion: { (index, title) in
                                    
                                    print("here of 2")
                                    //remove badge count
                                    UIApplication.shared.applicationIconBadgeNumber = 0
                                    //remove all local datas
                                    UserDefaults.standard.removeObject(forKey: "user_id")
                                    UserDefaults.standard.removeObject(forKey: "user_dict")
                                    UserDefaults.standard.removeObject(forKey: "user_accessToken")
                                    UserDefaults.standard.removeObject(forKey: "user_profilepic")
                                    UserDefaults.standard.removeObject(forKey: "admin_approve")
                                    UserDefaults.standard.removeObject(forKey: "user_online")
                                    UserModel.shared.removeEmergencyContact()
                                    if #available(iOS 9.0, *) {
                                        let welcomeObj = WelcomePage()
                                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                        appDelegate.setInitialViewController(initialView: welcomeObj)
                                    }
                                })
                            }
                            
                        }
                        
                    }
                     
                    
                    
                    break
                case .failure(let error):
                    print("FAILURE RESPONSE: \(error.localizedDescription)")
                    HPLActivityHUD.dismiss()
                    if error._code == NSURLErrorTimedOut{
                        Utility.shared.showAlert(msg: "timed_out", status: "")
                    }else if error._code == NSURLErrorNotConnectedToInternet{
                        Utility.shared.goToOffline()
                    }else{
//                        Utility.shared.showAlert(msg: Utility.shared.getLanguage()?.value(forKey: "server_alert") as! String)
                    }
                }
            }
        }else{
            HPLActivityHUD.dismiss()
            Utility.shared.goToOffline()
        }
    }
    
    // GET METHOD
    public func getBaseService(subURl: String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        let BaseUrl = URL(string: demoBaseUrl+subURl)
        print("BASE URL : \(demoBaseUrl+subURl)")
        if Utility().isConnectedToNetwork(){
            var header:HTTPHeaders? =  nil
            if(UserModel.shared.getAccessToken() != nil) {
                header = self.getHeaders()
            }

            //webservice call
            Alamofire.request(BaseUrl!, method:.get, parameters: nil, encoding: URLEncoding.httpBody, headers: header).responseJSON { response in
                //sucesss block
                let JSON = response.result.value as? NSDictionary
                switch response.result {
                case .success:
                    print("RESPONSE SUCCESS: \(JSON!)")
                    success(JSON!)
                    

                    if let status = JSON?.value(forKey: "status") as? NSString {
                        //let status:NSString = JSON?.value(forKey: "status") as! NSString
                        print("daddy:\(status)")
                        
                        if status == "error"{
                            
                            //let message = Utility.shared.getLanguage()?.value(forKey: "account_deleted") as? String
                         let message = "account_deleted"
                            AJAlertController.initialization().showAlertWithOkButton(aStrMessage: message, status: "", completion: { (index, title) in
                                
                                //remove badge count
                                UIApplication.shared.applicationIconBadgeNumber = 0
                                //remove all local datas
                                UserDefaults.standard.removeObject(forKey: "user_id")
                                UserDefaults.standard.removeObject(forKey: "user_dict")
                                UserDefaults.standard.removeObject(forKey: "user_accessToken")
                                UserDefaults.standard.removeObject(forKey: "user_profilepic")
                                UserDefaults.standard.removeObject(forKey: "admin_approve")
                                UserDefaults.standard.removeObject(forKey: "user_online")
                                UserModel.shared.removeEmergencyContact()
                                if #available(iOS 9.0, *) {
                                    let welcomeObj = WelcomePage()
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    appDelegate.setInitialViewController(initialView: welcomeObj)
                                }
                            })
                        }
                        
                    }
                    
                    break
                case .failure(let error):
                    print("FAILURE RESPONSE: \(error.localizedDescription)")
                    HPLActivityHUD.dismiss()
                    if error._code == NSURLErrorTimedOut{
                        Utility.shared.showAlert(msg: "timed_out", status: "")
                    }else if error._code == NSURLErrorNotConnectedToInternet{
                        Utility.shared.goToOffline()
                    }else{
//                        Utility.shared.showAlert(msg: Utility.shared.getLanguage()?.value(forKey: "server_alert") as! String)
                    }
                }
            }
        }else{
            HPLActivityHUD.dismiss()
            Utility.shared.goToOffline()
        }
    }
    
    
    // DELETE  METHOD
    public func deleteMethod(subURl: String, params: Parameters!, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        let BaseUrl = URL(string: demoBaseUrl+subURl)
        print("BASE URL : \(demoBaseUrl+subURl)")
        print("PARAMETER : \(params!)")
        if Utility().isConnectedToNetwork(){
            var header:HTTPHeaders? =  nil
            if(UserModel.shared.getAccessToken() != nil) {
                header = self.getHeaders()
            }
            //webservice call
            Alamofire.request(BaseUrl!, method:.delete, parameters: params!, encoding: URLEncoding.httpBody, headers: header).responseJSON { response in
                //sucesss block
                let JSON = response.result.value as? NSDictionary
                switch response.result {
                case .success:
                    print("RESPONSE SUCCESS: \(JSON!)")
                    success(JSON!)
                    
                    /*
                    if let status = JSON?.value(forKey: "status") as? NSString {
                        //let status:NSString = JSON?.value(forKey: "status") as! NSString
                        print("daddy:\(status)")
                        
                        if status == "error"{
                            
                            //let message = Utility.shared.getLanguage()?.value(forKey: "account_deleted") as? String
                         let message = "account_deleted"
                            AJAlertController.initialization().showAlertWithOkButton(aStrMessage: message, status: "", completion: { (index, title) in
                     //remove badge count
                     UIApplication.shared.applicationIconBadgeNumber = 0
                     //remove all local datas
                     UserDefaults.standard.removeObject(forKey: "user_id")
                     UserDefaults.standard.removeObject(forKey: "user_dict")
                     UserDefaults.standard.removeObject(forKey: "user_accessToken")
                     UserDefaults.standard.removeObject(forKey: "user_profilepic")
                     UserDefaults.standard.removeObject(forKey: "admin_approve")
                     UserDefaults.standard.removeObject(forKey: "user_online")
                     UserModel.shared.removeEmergencyContact()
                     
                     if #available(iOS 9.0, *) {
                     let welcomeObj = WelcomePage()
                     let appDelegate = UIApplication.shared.delegate as! AppDelegate
                     appDelegate.setInitialViewController(initialView: welcomeObj)
                      }
                            })
                        }
                        
                    }
                     */
                    
                    
                    break
                case .failure(let error):
                    print("FAILURE RESPONSE: \(error.localizedDescription)")
                    HPLActivityHUD.dismiss()
                    if error._code == NSURLErrorTimedOut{
                        Utility.shared.showAlert(msg: "timed_out", status: "")
                    }else if error._code == NSURLErrorNotConnectedToInternet{
                        Utility.shared.goToOffline()
                    }else{
//                        Utility.shared.showAlert(msg: Utility.shared.getLanguage()?.value(forKey: "server_alert") as! String)
                    }
                }
            }
        }else{
            HPLActivityHUD.dismiss()
            Utility.shared.goToOffline()
        }
    }
    
    //MARK: http headers
    func getHeaders() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Authorization": UserModel.shared.getAccessToken()! as String,
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        return headers
    }
}

