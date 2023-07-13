//
//  UploadServices.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 29/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import Alamofire

class UploadServices: BaseWebService {

    //MARK: upload profile pic service
    public func uploadProfilePic(profileimage:Data, onSuccess success: @escaping (NSDictionary) -> Void) {
        let BaseUrl = URL(string: demoBaseUrl+PROFILE_PIC_API)
        print("BASE URL : \(demoBaseUrl+PROFILE_PIC_API)")
        let parameters = ["user_id": UserModel.shared.userID()!]
        print("REQUEST : \(parameters)")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(profileimage, withName: "driverImage", fileName: "profilepic.jpeg", mimeType: "image/jpeg")
            for (key, value) in parameters {
                multipartFormData.append((value.data(using: String.Encoding.utf8.rawValue)!), withName: key)
            }
        }, to:BaseUrl!,method:.post,headers:self.getHeaders())
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                })
                upload.responseJSON { response in
                    let JSON = response.result.value as? NSDictionary
                    print("RESPONSE \(response)")
                    success(JSON!)
                }
            case .failure(let error):
                print("FAILURE RESPONSE: \(error.localizedDescription)")
                HPLActivityHUD.dismiss()
                if error._code == NSURLErrorTimedOut{
                    Utility.shared.showAlert(msg: "timed_out", status: "")
                }else if error._code == NSURLErrorNotConnectedToInternet{
                    Utility.shared.goToOffline()
                }else{
//                    Utility.shared.showAlert(msg: Utility.shared.getLanguage()?.value(forKey: "server_alert") as! String)
                }
            }
        }
    }
    //MARK: upload driver document like license,rcbook,insurance
    public func uploadDoc(fileData:Data,uploaddocfor:String,uploaddoctype:String,fileName:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let BaseUrl = URL(string: demoBaseUrl+UPLOAD_DOC)
        print("BASE URL : \(demoBaseUrl+UPLOAD_DOC)")
        let parameters = ["user_id": UserModel.shared.userID()!,"uploaddocfor":uploaddocfor] as [String : Any]

        print("REQUEST : \(parameters)")
        print("data\(fileData)")
        var mime_type = String()
        if uploaddoctype == ".jpeg" {
            mime_type = "image/jpeg"
        }else{
            mime_type = "application/pdf"
        }
        print("FILE NAME \(fileName), MIME_TYPE \(mime_type)")
        print("TOKEN \(String(describing: UserModel.shared.getAccessToken()))")
    
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(fileData, withName: "uploaddoc", fileName:fileName, mimeType: mime_type)
            for (key, value) in parameters {
                multipartFormData.append(((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key)
            }
        }, to:BaseUrl!,method:.post,headers:self.getHeaders())
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                })
                upload.responseJSON { response in
                    let JSON = response.result.value as? NSDictionary
                    print("RESPONSE \(response)")
                    success(JSON!)
                }
            case .failure(let error):
                print("FAILURE RESPONSE: \(error.localizedDescription)")
                HPLActivityHUD.dismiss()
                if error._code == NSURLErrorTimedOut{
                    Utility.shared.showAlert(msg: "timed_out", status: "")
                }else if error._code == NSURLErrorNotConnectedToInternet{
                    Utility.shared.goToOffline()
                }else{
//                    Utility.shared.showAlert(msg: Utility.shared.getLanguage()?.value(forKey: "server_alert") as! String)
                }
            }
        }
    }
}
