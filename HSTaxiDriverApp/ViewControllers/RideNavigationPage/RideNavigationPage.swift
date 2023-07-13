//
//  RideNavigationPage.swift
//  HSTaxiDriverApp
//
//  Created by APPLE on 13/04/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import IQKeyboardManagerSwift

class RideNavigationPage: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate{
    
    var locationManager = CLLocationManager()
    var mapView = GMSMapView()
    var marker = GMSMarker()
    let cameraPostion = GMSCameraPosition()
    var currentLocation = CLLocation()
    var myCoordinate = CLLocationCoordinate2D()
    var markerStart = GMSMarker()
    var markerEnd = GMSMarker()
    var polyline = GMSPolyline()
    var animationPolyline = GMSPolyline()
    var path = GMSPath()
    var animationPath = GMSMutablePath()
    var i: UInt = 0
    @IBOutlet var sosAlertBtn: UIButton!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var pickupNavbtn: UIButton!
    @IBOutlet var dropNavbtn: UIButton!
    @IBOutlet var pickupDetailsView: UIView!
    @IBOutlet var closeView: UIView!
    @IBOutlet var customerName: UILabel!
    @IBOutlet var pickupLbl: UILabel!
    @IBOutlet var customerPickupLocationLbl: UILabel!
    @IBOutlet var arrivingBtn: UIButton!
    @IBOutlet var beginView: UIView!
    @IBOutlet var otpTF: FloatLabelTextField!
    @IBOutlet var otpBorderLbl: UILabel!
    @IBOutlet var beginBtn: UIButton!
    @IBOutlet var completeView: UIView!
    @IBOutlet var completeBtn: UIButton!
    @IBOutlet weak var dropLbl: UILabel!
    
