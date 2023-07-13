//
//  AppDelegate.swift
//  HSTaxiDriverApp
//
//  Created by APPLE on 09/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import Firebase
import UserNotifications
import FirebaseAuthUI
//import CallKit
import PushKit
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {
    
    var window: UIWindow?
    
    // Call Integration
    var callStarted = Bool()
    var baseUUId = UUID()
    var callStatus : String!
//    var callController = CXCallController()
//    var provider: CXProvider!
    /// The app's provider configuration, representing its CallKit capabilities.
//    static let providerConfiguration: CXProviderConfiguration = {
//        let localizedName = NSLocalizedString("Calling From", comment: "Howzu")
//        let providerConfiguration = CXProviderConfiguration(localizedName: localizedName)
//
//        // Prevents multiple calls from being grouped.
//        providerConfiguration.maximumCallsPerCallGroup = 1
//
//        providerConfiguration.supportsVideo = true
//        providerConfiguration.supportedHandleTypes = [.phoneNumber]
//        //        providerConfiguration.ringtoneSound = "Ringtone.aif"
//        //        let iconMaskImage = #imageLiteral(resourceName: "IconMask")
//        //        providerConfiguration.iconTemplateImageData = iconMaskImage.pngData()
//        return providerConfiguration
//    }()
    var callKitPopup = false
    var deviceTokenString = ""
    var isAlreadyInCall = false
    var callNotifyDict: JSON!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UserDefaults.standard.set(APP_RTC_URL, forKey: "web_rtc_web")
        
//        self.enableCallKit()

        self.setUpinitialDetails()
        //config firebase for push notification
        FirebaseApp.configure()
        self.registerForPushNotification(application)
        Messaging.messaging().delegate = self
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK:configure Initial Details
    func setUpinitialDetails()  {
        if UserModel.shared.getAppLanguage() != nil {
        }
        else {
            UserModel.shared.setAppLanguage(Language: DEFAULT_LANGUAGE)
        }
        Utility.shared.configureLanguage()
        IQKeyboardManager.shared.enable = true
        GMSServices.provideAPIKey(GOOGLE_API_KEY)
        GMSPlacesClient.provideAPIKey(GOOGLE_API_KEY)
        Utility.shared.fetchAdminData()
        self.checkUserLoggedStatus()
    }
    
    //MARK: check user status
    func checkUserLoggedStatus()  {
        //self.setInitialViewController(initialView: SignupValidationPage())
        if(UserModel.shared.userID() == nil) {
            self.setInitialViewController(initialView: WelcomePage())
        }else{
            Utility.shared.checkApprovedStatus()
        }
    }
    
    // MARK:set initial view controller
    func setInitialViewController(initialView: UIViewController)  {
        window = UIWindow(frame: UIScreen.main.bounds)
        let homeViewController = initialView
        let nav = UINavigationController(rootViewController: homeViewController)
        window!.rootViewController = nav
        window!.makeKeyAndVisible()
    }
    
    
    //MARK: Register for push notification
    func registerForPushNotification(_ application: UIApplication)  {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            }
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }
    //get token for pushnotification
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase Token: \(fcmToken ?? "")")
        UserModel.shared.setFCMToken(fcm_token: fcmToken! as NSString)
        // register token for pushnotification
        if UserModel.shared.getFCMToken() != nil && UserModel.shared.userID() != nil && UserModel.shared.getVOIPToken() != nil{
            Utility.shared.registerPushServices()
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        var notificationInfo = NSString()
        notificationInfo = response.notification.request.content.userInfo["gcm.notification.data"] as! NSString
        var notifyDict = NSDictionary()
        notifyDict = Utility.shared.convertToDictionary(text: notificationInfo as String)! as NSDictionary
        let type:String = notifyDict.value(forKey: "type") as! String
        print ("notificat background \(notifyDict)")
        
        if type == "nearby" { // receive new ride
            let acceptObj = RideAcceptPage()
            acceptObj.onride_id = notifyDict.value(forKey: "ride_id") as! String
            acceptObj.pickup_lat = notifyDict.value(forKey: "pickup_lat")as! String
            acceptObj.pickup_lng = notifyDict.value(forKey: "pickup_lng")as! String
            acceptObj.pickup_location = notifyDict.value(forKey: "pickup_location") as! String
            acceptObj.drop_location = notifyDict.value(forKey: "drop_location") as! String
            acceptObj.car_make = notifyDict.value(forKey: "make") as! String
            acceptObj.car_model = notifyDict.value(forKey: "model") as! String
            acceptObj.car_color = notifyDict.value(forKey: "color") as! String
            acceptObj.miles_travel = notifyDict.value(forKey: "distance") as! String
            acceptObj.travel_price = notifyDict.value(forKey: "baseprice") as! String
            acceptObj.payment_method = notifyDict.value(forKey: "payment_type") as! String
            
            
            let nav = UINavigationController(rootViewController: acceptObj)
            window!.rootViewController = nav
            window!.makeKeyAndVisible()
        }
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        var notificationInfo = NSString()
        notificationInfo = notification.request.content.userInfo["gcm.notification.data"] as! NSString
        var notifyDict = NSDictionary()
        notifyDict = Utility.shared.convertToDictionary(text: notificationInfo as String)! as NSDictionary
        print ("notificat \(notifyDict)")
        let type:String = notifyDict.value(forKey: "type") as! String
        if type == "nearby" {
            let acceptObj = RideAcceptPage()
            acceptObj.onride_id = notifyDict.value(forKey: "ride_id") as! String
            acceptObj.pickup_lat = notifyDict.value(forKey: "pickup_lat")as! String
            acceptObj.pickup_lng = notifyDict.value(forKey: "pickup_lng")as! String
            acceptObj.pickup_location = notifyDict.value(forKey: "pickup_location") as! String
            acceptObj.drop_location = notifyDict.value(forKey: "drop_location") as! String
            acceptObj.car_make = notifyDict.value(forKey: "make") as! String
            acceptObj.car_model = notifyDict.value(forKey: "model") as! String
            acceptObj.car_color = notifyDict.value(forKey: "color") as! String
            acceptObj.miles_travel = notifyDict.value(forKey: "distance") as! String
            acceptObj.travel_price = notifyDict.value(forKey: "baseprice") as! String
            acceptObj.payment_method = notifyDict.value(forKey: "payment_type") as! String
            let nav = UINavigationController(rootViewController: acceptObj)
            window!.rootViewController = nav
            window!.makeKeyAndVisible()
        }else if type == "cancelride"{ // cancelled current ride
            AJAlertController.initialization().showAlertWithOkButton(aStrMessage: notifyDict.value(forKey: "message") as! String, status: "", completion: { (index, title) in
                Utility.shared.goToHomePage()
            })
        }else if type == "payment" || type == "admin"{
            completionHandler([.alert, .sound, .badge])
        }
        completionHandler([.alert, .sound, .badge])
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(UIBackgroundFetchResult.noData)
            return
        }
        // This notification is not auth related, developer should handle it.
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        return true
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("\(deviceToken)")
        Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
    }
}

