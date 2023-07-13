//
//  RideServices.swift
//  HSTaxiDriverApp
//
//  Created by APPLE on 13/04/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class RideServices: BaseWebService {

    // go ride now
    public func goRide(onride_id:String,onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(onride_id, forKey: "onride_id")
        self.baseService(subURl: GO_RIDE_API, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    // where am currently
    public func whereAm(onride_id:String,status:String,onride_otp:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(onride_id, forKey: "onride_id")
        requestDict.setValue(status, forKey: "status")
        if status == "onride"{
            requestDict.setValue(onride_otp, forKey: "onride_otp")
        }
        self.baseService(subURl: WHERE_AM_API, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    //Complete ride
    public func completeRide(onride_id:String,distance:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(onride_id, forKey: "onride_id")
        requestDict.setValue(distance, forKey: "distance")
        self.baseService(subURl: COMPLETE_RIDE_API, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    // get ride details
    public func getRideDetails(onride_id:String,type:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(onride_id, forKey: "onride_id")
        requestDict.setValue(type, forKey: "type")
        self.baseService(subURl: RIDE_DETAILS_API, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    // completed ride details
    public func getCompletedRideDetails(onride_id:String,onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(onride_id, forKey: "onride_id")
        self.baseService(subURl: GET_PAYMENT_INFO, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    public func paybyCash(amount:String,onride_id:String,basefare:NSNumber,commissionamount:NSNumber,tax:NSNumber,customer_id:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(amount, forKey: "amount")
        requestDict.setValue(onride_id, forKey: "onride_id")
        requestDict.setValue("0", forKey: "iswallet")
        requestDict.setValue(basefare, forKey: "basefare")
        requestDict.setValue(commissionamount, forKey: "commissionamount")
        requestDict.setValue(tax, forKey: "tax")
        requestDict.setValue(customer_id, forKey: "rideuserid")
        
        self.baseService(subURl: CASH_PAYMENT_API, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    // ride history
    public func rideHistory(type:String,onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(type, forKey: "type")
        self.baseService(subURl: RIDE_HISTORY_API, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    // MakeCall
    public func makeCall(sender_id:String,receiver_id:String,room_id:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let time = NSDate().timeIntervalSince1970
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(sender_id, forKey: "sender_id")
        requestDict.setValue(receiver_id, forKey: "receiver_id")
        requestDict.setValue("driver", forKey: "user_type")
        requestDict.setValue(room_id, forKey: "room_id")
        requestDict.setValue("ios", forKey: "platform")
        requestDict.setValue("\(time.rounded().clean)", forKey: "timestamp")
        requestDict.setValue("call", forKey: "type")
        self.baseService(subURl: MAKE_CALL_API, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    public func endCall(sender_id:String,receiver_id:String,room_id:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        //        Param: sender_id, receiver_id, room_id, platform, timestamp, user_type
        let time = NSDate().timeIntervalSince1970
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(sender_id, forKey: "sender_id")
        requestDict.setValue(receiver_id, forKey: "receiver_id")
        requestDict.setValue("driver", forKey: "user_type")
        requestDict.setValue(room_id, forKey: "room_id")
        requestDict.setValue("ios", forKey: "platform")
        requestDict.setValue("bye", forKey: "type")
        requestDict.setValue("\(time.rounded().clean)", forKey: "timestamp")
        self.baseService(subURl: END_CALL_API, params: requestDict as? Parameters, onSuccess: {response in
            print(response)
            success(response)
        }, onFailure: {errorResponse in
        })
    }
}
