//
//  UserServices.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 24/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class UserServices: BaseWebService {
    //MARK: get profile service
    public func getProfileInfo(onSuccess success: @escaping (NSDictionary) -> Void) {
        self.getBaseService(subURl: ("\(PROFILE_API)/\(UserModel.shared.userID()!)"), onSuccess: {response in
            success(response)
        },onFailure: {errorResponse in
        })
    }
    
    //MARK: get user dashboard details service
    public func getDashboardDetails(onSuccess success: @escaping (NSDictionary) -> Void) {
        self.getBaseService(subURl: ("\(DASHBOARD_API)/\(UserModel.shared.userID()!)"), onSuccess: {response in
            success(response)
        },onFailure: {errorResponse in
        })
    }
    //MARK: notification service
    public func getNotifications(onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        self.getBaseService(subURl: ("\(NOTIFICATION_API)/\(UserModel.shared.userID()!)"), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //MARK: edit phone number service
    public func updatePhoneNumber(country_code:String,phone_no:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(country_code, forKey: "country_code")
        requestDict.setValue(phone_no, forKey: "phone_number")
        self.baseService(subURl: UPDATE_PROFILE_API, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    //MARK: Go live service
    public func goOnline(status:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(status, forKey: "status")
        self.baseService(subURl: GO_LIVE_API, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    
    //MARK: update name service
    public func updateName(name:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(name, forKey: "full_name")
        self.baseService(subURl: UPDATE_PROFILE_API, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    //MARK: update signup agreement service
    public func updateAgreement(type:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue("Complete", forKey: type)
        self.baseService(subURl: UPDATE_PROFILE_API, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    //change password service
    public func changePassword(new_password:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(new_password, forKey: "newpassword")
        self.baseService(subURl: CHANGE_PASSWORD_API, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    //RESET password service
    public func resetPassword(email:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(email, forKey: "email")
        self.baseService(subURl: RESET_PASSWORD_API, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    // ADD,EDIT,DELETE emergency contact
    public func updateEmergecyContact(emergencyContact:NSArray, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(self.json(from: emergencyContact), forKey: "emergency_contact")
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        self.baseService(subURl: UPDATE_PROFILE_API, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    // Contact submit querty
    public func contactUs(name:String,email:String,subject:String,message:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(name, forKey: "name")
        requestDict.setValue(subject, forKey: "subject")
        requestDict.setValue(message, forKey: "message")
        requestDict.setValue(email, forKey: "email")
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        self.baseService(subURl: CONTACT_API, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    //update vehicle details
    func updateVehicleDetails(vehicleName:String,noOfSeats:String,bodyType:String,amenities:NSArray,vehicleNo:String,licenceNo:String,licenceDate:String,insuranceNo:String,insruanceDate:String,rcNo:String,rcDate:String, onSuccess success: @escaping (NSDictionary) -> Void)  {
        let requestDict = NSMutableDictionary.init()
        
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(vehicleName, forKey: "vehicle_name")
        requestDict.setValue(noOfSeats, forKey: "available_seats")
        requestDict.setValue(bodyType, forKey: "body_type")
        requestDict.setValue(self.json(from: amenities), forKey: "amenities")
        requestDict.setValue(vehicleNo, forKey: "vehicle_number")
        requestDict.setValue(licenceNo, forKey: "licence_no")
        requestDict.setValue(licenceDate, forKey: "licence_date")
        requestDict.setValue(insuranceNo, forKey: "insurance_no")
        requestDict.setValue(insruanceDate, forKey: "insurance_date")
        requestDict.setValue(rcNo, forKey: "book_no")
        requestDict.setValue(rcDate, forKey: "book_date")
        requestDict.setValue("Complete", forKey: "vehicle_details")

        self.baseService(subURl: POST_VEHICLE_API, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    //MARK: get vehicle details service
    public func getVehicleInfo(onSuccess success: @escaping (NSDictionary) -> Void) {
        self.getBaseService(subURl: ("\(GET_VEHICLE_API)/\(UserModel.shared.userID()!)"), onSuccess: {response in
            success(response)
        },onFailure: {errorResponse in
        })
    }
    //MARK: get payment details service
    public func getPaymentInfo(onSuccess success: @escaping (NSDictionary) -> Void) {
        self.getBaseService(subURl: ("\(GET_PAYMENT_API)/\(UserModel.shared.userID()!)"), onSuccess: {response in
            success(response)
        },onFailure: {errorResponse in
        })
    }
    
    //update payment service
    public func updatePaymentDetails(type:String,routing_no:String,bank_ac:String,name:String,address:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(type, forKey: "type")
        if type == "bankaccount" {
            requestDict.setValue(routing_no, forKey: "routing_no")
            requestDict.setValue(bank_ac, forKey: "bank_ac")
            requestDict.setValue(name, forKey: "name")
            requestDict.setValue(address, forKey: "address")
        }
        self.baseService(subURl: UPDATE_PAYMENT_API, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    //register for push services
    public func registerForNotification(onSuccess success: @escaping (NSDictionary) -> Void) {
        // Prepare params
        let requestDict = NSMutableDictionary.init()
        
        print(UserModel.shared.getFCMToken()!)
    requestDict.setValue(UIDevice.current.identifierForVendor!.uuidString, forKey: "device_id")
        requestDict.setValue("0", forKey: "device_type")
        requestDict.setValue(UserModel.shared.getFCMToken()! as String, forKey: "device_token")
        requestDict.setValue(UserModel.shared.LANGUAGE_CODE, forKey: "lang_type")
        requestDict.setValue(UserModel.shared.getVOIPToken() as String? ?? "", forKey: "voip_token")
        requestDict.setValue(DEVICE_MODE, forKey: "device_mode")
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        print("user id\(UserModel.shared.userID() ?? EMPTY_STRING as NSString)")
        //make base method call
        self.baseService(subURl: PUSH_SIGNIN_API, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    //unregister for notification
    public func pushSignoutService(onSuccess success: @escaping (NSDictionary) -> Void) {
        // Prepare params
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UIDevice.current.identifierForVendor!.uuidString, forKey: "device_id")
        //make base method call
        self.deleteMethod(subURl: PUSH_SIGNOUT_API, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            
        })
    }
    
    
    public func deleteAccountService(onSuccess success: @escaping (NSDictionary) -> Void) {
        // Prepare params
        
        
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        
        self.baseService(subURl: ACCOUNT_DELETE_API, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
          
        })
        
        

    }
    
    
    //get formatted json array for emergency contact service
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    
}
