//
//  HistoryDetailsPage.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 25/04/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import CoreLocation

class HistoryDetailsPage: UIViewController {

    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var vehicleNoLbl: UILabel!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var mapImgView: UIImageView!
    @IBOutlet var driverImgView: UIImageView!
    @IBOutlet var driverNameLbl: UILabel!
    @IBOutlet var reviewView: UIView!
    @IBOutlet var ratingLbl: UILabel!
    @IBOutlet var ratingView: UIView!
    @IBOutlet var cancelView: UIView!
    @IBOutlet var cancelLbl: UILabel!

    @IBOutlet var categoryImgView: UIImageView!
    @IBOutlet var categoryNameLbl: UILabel!
    @IBOutlet var meterPriceLbl: UILabel!
    @IBOutlet var dropTF: FloatLabelTextField!
    @IBOutlet var pickupTF: FloatLabelTextField!
    @IBOutlet var pickupTimeLbl: UILabel!
    @IBOutlet var dropTimeLbl: UILabel!
    @IBOutlet var billDetailsLbl: UILabel!
    @IBOutlet var rideInfoView: UIView!
    @IBOutlet var billInfoView: UIView!
    @IBOutlet var paymentInfoView: UIView!
    @IBOutlet var greenDot: UIView!
    @IBOutlet var redDot: UIView!
    @IBOutlet var dotLbl: UILabel!
    @IBOutlet var rideFareLbl: UILabel!
    @IBOutlet var taxLbl: UILabel!
    @IBOutlet var taxAmtLbl: UILabel!
    @IBOutlet var totalAmtLbl: UILabel!
    @IBOutlet var rideFareAmtLbl: UILabel!
    @IBOutlet var totalBillLbl: UILabel!
    @IBOutlet var paymentLbl: UILabel!
    @IBOutlet var paymentTypeLbl: UILabel!
    @IBOutlet var paymentAmtLbl: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var rideAgainView: UIView!
    var dropCoordination = CLLocationCoordinate2D()
    var pickCoordination = CLLocationCoordinate2D()
    var type = String()
    var onride_id = String()
    var rideDetails = NSDictionary()
    var historyDict = NSDictionary()
    var cancelEnable = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupInitialDetails()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setupInitialDetails()
        self.changeToRTL()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.timeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.timeLbl.textAlignment = .right
            self.vehicleNoLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.vehicleNoLbl.textAlignment = .right
            self.mapImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.driverImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.driverNameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.driverNameLbl.textAlignment = .right
            self.ratingLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.ratingLbl.textAlignment = .right
            self.cancelLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.categoryImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.categoryNameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.categoryNameLbl.textAlignment = .right
            self.meterPriceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.meterPriceLbl.textAlignment = .right
            self.dropTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.dropTF.textAlignment = .right
            self.pickupTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.pickupTF.textAlignment = .right
            self.pickupTimeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.pickupTimeLbl.textAlignment = .right
            self.dropTimeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.dropTimeLbl.textAlignment = .right
            self.billDetailsLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.billDetailsLbl.textAlignment = .right
            self.rideFareLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.rideFareLbl.textAlignment = .right
            self.totalBillLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.totalBillLbl.textAlignment = .right
            self.paymentLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.paymentLbl.textAlignment = .right
            self.paymentTypeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.paymentTypeLbl.textAlignment = .right
            self.paymentAmtLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.paymentAmtLbl.textAlignment = .left
            self.totalAmtLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.totalAmtLbl.textAlignment = .left
            self.taxLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.taxLbl.textAlignment = .right
            self.taxAmtLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.taxAmtLbl.textAlignment = .left
            self.rideFareAmtLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.rideFareAmtLbl.textAlignment = .left
        }
        else {
            self.view.transform = .identity
            self.timeLbl.transform = .identity
            self.timeLbl.textAlignment = .left
            self.vehicleNoLbl.transform = .identity
            self.vehicleNoLbl.textAlignment = .left
            self.mapImgView.transform = .identity
            self.driverImgView.transform = .identity
            self.driverNameLbl.transform = .identity
            self.driverNameLbl.textAlignment = .left
            self.ratingLbl.transform = .identity
            self.ratingLbl.textAlignment = .left
            self.cancelLbl.transform = .identity
            self.categoryImgView.transform = .identity
            self.categoryNameLbl.transform = .identity
            self.categoryNameLbl.textAlignment = .left
            self.meterPriceLbl.transform = .identity
            self.meterPriceLbl.textAlignment = .left
            self.dropTF.transform = .identity
            self.dropTF.textAlignment = .left
            self.pickupTF.transform = .identity
            self.pickupTF.textAlignment = .left
            self.pickupTimeLbl.transform = .identity
            self.pickupTimeLbl.textAlignment = .left
            self.dropTimeLbl.transform = .identity
            self.dropTimeLbl.textAlignment = .left
            self.billDetailsLbl.transform = .identity
            self.billDetailsLbl.textAlignment = .left
            self.rideFareLbl.transform = .identity
            self.rideFareLbl.textAlignment = .left
            self.totalBillLbl.transform = .identity
            self.totalBillLbl.textAlignment = .left
            self.paymentLbl.transform = .identity
            self.paymentLbl.textAlignment = .left
            self.paymentTypeLbl.transform = .identity
            self.paymentTypeLbl.textAlignment = .left
            self.paymentAmtLbl.transform = .identity
            self.paymentAmtLbl.textAlignment = .right
            self.totalAmtLbl.transform = .identity
            self.totalAmtLbl.textAlignment = .right
            self.taxLbl.transform = .identity
            self.taxLbl.textAlignment = .left
            self.taxAmtLbl.transform = .identity
            self.taxAmtLbl.textAlignment = .right
            self.rideFareAmtLbl.transform = .identity
            self.rideFareAmtLbl.textAlignment = .right
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:initial setup
    func setupInitialDetails()   {
        self.getPaymentDetails()
        scrollView.contentSize = CGSize.init(width:0 , height: 1200)
        self.navigationView.elevationEffect()
        self.cancelEnable = false
        
        timeLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: EMPTY_STRING)
        vehicleNoLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .left, text: EMPTY_STRING)
        
        driverImgView.makeItRound()


        driverNameLbl.config(color: TEXT_PRIMARY_COLOR, size: 18, align: .left, text: EMPTY_STRING)
        ratingLbl.config(color: TEXT_SECONDARY_COLOR, size: 10, align: .left, text: "you_rated")
        categoryImgView.makeItRound()
        categoryNameLbl.config(color: TEXT_PRIMARY_COLOR, size: 16, align: .left, text: EMPTY_STRING)
        meterPriceLbl.config(color: TEXT_PRIMARY_COLOR, size: 16, align: .left, text: EMPTY_STRING)

        pickupTF.config(color: TEXT_PRIMARY_COLOR, size: 15, align: .left, placeHolder: "pickup")
        dropTF.config(color: TEXT_PRIMARY_COLOR, size: 15, align: .left, placeHolder: "drop")
        pickupTimeLbl.config(color: TEXT_PRIMARY_COLOR, size: 12, align: .left, text: EMPTY_STRING)
        dropTimeLbl.config(color: TEXT_PRIMARY_COLOR, size: 12, align: .left, text: EMPTY_STRING)
        redDot.cornerViewRadius()
        greenDot.cornerViewRadius()
        redDot.backgroundColor = RED_COLOR
        greenDot.backgroundColor = GREEN_COLOR
        self.drawDottedLine(start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: self.dotLbl.frame.size.height), label: self.dotLbl)

        billDetailsLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "bill_details")
        paymentLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "payment")
      
        rideFareLbl.config(color: TEXT_TERTIARY_COLOR, size: 15, align: .left, text: "ride_fare")
        taxLbl.config(color: TEXT_TERTIARY_COLOR, size: 15, align: .left, text: "tax")
        totalBillLbl.config(color: TEXT_TERTIARY_COLOR, size: 15, align: .left, text: "total_bill")
        paymentTypeLbl.config(color: TEXT_TERTIARY_COLOR, size: 15, align: .left, text: EMPTY_STRING)
        
        rideFareAmtLbl.config(color: TEXT_TERTIARY_COLOR, size: 15, align: .right, text: EMPTY_STRING)
        taxAmtLbl.config(color: TEXT_TERTIARY_COLOR, size: 15, align: .right, text: EMPTY_STRING)
        totalAmtLbl.config(color: TEXT_TERTIARY_COLOR, size: 15, align: .right, text: EMPTY_STRING)
        paymentAmtLbl.config(color: TEXT_TERTIARY_COLOR, size: 15, align: .right, text: EMPTY_STRING)

        cancelLbl.config(color: RED_COLOR, size: 12, align: .center, text: "cancelled")

        
    }
    
    func setRideDetails(rideDict:NSDictionary)  {
        let drop_lat:Double =  Utility.shared.convertToDouble(string: rideDict.value(forKey: "drop_lat")as! String)
        let drop_lng:Double = Utility.shared.convertToDouble(string: rideDict.value(forKey: "drop_lng")as! String)
        let pick_lat:Double = Utility.shared.convertToDouble(string: rideDict.value(forKey: "pickup_lat")as! String)
        let pick_lng:Double = Utility.shared.convertToDouble(string: rideDict.value(forKey: "pickup_lng")as! String)
        
        self.pickCoordination = CLLocationCoordinate2D.init(latitude: pick_lat, longitude: pick_lng)
        self.dropCoordination = CLLocationCoordinate2D.init(latitude: drop_lat, longitude: drop_lng)
        
        
        mapImgView.sd_setImage(with: URL(string:"https://maps.googleapis.com/maps/api/staticmap?center=\(pick_lat),\(pick_lng)&zoom=16&size=400x200&sensor=false&key=\(GOOGLE_API_KEY)&maptype=roadmap&markers=color:red%7Clabel:S%7C\(pick_lat),\(pick_lng)"), placeholderImage: #imageLiteral(resourceName: "placeholder_image"))

//        self.getPolylineRoute()
        driverImgView.sd_setImage(with: URL(string:rideDict.value(forKey: "driver_image") as! String), placeholderImage: #imageLiteral(resourceName: "placeholder_image"))
        categoryImgView.sd_setImage(with: URL(string:rideDict.value(forKey: "onride_image") as! String), placeholderImage: #imageLiteral(resourceName: "placeholder_image"))

        let createdDate = (historyDict.value(forKey: "pickup_time") as AnyObject).doubleValue//time stamp
        let dateNew = Date(timeIntervalSince1970:createdDate!)
        print("date \(dateNew)")
        let dateFormat = DateFormatter()
        dateFormat.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormat.locale = NSLocale.current
        dateFormat.dateFormat = "EEE, MMM d, yyyy, h:mm a"
        self.timeLbl.text = dateFormat.string(from: dateNew)
        
        self.vehicleNoLbl.text = rideDict.value(forKey: "vehicle_no") as? String
        self.driverNameLbl.text = rideDict.value(forKey: "driver_name") as? String
        self.categoryNameLbl.text = historyDict.value(forKey: "category_name") as? String
        
        let rideFare:Int = rideDict.value(forKey: "ride_fare") as! Int
        let tax:Int = rideDict.value(forKey: "ride_tax") as! Int
        let totalAmt:Int = rideDict.value(forKey: "ride_total") as! Int
        
        self.meterPriceLbl.text = "\(Utility().currency()) \(totalAmt)"
        self.pickupTimeLbl.text = rideDict.value(forKey: "pickup_time") as? String
        self.dropTimeLbl.text  = rideDict.value(forKey: "drop_time") as? String
        self.pickupTF.text = rideDict.value(forKey: "pickup_location") as? String
        self.dropTF.text = rideDict.value(forKey: "drop_location") as? String
        self.rideFareAmtLbl.text = "\(Utility().currency()) \(rideFare)"
        self.taxAmtLbl.text = "\(Utility().currency()) \(tax)"
        self.totalAmtLbl.text = "\(Utility().currency()) \(totalAmt)"
        self.paymentTypeLbl.text = "Cash"
        self.paymentAmtLbl.text = "\(Utility().currency()) \(totalAmt)"
        
  
        
        let rideStatus = historyDict.value(forKey: "ride_status") as? String
        if rideStatus == "cancelled" {

            self.cancelView.isHidden = false
            self.rideAgainView.isHidden = true
        }else if rideStatus == "completed"{
            self.cancelView.isHidden = true
            self.rideAgainView.isHidden = false

        }else if rideStatus == "scheduled"{
            self.cancelEnable = true
        }

    }
    
    //draw dotted line from pickup to destination
    func drawDottedLine(start p0: CGPoint, end p1: CGPoint,label:UILabel) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = SEPARTOR_COLOR.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [7, 5] // 7 is the length of dash, 5 is length of the gap.
        shapeLayer.fillColor = UIColor.red.cgColor
        
        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        label.layer.addSublayer(shapeLayer)
        
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 1.5
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        pathAnimation.repeatCount = 1
        pathAnimation.autoreverses = false
        shapeLayer.add(pathAnimation, forKey: "strokeEnd")
        
        let fillColorAnimation = CABasicAnimation(keyPath: "fillColor")
        fillColorAnimation.duration = 1.5
        fillColorAnimation.fromValue =  UIColor.clear.cgColor
        fillColorAnimation.toValue =  UIColor.red.cgColor
        fillColorAnimation.repeatCount = 1
        fillColorAnimation.autoreverses = false
        shapeLayer.add(fillColorAnimation, forKey: "fillColor")
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
        
    //get payment details
    func getPaymentDetails(){
        let paymentInfo = RideServices()
        paymentInfo.getCompletedRideDetails(onride_id: self.onride_id, onSuccess: {response in
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
             self.setRideDetails(rideDict: response)
            }else{
                Utility.shared.showAlert(msg: response.value(forKey: "message") as! String, status: "")
            }
        })
    }
    
    //get location details from google api
    func getPolylineRoute(){
        let getLocationObj = GoogleLocationService()
        getLocationObj.getLocation(destinationCoordination: self.dropCoordination, pickupCoordination: self.pickCoordination, onSuccess: {response in
            HPLActivityHUD.dismiss()
            let status:String = response.value(forKey: "status") as! String
            if status == "OVER_QUERY_LIMIT"{
                self.getPolylineRoute()
            }else  if status == "ZERO_RESULTS"{
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
            print("points \(String(describing: points))")
            
            mapImgView.sd_setImage(with: URL(string:"https://maps.googleapis.com/maps/api/staticmap?size=600x400&path=\(String(describing: points))&key=\(GOOGLE_API_KEY)"), placeholderImage: #imageLiteral(resourceName: "placeholder_image"))

        }
    }
}