    @IBOutlet weak var customerDropLocationLbl: UILabel!
    var onride_id = String()
    var rideDict = NSDictionary()
    var trigger = Timer()
    var pickup_lat = Double()
    var pickup_lng = Double()
    var drop_lat = Double()
    var drop_lng = Double()
    var pickupCoordinate = CLLocationCoordinate2D()
    var dropCoordinate = CLLocationCoordinate2D()
    var startCoordinate = CLLocationCoordinate2D()
    var stopCoordinate = CLLocationCoordinate2D()
    var startRiding = Bool()
    var clearPolyline = Bool()
    var viewType = String()
    var historyDict = NSDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupInitialDetails()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.trigger.invalidate()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.changeToRTL()
    }
    func changeToRTL() {
        self.setupInitialDetails()
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.pickupNavbtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.dropNavbtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.arrivingBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.beginBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.customerName.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.customerName.textAlignment = .right
            self.pickupLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.pickupLbl.textAlignment = .right
            self.customerPickupLocationLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.customerPickupLocationLbl.textAlignment = .right
            self.completeBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.otpTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.otpTF.textAlignment = .right
            self.customerDropLocationLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.customerDropLocationLbl.textAlignment = .right
            self.dropLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.dropLbl.textAlignment = .right
            self.sosAlertBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.sosAlertBtn.contentHorizontalAlignment = .left
            self.mapView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.mapView.semanticContentAttribute = .forceRightToLeft
        }
        else {
            self.view.transform = .identity
            self.pickupNavbtn.transform = .identity
            self.dropNavbtn.transform = .identity
            self.arrivingBtn.transform = .identity
            self.beginBtn.transform = .identity
            self.completeBtn.transform = .identity
            self.customerName.transform = .identity
            self.customerName.textAlignment = .left
            self.pickupLbl.transform = .identity
            self.pickupLbl.textAlignment = .left
            self.customerPickupLocationLbl.transform = .identity
            self.customerPickupLocationLbl.textAlignment = .left
            self.otpTF.transform = .identity
            self.otpTF.textAlignment = .left
            self.dropLbl.transform = .identity
            self.dropLbl.textAlignment = .left
            self.customerDropLocationLbl.transform = .identity
            self.customerDropLocationLbl.textAlignment = .left
            self.sosAlertBtn.transform = .identity
            self.sosAlertBtn.contentHorizontalAlignment = .right
            self.mapView.transform = .identity
            self.mapView.semanticContentAttribute = .forceLeftToRight

        }
    }
    //MARK: Initial set up
    func setupInitialDetails()  {
                NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        IQKeyboardManager.shared.enable = false
        self.clearPolyline = false
        self.navigationController?.isNavigationBarHidden = true
        self.addAnimationLayer()
        self.configureGoogleMap()
        self.view.bringSubview(toFront: self.closeView)
        self.configPickupBeginDetailsView()

        if self.viewType == "1"{ // view driver details from history page
            HPLActivityHUD.showActivity(withPosition: CGPoint.init(x: FULL_WIDTH/2, y: FULL_HEIGHT-135))
            self.getRideDetails(type: "accepted")
        }else if self.viewType == "2"{ // view driver details from history page
            HPLActivityHUD.showActivity(withPosition: CGPoint.init(x: FULL_WIDTH/2, y: FULL_HEIGHT-135))
            self.getRideDetails(type: "ontheway")
        }else if self.viewType == "3"{ // emit socket from history page
            HPLActivityHUD.showActivity(withPosition: CGPoint.init(x: FULL_WIDTH/2, y: FULL_HEIGHT-135))
            self.getRideDetails(type: "onride")
        }else{
            self.setDetailsToPickUpDetailsView()
            self.animateView(view: self.pickupDetailsView)
        }
        self.connectSocket()
        self.startRiding = true
        self.pickupNavbtn.config(color: .white, size: 14, align: .center, title: "navigate")
        self.pickupNavbtn.backgroundColor = PRIMARY_COLOR
        self.pickupNavbtn.cornerMiniumRadius()
        self.dropNavbtn.config(color: .white, size: 14, align: .center, title: "navigate")
        self.dropNavbtn.backgroundColor = PRIMARY_COLOR
        self.dropNavbtn.cornerMiniumRadius()
        self.navigationView.elevationEffect()
        self.view.bringSubview(toFront: self.navigationView)
        self.sosAlertBtn.config(color: RED_COLOR, size: 17, align: .right, title: "sosalert")
    }
    
    //design setup to pickupdetails view
    func configPickupBeginDetailsView()  {
        self.pickupLbl.config(color: TEXT_SECONDARY_COLOR, size: 13, align: .left, text: "pickup")
        self.dropLbl.config(color: TEXT_SECONDARY_COLOR, size: 13, align: .left, text: "drop")

        self.customerName.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: EMPTY_STRING)
        self.customerPickupLocationLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .left, text: EMPTY_STRING)
        self.customerDropLocationLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .left, text: EMPTY_STRING)

        self.arrivingBtn.config(color: .white, size: 17, align: .center, title: "arriving")
        self.arrivingBtn.cornerMiniumRadius()
        self.arrivingBtn.backgroundColor = GREEN_COLOR
        
        //begin view
        self.otpTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "otp")
        
        self.beginBtn.config(color: .white, size: 17, align: .center, title: "begin_ride")
        self.beginBtn.cornerMiniumRadius()
        self.beginBtn.backgroundColor = GREEN_COLOR
        
        self.completeBtn.config(color: .white, size: 17, align: .center, title: "complete_ride")
        self.completeBtn.backgroundColor = RED_COLOR
        self.completeBtn.cornerMiniumRadius()
    }
    func setDetailsToPickUpDetailsView()  {
        self.customerName.text = self.rideDict.value(forKey:"user_name") as? String
        self.customerPickupLocationLbl.text = self.rideDict.value(forKey: "pickup_location") as? String
        self.customerDropLocationLbl.text = self.rideDict.value(forKey: "drop_location") as? String

         self.pickup_lat =  Utility.shared.convertToDouble(string: self.rideDict.value(forKey: "pickup_lat") as! String)
        self.pickup_lng = Utility.shared.convertToDouble(string: self.rideDict.value(forKey: "pickup_lng") as! String)
        self.drop_lat = Utility.shared.convertToDouble(string: self.rideDict.value(forKey: "drop_lat") as! String)
        self.drop_lng = Utility.shared.convertToDouble(string: self.rideDict.value(forKey: "drop_lng") as! String)
        self.pickupCoordinate = CLLocationCoordinate2D.init(latitude: self.pickup_lat, longitude: self.pickup_lng)
        self.dropCoordinate = CLLocationCoordinate2D.init(latitude: self.drop_lat, longitude: self.drop_lng)
        self.showLocationTipView()
        self.getLocationService()
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
          let info = sender.userInfo!
          let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        self.beginView.frame.size.height += keyboardFrame.height+15
        self.animateView(view: self.beginView)


      }
      @objc func keyboardWillShow(sender: NSNotification) {
          let info = sender.userInfo!
          let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let totalHeight =  self.beginView.frame.size.height + keyboardFrame.height
        self.beginView.frame.origin.y = FULL_HEIGHT-totalHeight

      }
    //MARK: Get location service
    func getLocationService()  {
        
        let getLocationObj = GoogleLocationService()
        getLocationObj.getLocation(destinationCoordination:self.dropCoordinate, pickupCoordination: self.pickupCoordinate, onSuccess: {response in
            let status:String = response.value(forKey: "status") as! String
            if status == "OVER_QUERY_LIMIT"{
                self.getLocationService()
            }else{
                self.drawRoute(routesArray: response.value(forKey:"routes") as! NSArray)
            }
        }, onFailure: {errorResponse in
        })
    }
    
    func drawRoute(routesArray: NSArray) {
        
        if (routesArray.count > 0)
        {
            let routeDict = routesArray[0] as! Dictionary<String, Any>
            let routeOverviewPolyline = routeDict["overview_polyline"] as! Dictionary<String, Any>
            let points = routeOverviewPolyline["points"]
            self.path = GMSPath.init(fromEncodedPath: points as! String)!
            self.polyline.path = path
            self.polyline.strokeWidth = 3.0
            self.polyline.strokeColor = PRIMARY_COLOR
            self.polyline.map = self.mapView
            
            let mapBounds = GMSCoordinateBounds(path: self.path)
            let cameraUpdate = GMSCameraUpdate.fit(mapBounds)
            mapView.moveCamera(cameraUpdate)
            let bounds = GMSCoordinateBounds(path: path)
            self.mapView.moveCamera(GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: self.navigationView.frame.height+50, left: 10, bottom: self.pickupDetailsView.frame.height+30, right: 10)))
