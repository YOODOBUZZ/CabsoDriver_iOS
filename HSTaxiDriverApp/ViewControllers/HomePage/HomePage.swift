//
//  HomePage.swift
//  HSTaxiDriverApp
//
//  Created by APPLE on 16/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import SocketIO
import CoreLocation
import GoogleMaps
import Toast_Swift
let socket = SocketManager(socketURL: URL(string: demoSocketURL)!, config: [.log(true), .compress])

class HomePage: UIViewController,CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    
    @IBOutlet weak var appLogoImgView: UIImageView!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var ratingLbl: UILabel!
    @IBOutlet var userImgView: UIImageView!
    @IBOutlet var availabilityLbl: UILabel!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var ridesLbl: UILabel!
    @IBOutlet var dayTitileLbl: UILabel!
    @IBOutlet var monthTitleLbl: UILabel!
    @IBOutlet var dayLbl: UILabel!
    @IBOutlet var monthLbl: UILabel!
    @IBOutlet var rideView: UIView!
    @IBOutlet var totalEarTitleLbl: UILabel!
    @IBOutlet var totalEarLbl: UILabel!
    @IBOutlet var bookingTitleLbl: UILabel!
    @IBOutlet var bookingLbl: UILabel!
    @IBOutlet var infoTotalEarLbl: UILabel!
    @IBOutlet var infoTotalEarPriceLbl: UILabel!
    @IBOutlet var casCollectedLbl: UILabel!
    @IBOutlet var cashCollectedPriceLbl: UILabel!
    @IBOutlet var availableAmountLbl: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var availableAmountPriceLbl: UILabel!
    @IBOutlet var greenDotLbl: UILabel!
    @IBOutlet var onlineLbl: UILabel!
    @IBOutlet var onlineView: UIView!
    @IBOutlet var customChartView: UIView!
    @IBOutlet var statusSwitch: UISwitch!
    @IBOutlet var nochartDataLbl: UILabel!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupInitialDetails()
    }

    override func viewWillAppear(_ animated: Bool) {
        if (UserModel.shared.getProfilePic() != nil) {
            userImgView.sd_setImage(with: URL(string: UserModel.shared.getProfilePic()! as String), placeholderImage: #imageLiteral(resourceName: "placeholder_image"))
        }
        self.configOnlineStatus()
        self.setupInitialDetails()
        self.changeToRTL()
        self.nameLbl.text = UserModel.shared.getUserDetails().value(forKey: "full_name") as? String
        DispatchQueue.main.async {
            Utility.shared.fetchAdminData()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
//        isCallkitEnabled = false
    }
    func changeToRTL() {
            if UserModel.shared.getAppLanguage() == "Arabic" {
                self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.ratingLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.ratingLbl.textAlignment = .right
                self.nameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.nameLbl.textAlignment = .right
                self.monthTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.onlineLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.onlineLbl.textAlignment = .right
                self.ridesLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.ridesLbl.textAlignment = .right

                self.monthLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.totalEarTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.bookingTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.bookingTitleLbl.textAlignment = .right
                self.dayLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.dayTitileLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.availabilityLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.totalEarLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.userImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
                
                self.infoTotalEarLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.infoTotalEarLbl.textAlignment = .right
                self.casCollectedLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.casCollectedLbl.textAlignment = .right
                self.infoTotalEarPriceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.infoTotalEarPriceLbl.textAlignment = .left
                self.cashCollectedPriceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.cashCollectedPriceLbl.textAlignment = .left
                self.availableAmountLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.availableAmountLbl.textAlignment = .right
                self.availableAmountPriceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.availableAmountPriceLbl.textAlignment = .left
                self.onlineLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.onlineLbl.textAlignment = .right
                self.statusSwitch.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.nochartDataLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.nochartDataLbl.textAlignment = .right
                self.appLogoImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.bookingLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.bookingLbl.textAlignment = .left

    //            self.mapView.semanticContentAttribute = .forceRightToLeft

            }
            else {
                self.view.transform = .identity
                self.monthTitleLbl.transform = .identity
                self.nameLbl.transform = .identity
                self.nameLbl.textAlignment = .left
                self.dayLbl.transform = .identity
                self.onlineLbl.transform = .identity
                self.onlineLbl.textAlignment = .left
                self.ridesLbl.transform = .identity
                self.ridesLbl.textAlignment = .left
                self.monthLbl.transform = .identity
                self.totalEarTitleLbl.transform = .identity
                self.bookingTitleLbl.textAlignment = .left
                self.bookingTitleLbl.transform = .identity
                self.dayTitileLbl.transform = .identity
                self.availabilityLbl.transform = .identity
                self.totalEarLbl.transform = .identity
                self.userImgView.transform = .identity
                
                self.infoTotalEarLbl.textAlignment = .left
                self.infoTotalEarLbl.transform = .identity
                self.casCollectedLbl.textAlignment = .left
                self.casCollectedLbl.transform = .identity
                self.infoTotalEarPriceLbl.textAlignment = .right
                self.infoTotalEarPriceLbl.transform = .identity
                self.cashCollectedPriceLbl.textAlignment = .right
                self.cashCollectedPriceLbl.transform = .identity
                self.availableAmountLbl.textAlignment = .left
                self.availableAmountLbl.transform = .identity
                self.availableAmountPriceLbl.textAlignment = .right
                self.availableAmountPriceLbl.transform = .identity
                self.onlineLbl.textAlignment = .left
                self.onlineLbl.transform = .identity
                self.statusSwitch.transform = .identity
                self.nochartDataLbl.textAlignment = .left
                self.nochartDataLbl.transform = .identity
                self.appLogoImgView.transform = .identity
                self.bookingLbl.transform = .identity
                self.bookingLbl.textAlignment = .right

    //            self.mapView.semanticContentAttribute = .forceLeftToRight
            }
        }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        if isRegisteredForRemoteNotifications {
        } else {
            AJAlertController.initialization().showAlert(aStrMessage: "notification_permission", aCancelBtnTitle: "cancel", aOtherBtnTitle: "settings", status: "", completion: { (index, title) in
                print(index,title)
                if index == 1{
                    if let url = URL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            })
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //initial design setup
    func setupInitialDetails()  {
        ToastManager.shared.isQueueEnabled = true
        self.nochartDataLbl.config(color: TEXT_TERTIARY_COLOR, size: 15, align: .center, text: "loading")

        self.locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.checkVechicleStatus()
        scrollView.contentSize = CGSize.init(width:0 , height: 750)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationView.elevationEffect()
//        self.addAnimationLayer()
        self.userImgView.makeItRound()
        self.rideView.cornerViewMiniumRadius()
        self.rideView.elevationEffect()
        
        Utility.shared.fetchAdminData()

        self.nameLbl.config(color: TEXT_PRIMARY_COLOR, size: 18, align: .left, text: EMPTY_STRING)
        self.availabilityLbl.config(color: TEXT_PRIMARY_COLOR, size: 12, align: .center, text: "offline")
        self.ratingLbl.config(color: TEXT_PRIMARY_COLOR, size: 15, align: .left, text: EMPTY_STRING)
        self.ridesLbl.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, text: "rides")

        self.dayTitileLbl.config(color: TEXT_PRIMARY_COLOR, size: 15, align: .center, text: "day")
        self.monthTitleLbl.config(color: TEXT_PRIMARY_COLOR, size: 15, align: .center, text: "months")
        self.dayLbl.config(color: TEXT_PRIMARY_COLOR, size: 15, align: .center, text: EMPTY_STRING)
        self.monthLbl.config(color: TEXT_PRIMARY_COLOR, size: 15, align: .center, text: EMPTY_STRING)

        self.totalEarTitleLbl.config(color: TEXT_PRIMARY_COLOR, size: 15, align: .center, text: "total_earnings")
        self.totalEarLbl.config(color: TEXT_PRIMARY_COLOR, size: 25, align: .center, text: EMPTY_STRING)

        self.infoTotalEarLbl.config(color: TEXT_PRIMARY_COLOR, size: 15, align: .left, text: "total_earnings")
        self.casCollectedLbl.config(color: TEXT_PRIMARY_COLOR, size: 15, align: .left, text: "cash_collected")
        self.bookingTitleLbl.config(color: TEXT_PRIMARY_COLOR, size: 15, align: .left, text: "bookings")
        self.availableAmountLbl.config(color: TEXT_PRIMARY_COLOR, size: 15, align: .left, text: "available_amount")
   
        self.infoTotalEarPriceLbl.config(color: TEXT_PRIMARY_COLOR, size: 15, align: .right, text: EMPTY_STRING)
        self.cashCollectedPriceLbl.config(color: TEXT_PRIMARY_COLOR, size: 15, align: .right, text: EMPTY_STRING)
        self.availableAmountPriceLbl.config(color: TEXT_PRIMARY_COLOR, size: 15, align: .right, text: EMPTY_STRING)
        self.bookingLbl.config(color: TEXT_PRIMARY_COLOR, size: 15, align: .right, text: EMPTY_STRING)
        
        self.onlineView.elevationEffect()
        self.greenDotLbl.backgroundColor = GREEN_COLOR
        self.greenDotLbl.cornerRadius()
        self.onlineLbl.config(color: TEXT_PRIMARY_COLOR, size: 14, align: .left, text: "online_mode_msg")
        HPLActivityHUD.showActivity(with: .withOutMask)
        self.getDriverDetails()
    
    }
  
    //config online status view
    func configOnlineStatus()  {
        if (UserModel.shared.onlineStatus() != nil ){
            if (UserModel.shared.onlineStatus() == "online") {
                self.statusSwitch.isOn = true
                self.userOnline()
            }else{
                self.statusSwitch.isOn = false
                self.userOffline()
            }
        }
    }
    //set values from server
    func configViewWithDetails(userDict:NSDictionary)  {
        let ratingValue:String = userDict.value(forKey: "rating") as! String
//        self.ratingLbl.text = "\(CGFloat(truncating: ratingValue).rounded())"
        self.ratingLbl.text = ratingValue
        
        let dayValue:Int = userDict.value(forKey: "ride_today") as! Int
        self.dayLbl.text = String(dayValue)
        
        let monthValue:Int = userDict.value(forKey: "ridebymonth") as! Int
        self.monthLbl.text = String(monthValue)
        if userDict.value(forKey: "total_earning") is NSNull {
       
        }else{
            let totalEarValue:NSNumber = userDict.value(forKey: "total_earning") as! NSNumber
                   self.totalEarLbl.text = "\(String(describing: Utility().currency())) \(totalEarValue)"
                   self.infoTotalEarPriceLbl.text = "\(String(describing: Utility().currency())) \(totalEarValue)"
        }
        let cashCollectedValue:NSNumber = userDict.value(forKey: "cash_collected") as! NSNumber
        self.cashCollectedPriceLbl.text = "\(String(describing: Utility().currency())) \(cashCollectedValue)"
        
        let availableAmtValue:NSNumber = userDict.value(forKey: "available_amount") as! NSNumber
        self.availableAmountPriceLbl.text = "\(String(describing: Utility().currency())) \(availableAmtValue)"
        
        let bookingCount:Int = userDict.value(forKey: "booking_count") as! Int
        self.bookingLbl.text = String(bookingCount)
        
        self.configChartView(report: userDict.value(forKey: "cumulative_report") as! NSArray)
        
        let liveStatus:String = userDict.value(forKey: "livestatus") as! String
        if liveStatus == "true" {
            self.statusSwitch.isOn = true
            self.userOnline()
        }else if liveStatus == "false"{
            self.statusSwitch.isOn = false
            self.userOffline()
        }
//        self.configOnlineStatus()
    }
    
    //live enable action
    @IBAction func liveSwitchTapped(_ sender: UISwitch) {
        if sender.isOn{
         self.userOnline()
        }else {
          self.userOffline()
        }
    }
    //enable user available
    func userOnline()  {
        UserModel.shared.setUserOnlineStatus(userID: "online")
        self.connectSocket()
        self.locationManager.startUpdatingLocation()
        self.goOnline(user_status: "online")
        self.availabilityLbl.text = Utility().getLanguage()?.value(forKey: "online") as? String
        self.enableOnline(status: true)
   
    }
    //disable user available
    func userOffline()  {
        self.disconnectSocket()
        self.locationManager.stopUpdatingLocation()
        UserModel.shared.setUserOnlineStatus(userID: "offline")
        self.goOnline(user_status: "offline")
        self.availabilityLbl.text = Utility().getLanguage()?.value(forKey: "offline") as? String
        self.enableOnline(status: false)
    }
    
    //MARK: Socket emit actions
    func socketEmitMethods(address:String)  {
        let requestDict = NSMutableDictionary()
        requestDict.setValue(UserModel.shared.latitude(), forKey: "lat")
        requestDict.setValue(UserModel.shared.longitude(), forKey: "lng")
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(address, forKey: "location")
        socket.defaultSocket.emit("sharelocation", requestDict)
    }
    //set address
    func setAddress(coordinate:CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                var currentAddress = String()
                currentAddress = lines.joined(separator: "\n")
                UserModel.shared.setLocation(lat: "\(coordinate.latitude)", lng: "\(coordinate.longitude)")
                self.socketEmitMethods(address:currentAddress)
            }
        }
    }
    
    //MARK: show sidemenu
    @IBAction func sideBtnTapped(_ sender: Any) {
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
    }
    
    @IBAction func profilePicTapped(_ sender: Any) {
        let profileObj = ProfilePage()
        self.navigationController?.pushViewController(profileObj, animated: true)
    }
    //MARK: show notifications
    @IBAction func notificationBtnTapped(_ sender: Any) {
        let notificationObj = NotificationPage()
        notificationObj.modalPresentationStyle = .fullScreen
        self.navigationController?.present(notificationObj, animated: true, completion: nil)
    }
    
    //MARK: Dashboard Details
    func getDriverDetails(){
        let userObj = UserServices()
        userObj.getDashboardDetails(onSuccess: {response in
//            let status:NSString = response.value(forKey: "status") as! NSString
//            if status.isEqual(to: STATUS_TRUE){
                self.configViewWithDetails(userDict: response)
                HPLActivityHUD.dismiss()
//            }
        })
    }
    
    func checkVechicleStatus(){
        let signinServiceObj = LoginWebServices()
        let phoneNo = UserModel.shared.getUserDetails().value(forKey: "phone_number") as? String ?? "\(UserModel.shared.getUserDetails().value(forKey: "phone_number") as? NSNumber ?? 0)"

        signinServiceObj.signInService(email:  UserModel.shared.getUserDetails().value(forKey: "email") as! String, password: UserModel.shared.getPassword()! as String,country_code:UserModel.shared.getUserDetails().value(forKey: "country_code") as! String,phone_no:phoneNo,type:"withphone",onSuccess: {response in
            HPLActivityHUD.dismiss()
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){

                UserModel.shared.removeEmergencyContact()
                UserModel.shared.setUserInfo(userDict: response)
                UserModel.shared.setApproveDict(adminDict: response)
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if UserModel.shared.getApprove().value(forKey: "approval") as! String == "false"{
                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage:Utility.shared.getLanguage()?.value(forKey: "acc_deactivate") as! String, status: "" , completion: { (index, title) in
                        UserModel.shared.logoutUser()
                    })
                }else if UserModel.shared.getApprove().value(forKey:"vehicle_approval") as! String == "rejected"{
                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage:Utility.shared.getLanguage()?.value(forKey: "vehicle_rejected") as! String, status: "" , completion: { (index, title) in
                        appDelegate.setInitialViewController(initialView: SignupValidationPage())
                    })
                }
             
            }
        })
    }
    
    //MARK: Go Live
    func goOnline(user_status:String)  {
        let userObj = UserServices()
        userObj.goOnline(status: user_status, onSuccess: {response in
            let status:NSString = response.value(forKey: "status") as! NSString
                if status.isEqual(to: STATUS_FALSE){
                    let message:NSString = response.value(forKey: "message") as! NSString
                    if message.isEqual(to: "You are on ride"){
                        self.statusSwitch.isOn = true
                        if isCallkitEnabled {
                            self.view.hideAllToasts()
                            DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
                                self.view.makeToast(Utility().getLanguage()?.value(forKey: "you_are_online") as? String, align: UserModel.shared.getAppLanguage() ?? "")
                            }
                        }
                        else {
                            self.view.makeToast(Utility().getLanguage()?.value(forKey: "you_are_online") as? String, align: UserModel.shared.getAppLanguage() ?? "")
                        }
                        UserModel.shared.setUserOnlineStatus(userID: "online")
                        self.locationManager.startUpdatingLocation()
                        self.availabilityLbl.text = Utility().getLanguage()?.value(forKey: "online") as? String
                        self.enableOnline(status: true)
                    }
            }
        })
    }
    
    //enable online view based on the user status
    func enableOnline(status:Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            if status{
                self.onlineView.frame = CGRect.init(x: 0, y: FULL_HEIGHT-55, width: FULL_WIDTH, height: 55)
            }else{
                self.onlineView.frame = CGRect.init(x: 0, y: FULL_HEIGHT, width: FULL_WIDTH, height: 55)
            }
        })
    }
    
    //MARK: Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
        //set initial pickup coordination
        self.setAddress(coordinate: currentLocation.coordinate)
        
    }
   
    
    //MARK: location manager authorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
            self.locationPermissionAlert()
        case .denied:
            print("User denied access to location.")
            self.locationPermissionAlert()
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    //MARK:location restriction alert
    func locationPermissionAlert()  {
        AJAlertController.initialization().showAlert(aStrMessage: "location_permission", aCancelBtnTitle: "cancel", aOtherBtnTitle: "settings", status: "", completion: { (index, title) in
            print(index,title)
            if index == 1{
                //open settings page
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        })
    }
    
    //set up bar chart view
    func configChartView(report:NSArray)  {
        self.nochartDataLbl.config(color: TEXT_TERTIARY_COLOR, size: 15, align: .center, text: "no_ride_chart")
        let barChart = PNBarChart(frame: CGRect(x: 0, y: -30, width: FULL_WIDTH-40, height: self.customChartView.frame.size.height+50))
        
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        if month <= 6 {
            barChart.xLabels = ["Jan","Feb","Mar","Apr","May","Jun"]
        }else{
            barChart.xLabels = ["Jul","Aug","Sep","Oct","Nov","Dec"]
        }
        let yValueArray:NSMutableArray = NSMutableArray.init(array: [0,0,0,0,0,0])
        if report.count != 0 {
        for rideDict in report {
            let tempArray = NSMutableArray.init(array: [rideDict])
            var tempDict = NSDictionary()
            tempDict = tempArray.object(at: 0) as! NSDictionary
            let tempDetails = NSMutableDictionary.init(dictionary:tempDict)
            let indexMonth:Int = tempDetails.value(forKey: "month") as! Int
            if month <= 6 && indexMonth <= 6{
                yValueArray.removeObject(at: indexMonth-1)//remove previous details
                yValueArray.insert(tempDetails.value(forKey: "count")!, at: indexMonth-1)//add new details
            }else if month > 6 && indexMonth > 6{
                yValueArray.removeObject(at: indexMonth-7)//remove previous details
                yValueArray.insert(tempDetails.value(forKey: "count")!, at: indexMonth-7)//add new details
            }
         }
            // append y axis value
            var yAxisValue = [CGFloat]()
            for item in yValueArray {
                yAxisValue.append(item as! CGFloat)
            }
            barChart.yValues = yAxisValue
            barChart.yMaxValue = Utility.shared.rangeMax(max: yAxisValue.max()!)
        }else{
            barChart.yValues = [0,0,0,0,0,0]
            barChart.yMaxValue = 0
        }
        
        if barChart.yValues.max() == 0 {
            self.nochartDataLbl.isHidden = false
            self.view.bringSubview(toFront: self.nochartDataLbl)
        }else{
            self.nochartDataLbl.isHidden = true
        }
        barChart.barBackgroundColor = .clear
        barChart.strokeColors = [PRIMARY_COLOR,UIColor.orange,PRIMARY_COLOR,UIColor.orange,PRIMARY_COLOR,UIColor.orange]
        barChart.yLabelSum = 5
        barChart.strokeChart()
        barChart.backgroundColor = .clear
        customChartView.subviews.forEach({ $0.removeFromSuperview() }) // this gets things done
        self.customChartView.addSubview(barChart)
    }
}
