//
//  RideAcceptPage.swift
//  HSTaxiDriverApp
//
//  Created by APPLE on 13/04/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import SRCountdownTimer
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class RideAcceptPage: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate,SRCountdownTimerDelegate {
    var locationManager = CLLocationManager()
    var marker = GMSMarker()
    let cameraPostion = GMSCameraPosition()
    var currentLocation = CLLocation()
    
    @IBOutlet var acceptBtn: UIButton!
    @IBOutlet var timerLbl: UILabel!
    @IBOutlet var statusSwitch: UISwitch!
    @IBOutlet var timerView: SRCountdownTimer!
    @IBOutlet var containerView: UIView!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var statusLbl: UILabel!
    
    @IBOutlet weak var pickupLocationLbl: UILabel!
    @IBOutlet weak var dropLocationLbl: UILabel!
    @IBOutlet weak var make: UILabel!
    @IBOutlet weak var model: UILabel!
    @IBOutlet weak var color: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var payment: UILabel!
    @IBOutlet weak var miles: UILabel!
    
    var onride_id = String()
    var pickup_lat = String()
    var pickup_lng = String()
    var pickup_location = String()
    var drop_location = String()
    var car_model = String()
    var car_make = String()
    var car_color = String()
    var payment_method = String()
    var miles_travel = String()
    var travel_price = String()
    var isAccepted = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupInitialDetails()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.changeToRTL()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.acceptBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.timerLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.statusSwitch.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.mapView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.statusLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.pickupLocationLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
        }else {
            self.view.transform = .identity
            self.acceptBtn.transform = .identity
            self.timerLbl.transform = .identity
            self.statusSwitch.transform = .identity
            self.mapView.transform = .identity
            self.statusLbl.transform = .identity
            self.pickupLocationLbl.transform = .identity

        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: set up intial details
    func setupInitialDetails()  {
        self.navigationController?.isNavigationBarHidden = true
        self.isAccepted = false
        self.view.backgroundColor = PRIMARY_COLOR
        self.mapView.cornerViewRadius()
        self.containerView.cornerViewRadius()
        self.containerView.setBorder(color: UIColor().hexValue(hex: "929292"), width: 12)
        self.pickupLocationLbl.config(color: .white, size: 15, align: .center, text: EMPTY_STRING)
        self.pickupLocationLbl.numberOfLines = 3
        self.timerLbl.config(color: .white, size: 30, align: .center, text: EMPTY_STRING)
        self.acceptBtn.config(color: .white, size: 17, align: .center, title: "accept_ride")
        self.acceptBtn.cornerMiniumRadius()
        self.acceptBtn.setBorder(color: .white, width: 1)
        //config status lbl
        self.statusLbl.config(color: .white, size: 12, align: .center, text: EMPTY_STRING)
        if (UserModel.shared.onlineStatus() != nil ){
            if (UserModel.shared.onlineStatus() == "online") {
                self.statusLbl.text = "online"
                self.statusSwitch.isOn = true
            }else{
                self.statusLbl.text = "offline"
                self.statusSwitch.isOn = false
            }
        }
        //config timer view
        self.timerView.cornerViewRadius()
        self.timerView.lineWidth = 7
        self.timerView.lineColor = .clear//background
        self.timerView.trailLineColor = UIColor().hexValue(hex: "6FB5FC")//main
        self.timerView.start(beginingValue: 60)
        self.timerView.delegate = self
        self.timerView.isLabelHidden = true
        self.timerView.labelTextColor = .clear
        //config map
        self.configMap()
        self.pickupLocationLbl.text = self.pickup_location
        self.dropLocationLbl.text = self.drop_location
        if self.car_make == ""{
            self.make.text = "Not added"
        }else{
            self.make.text = self.car_make
        }
       
        if self.car_model == ""{
            self.model.text = "Not added"
        }else{
            self.model.text = self.car_model
        }
        if self.car_color == ""{
            self.color.text = "Not added"
        }else{
            self.color.text = self.car_color
        }
        
        self.price.text = self.travel_price
        self.payment.text = self.payment_method
        self.miles.text = self.miles_travel
        
    }
    
    //setup google map
    func configMap(){
        mapView.delegate = self
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        // Set the map style by passing the URL of the local file.
        do {
            if let styleURL = Bundle.main.url(forResource: "mapstyle", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                print("Unable to find style.json")
            }
        } catch {
            print("One or more of the map styles failed to load. \(error)")
        }
        
        let lat:Double =  Utility.shared.convertToDouble(string: self.pickup_lat)
        let lng:Double = Utility.shared.convertToDouble(string: self.pickup_lng)
        let camera = GMSCameraPosition.camera(withLatitude: (lat), longitude: (lng), zoom: 14.0)
        self.mapView.animate(to: camera)
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        //add custom marker to gmsmarker
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let pickupPoint = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 22, height: 45))
        pickupPoint.image = #imageLiteral(resourceName: "current_location")
        pickupPoint.contentMode = .scaleAspectFit
        marker.iconView = pickupPoint
        marker.map = mapView
    }
    
    //switch btn chaged
    @IBAction func switchBtnTapped(_ sender: UISwitch) {
        if sender.isOn{
            UserModel.shared.setUserOnlineStatus(userID: "online")
            self.goOnline(user_status: "online")
            self.statusLbl.text = "online"
        }else{
            UserModel.shared.setUserOnlineStatus(userID: "offline")
            self.goOnline(user_status: "offline")
            self.statusLbl.text = "offline"
        }
    }
    
    @IBAction func acceptBtnTapped(_ sender: Any) {
        HPLActivityHUD.showActivity(with: .withOutMask)
        let rideObj = RideServices()
        rideObj.goRide(onride_id:onride_id, onSuccess: {response in
            HPLActivityHUD.dismiss()
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
            self.isAccepted = true
            self.timerView.end()
            let rideNavObj = RideNavigationPage()
            rideNavObj.rideDict = response
            rideNavObj.onride_id = self.onride_id
            rideNavObj.modalPresentationStyle = .fullScreen
            rideNavObj.myCoordinate = self.currentLocation.coordinate
            self.present(rideNavObj, animated: true, completion: nil)
            }else if status.isEqual(to: STATUS_FALSE){
                let message:String = response.value(forKey: "message") as! String
                AJAlertController.initialization().showAlertWithOkButton(aStrMessage: message, status: "", completion: { (index, title) in
                    Utility.shared.goToHomePage()
                })
            }
        })
    }
    
    //MARK: Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
       
    }
    
    //MARK: Go Live
    func goOnline(user_status:String)  {
        let userObj = UserServices()
        userObj.goOnline(status: user_status, onSuccess: {response in
            Utility.shared.goToHomePage()
        })
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
    
    //MARK: Counter view delegate
    func timerDidUpdateCounterValue(newValue: Int) {
        let (h,m,s) = self.secondsToHoursMinutesSeconds(seconds: newValue)
        print("seconds \(s)")
        if h == 0 && m == 0{
            self.timerLbl.text = "\(s) Sec"
            if s == 0 && !isAccepted{
                Utility.shared.goToHomePage()
            }
        }else if h == 0{
            self.timerLbl.text = "\(m) Mins \(s) Sec"
        }else{
            self.timerLbl.text = "\(h)Hour \(m) Mins \(s) Sec"
        }
    }
  
    //convert integer to date format
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

}