//            mapView.animate(toZoom: 0.00)
            self.animatePolylinePath()
            self.showLocationTipView()
        }
    }
    //draw animated polyline
    @objc func animatePolylinePath() {
        if (self.i < self.path.count()) {
            self.animationPath.add(self.path.coordinate(at: self.i))
            self.animationPolyline.path = self.animationPath
            self.animationPolyline.strokeColor = UIColor.black
            self.animationPolyline.strokeWidth = 3
            self.animationPolyline.map = self.mapView
            self.i += 1
        }else {
            self.i = 0
            self.animationPath = GMSMutablePath()
            self.animationPolyline.map = nil
        }
    }
    //MARK: back btn tapped
    @IBAction func backBtnTapped(_ sender: Any) {
     Utility.shared.goToHomePage()
    }
    @IBAction func sosAlertBtnTapped(_ sender: Any) {
        let sosAlert = SOSAlertPage()
        sosAlert.myLocation = (self.locationManager.location?.coordinate)!
        sosAlert.modalPresentationStyle = .fullScreen
        self.present(sosAlert, animated: true, completion: nil)
    }
    @IBAction func arrivingBtnTapped(_ sender: Any) {
        HPLActivityHUD.showActivity(withPosition: CGPoint.init(x: FULL_WIDTH/2, y: FULL_HEIGHT-135))
        self.rideStatusServices(status: "ontheway")
    }
    
    @IBAction func beginBtnTapped(_ sender: Any) {
        if self.otpTF.isEmptyValue(){
            self.otpBorderLbl.backgroundColor = RED_COLOR
            self.otpTF.setAsInvalidTF("enter_otp", in: self.view)
        }else{
            HPLActivityHUD.showActivity(withPosition: CGPoint.init(x: FULL_WIDTH/2, y: FULL_HEIGHT-135))
            self.rideStatusServices(status: "onride")
        }
    }
    
    @IBAction func completeBtnTapped(_ sender: Any) {
        HPLActivityHUD.showActivity(withPosition: CGPoint.init(x: FULL_WIDTH/2, y: FULL_HEIGHT-135))
      self.getDistance()
    }
    
    @IBAction func dropNavBtnTapped(_ sender: Any) {
        self.moveToExternalMap(type: "2")
    }
    
    @IBAction func pickupNavBtnTapped(_ sender: Any) {
        self.moveToExternalMap(type: "1")
    }
    
    //navigation redirect to external google maps
    func moveToExternalMap(type:String) {
        if UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL){
            var urlString = String()
            if type == "1"{ // google map navigation from current location to user pickup location
                 urlString = "http://maps.google.com/?saddr=\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)&daddr=\(self.pickupCoordinate.latitude),\(self.pickupCoordinate.longitude)&directionsmode=driving&key=\(GOOGLE_API_KEY)"
            }else if type == "2"{ // google map navigation from current location to user drop location
                 urlString = "http://maps.google.com/?saddr=\(self.pickupCoordinate.latitude),\(self.pickupCoordinate.longitude)&daddr=\(self.dropCoordinate.latitude),\(self.dropCoordinate.longitude)&directionsmode=driving&key=\(GOOGLE_API_KEY)"
            }
            let mapURL: URL = URL.init(string: urlString)!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(mapURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(mapURL)
            }
        }else{
            //google maps not installed
            Utility.shared.showAlert(msg: "install_googlemap", status: "")
        }
    }
    
    //MARK: Socket emit actions
    @objc func socketEmitMethods(address:String)  {
        let requestDict = NSMutableDictionary()
        requestDict.setValue(UserModel.shared.latitude(), forKey: "lat")
        requestDict.setValue(UserModel.shared.longitude(), forKey: "lng")
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(address, forKey: "location")
        print("emit \(requestDict)")
        socket.defaultSocket.emit("sharelocation", requestDict)
        self.socketOnMethods()
    }
    
    
    //MARK: Socket on actions
    func socketOnMethods()  {
        socket.defaultSocket.on("iamhere") { ( data, ack) -> Void in
            print(" SOCKET LOCATION RESPONSE : \(data)")
            // add comment to array and reload
        }
    }
    
    /*
     * configure map sizes
     * add mapstyle with json file
     * location update delegate methods
     */
    func configureGoogleMap(){
        let camera = GMSCameraPosition.camera(withLatitude:self.pickupCoordinate.latitude, longitude: self.pickupCoordinate.latitude, zoom: 17.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: FULL_WIDTH, height: FULL_HEIGHT), camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.padding = UIEdgeInsets.init(top: 0, left: 0, bottom: 5, right: 5)
        mapView.mapType = .normal
        mapView.tintColor = .black
        self.view.addSubview(mapView)
        mapView.delegate = self
        //Location Manager code to fetch current location
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
        
    
    
    }

    //MARK: Show marker tip view
    func showLocationTipView()  {
        markerStart.position = CLLocationCoordinate2D(latitude: self.pickupCoordinate.latitude, longitude: self.pickupCoordinate.longitude)
        let markerStartView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 22, height: 45))
        markerStartView.image = #imageLiteral(resourceName: "pickup_location")
        markerStartView.contentMode = .scaleAspectFit
        markerStart.iconView = markerStartView
        markerStart.appearAnimation = .pop
        markerStart.map = mapView
        
        markerEnd.position = CLLocationCoordinate2D(latitude: self.dropCoordinate.latitude, longitude: self.dropCoordinate.longitude)
        let markerEndView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 22, height: 45))
        markerEndView.image = #imageLiteral(resourceName: "current_location")
        markerEndView.contentMode = .scaleAspectFit
        markerEnd.iconView = markerEndView
        markerEnd.appearAnimation = .pop
        markerEnd.map = mapView
        
        let mapBounds = GMSCoordinateBounds.init(coordinate: self.pickupCoordinate, coordinate: self.dropCoordinate)
        let cameraUpdate = GMSCameraUpdate.fit(mapBounds)
        mapView.moveCamera(cameraUpdate)
        mapView.animate(toZoom: 15)
    }
    
   
    //GMS Map view delegate
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        let coordinate = CLLocationCoordinate2DMake(Double(latitude),Double(longitude))
//        UserModel.shared.setLocation(lat: "\(coordinate.latitude)", lng: "\(coordinate.longitude)")
//        self.setAddress(coordinate: coordinate)