//extension AppDelegate: CXProviderDelegate, PKPushRegistryDelegate {
//    func enableCallKit() {
//        provider = CXProvider(configuration: type(of: self).providerConfiguration)
//        self.isAlreadyInCall = false
//        // REGISTER VOIP NOTIFICATION
//        let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
//        voipRegistry.desiredPushTypes = Set([PKPushType.voIP])
//        voipRegistry.delegate = self
//
//    }
//    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
//        print("pushRegistry didInvalidatePushTokenFor \(type)")
//    }
//
//    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
//
//        let deviceTokenString = pushCredentials.token.hexString
//        print("PUSH KIT TOKEN \(deviceTokenString)")
//        UserModel.shared.setVOIPToken(voip_token: deviceTokenString as NSString)
////        register token for pushnotification
//        if UserModel.shared.getFCMToken() != nil && UserModel.shared.userID() != nil && UserModel.shared.getVOIPToken() != nil{
//            Utility.shared.registerPushServices()
//        }
//    }
//    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
//        print("PUSHKIT NOTIFICATION \(payload.dictionaryPayload)")
//        let jsonDict = JSON(payload.dictionaryPayload)
//        self.callNotifyDict = jsonDict
//        if jsonDict["type"].stringValue == "call" {
//            if !isAlreadyInCall {
//                isAlreadyInCall = true
//                self.baseUUId = UUID()
//                self.provider.setDelegate(self, queue: nil)
//                let update = CXCallUpdate()
//                let username = "Cabso"//jsonDict["user_name"].stringValue
//                update.remoteHandle = CXHandle(type: .generic, value: username)
//                if jsonDict["type"].stringValue == "video" {
//                    update.hasVideo = true
//                }
//                else {
//                    update.hasVideo = false
//                }
//                self.provider.configuration.maximumCallsPerCallGroup = 1
//                self.provider.reportNewIncomingCall(with: self.baseUUId, update: update, completion: { error in })
//                self.callKitPopup = true
//            }
//        }
//        else if jsonDict["type"].stringValue == "bye" {
//            self.endCall()
//            if (window?.rootViewController?.isKind(of: AudioCallViewController.self))! {
//                window?.rootViewController?.dismiss(animated: true, completion: nil)
//            }
//            else {
//                let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
//                print("hello")
//                if var topController = keyWindow?.rootViewController {
//                    while let presentedViewController = topController.presentedViewController {
//                        topController = presentedViewController
//                        if topController.isKind(of: AudioCallViewController.self) {
//                            window?.rootViewController?.dismiss(animated: true, completion: nil)
//                        }
//                    }
//                }
//            }
//        }
//    }
//    func endCall(){
//        self.isAlreadyInCall = false
//        // Print("end call uuid \(baseUUId)")
//        let endCallAction = CXEndCallAction(call:baseUUId)
//        let transaction = CXTransaction(action: endCallAction)
//        callController.request(transaction) { error in
//            print(error?.localizedDescription ?? "")
//            if error == nil {
//                // Print("EndCallAction transaction request failed: \(error.localizedDescription).")
//                self.provider.reportCall(with: self.baseUUId, endedAt: Date(), reason: .remoteEnded)
//                return
//            }
//            else {
//            }
//            // Print("EndCallAction transaction request successful")
//        }
//        self.automaticDisconnect()
//        self.callStarted = false
//        callKitPopup = false
//        //        self.endCallAct()
//    }
//    @objc func automaticDisconnect()
//    {
//        if (callStatus == "incoming")
//        {
//            let endCallAction = CXEndCallAction(call:baseUUId)
//            let transaction = CXTransaction(action: endCallAction)
//            callController.request(transaction) { error in
//                if let error = error {
//                    // Print("EndCallAction transaction request failed: \(error.localizedDescription).")
//                    //self.cxCallProvider.reportCall(with: call, endedAt: Date(), reason: .remoteEnded)
//                    return
//                }
//                // Print("EndCallAction transaction request successful")
//            }
//            let time = NSDate().timeIntervalSince1970
//            callKitPopup = false
//        }
//        self.callStarted = false
//    }
//    func providerDidReset(_ provider: CXProvider) {
//
//    }
//    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
//        action.fulfill()
//        let session = AVAudioSession.sharedInstance()
//        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
//        let pageobj = AudioCallViewController()
//        pageobj.receiverId =  self.callNotifyDict["user_id"].stringValue
//        pageobj.room_id = self.callNotifyDict["room_id"].stringValue
//        pageobj.callNotifyDict = self.callNotifyDict
//        pageobj.senderFlag = false
//        pageobj.viewType = "2"
//        pageobj.call_type = "audio"
//        pageobj.modalPresentationStyle = .fullScreen
//        self.window!.makeKeyAndVisible()
//        UIApplication.topViewController()?.present(pageobj, animated: true, completion: nil)
//    }
//    func dismissView() {
//        if (window?.rootViewController?.isKind(of: AudioCallViewController.self))! {
//            window?.rootViewController?.dismiss(animated: true, completion: nil)
//        }
//        else {
//            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
//            print("hello")
//            if var topController = keyWindow?.rootViewController {
//                while let presentedViewController = topController.presentedViewController {
//                    topController = presentedViewController
//                    if topController.isKind(of: AudioCallViewController.self) {
//                        window?.rootViewController?.dismiss(animated: true, completion: nil)
//                    }
//                }
//            }
//        }
//    }
//    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
//        action.fulfill()
//        if self.isAlreadyInCall {
//            self.isAlreadyInCall = false
//            let rideObj = RideServices()
//            rideObj.endCall(sender_id: (UserModel.shared.userID() as String? ?? ""), receiver_id: self.callNotifyDict["sender_id"].stringValue, room_id: self.callNotifyDict["room_id"].stringValue) { (result) in
//                self.window?.rootViewController?.view.makeToast("Call declined", align: "")
//            }
//            self.dismissView()
//        }
//    }
//}
extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