//        self.socketEmitMethods()
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
       
    }
    
    
    //MARK: Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        if startRiding{
            self.startCoordinate = CLLocationCoordinate2D.init(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            self.startRiding = false
        }else{
            self.stopCoordinate = CLLocationCoordinate2D.init(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        }
        
        //set initial pickup coordination
        self.setAddress(coordinate: currentLocation.coordinate)
     
        self.marker.position = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.latitude)
     self.marker.map = self.mapView
    /*    let userLocation = locations.last
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 15);
        self.mapView.camera = camera
        self.mapView.isMyLocationEnabled = true
        let marker = GMSMarker(position: center)
        print("Latitude :- \(userLocation!.coordinate.latitude)")
        print("Longitude :-\(userLocation!.coordinate.longitude)")
        marker.map = self.mapView*/
        
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
    
    //animate view
    func animateView(view:UIView) {
        UIView.animate(withDuration: 0.2, animations: {
            self.hideAllSubViews()
        })
        let height:CGFloat = view.frame.size.height
        UIView.animate(withDuration: 0.3, delay: 0.3, usingSpringWithDamping: 1.0, initialSpringVelocity: 2.0, options: .curveLinear, animations: {
            view.frame = CGRect.init(x: 0, y: FULL_HEIGHT-height, width: FULL_WIDTH, height: height)
            self.view.addSubview(view)
            self.view.bringSubview(toFront:view)
        })
    }
    //hide all sub views
    func hideAllSubViews()  {
        self.view.endEditing(true)

        self.pickupDetailsView.frame = CGRect.init(x: 0, y: FULL_HEIGHT, width: FULL_WIDTH, height: self.pickupDetailsView.frame.size.height)
        self.beginView.frame = CGRect.init(x: 0, y: FULL_HEIGHT, width: FULL_WIDTH, height: self.beginView.frame.size.height)
        self.completeView.frame = CGRect.init(x: 0, y: FULL_HEIGHT, width: FULL_WIDTH, height: self.completeView.frame.size.height)
    }
    
    //share current status
    func rideStatusServices(status:String)  {
        let rideObj = RideServices()
        rideObj.whereAm(onride_id: self.onride_id, status: status,onride_otp:self.otpTF.text!, onSuccess: {response in
            HPLActivityHUD.dismiss()
            let serviceStatus:NSString = response.value(forKey: "status") as! NSString
            if serviceStatus.isEqual(to: STATUS_TRUE){
            if status == "ontheway"{
                self.beginBtn.config(color: .white, size: 17, align: .center, title: "begin_ride")
                self.beginBtn.backgroundColor = GREEN_COLOR
                self.showLocationTipView()
                self.animateView(view: self.beginView)
            }else if status == "onride"{
//                self.getLocationService()
                self.showLocationTipView()
                self.animateView(view: self.completeView)
            }
            }else if serviceStatus.isEqual(to: STATUS_FALSE){
                Utility.shared.showAlert(msg: response.value(forKey: "message") as! String, status: "")
            }
        })
    }
    
    //get distance from two coordination from google api
    func getDistance()  {
        let googleObj = GoogleLocationService()
        googleObj.getDistance(drop: self.dropCoordinate, pickup: self.pickupCoordinate, onSuccess: {response in
            let responseArray:NSArray =  response.value(forKey: "rows") as! NSArray
            let detailsDict:NSDictionary = responseArray.object(at: 0) as! NSDictionary
            let elementsArray:NSArray = detailsDict.value(forKey: "elements") as! NSArray
            let distanceDict:NSDictionary = elementsArray.object(at: 0) as! NSDictionary
            let status:String = distanceDict.value(forKey: "status") as! String
            if status == "ZERO_RESULTS"{
            }else if status == "OVER_QUERY_LIMIT"{
                self.getDistance()
            }else{
                let getDistance = distanceDict.value(forKeyPath: "distance.text") as! String
                var setValue = " km"
                setValue = " m"
                let value = Utility.shared.removeSuffic(getDistance, setValue)
                let convertDouble = Double(value)
                let changeTomiles = Utility.shared.distanceString(for: convertDouble!)
                let doubletoStr = String(format: "%.1f", changeTomiles)
                let getMitoDistance = "\(doubletoStr) mi"
                self.completeRideService(km: getMitoDistance)
            }
        })
    }
    func completeRideService(km:String)  {
        let rideObj = RideServices()
        rideObj.completeRide(onride_id: self.onride_id, distance: km, onSuccess: {response in
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                HPLActivityHUD.dismiss()
                let type:NSString = response.value(forKey: "type") as! NSString
                self.disconnectSocket()
                self.locationManager.stopUpdatingLocation()
                if type == "cash"{
                    let completeObj = RideCompletedPage()
                    completeObj.onride_id = self.onride_id
                    completeObj.modalPresentationStyle = .fullScreen
                    self.present(completeObj, animated: true, completion: nil)
                }else if type == "card"{
                   // AJAlertController.initialization().showAlertWithOkButton(aStrMessage: Utility.shared.getLanguage()?.value(forKey: "ask_user_payment") as! String, status: "", completion: { (index, title) in
                    
                    let message = "ask_user_payment"
                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage: message, status: "", completion: { (index, title) in
                        let completeObj = RideCompletedPage()
                        completeObj.modalPresentationStyle = .fullScreen
                        completeObj.onride_id = self.onride_id
                        self.present(completeObj, animated: true, completion: nil)
                    })

                }
            }
        })
    }
    //get ride details for history
    func getRideDetails(type:String)  {
        let rideObj =  RideServices()
        rideObj.getRideDetails(onride_id: self.onride_id, type: type, onSuccess: {response in
            HPLActivityHUD.dismiss()
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                
                let drop_lat:Double =  Utility.shared.convertToDouble(string: response.value(forKey: "drop_lat")as! String)
                let drop_lng:Double = Utility.shared.convertToDouble(string: response.value(forKey: "drop_lng")as! String)
                let pick_lat:Double = Utility.shared.convertToDouble(string: response.value(forKey: "pickup_lat")as! String)
                let pick_lng:Double = Utility.shared.convertToDouble(string: response.value(forKey: "pickup_lng")as! String)
                
                self.pickupCoordinate = CLLocationCoordinate2D.init(latitude: pick_lat, longitude: pick_lng)
                self.dropCoordinate = CLLocationCoordinate2D.init(latitude: drop_lat, longitude: drop_lng)
                if type == "accepted"{
                    self.customerPickupLocationLbl.text = response.value(forKey: "pickup_location") as? String
                    self.customerName.text = response.value(forKey: "user_name") as? String
                    self.animateView(view: self.pickupDetailsView)
                    self.getLocationService()
                    self.showLocationTipView()
                }else if type == "ontheway"{
                    self.getLocationService()
                    self.showLocationTipView()
                    self.animateView(view: self.beginView)
                }else if type == "onride"{
                    self.customerDropLocationLbl.text = response.value(forKey: "drop_location") as? String
                    self.animateView(view: self.completeView)
                    self.getLocationService()
                    self.showLocationTipView()
                }

            }
        })
    }
    
    //MARK: Textfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            self.otpTF.setAsValidTF()
            self.otpBorderLbl.backgroundColor = SEPARTOR_COLOR
            let set = NSCharacterSet.init(charactersIn:ALPHA_NUMERIC_PREDICT)
            let characterSet = CharacterSet(charactersIn: string)
            return set.isSuperset(of: characterSet)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.animateView(view: self.beginView)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           self.view.endEditing(true)
           return true

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
    

}
