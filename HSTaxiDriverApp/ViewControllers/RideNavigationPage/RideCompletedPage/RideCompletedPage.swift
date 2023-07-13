//
//  RideCompletedPage.swift
//  HSTaxiDriverApp
//
//  Created by APPLE on 14/04/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class RideCompletedPage: UIViewController {
    
    @IBOutlet var navigationView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var userDetailLbl: UILabel!
    @IBOutlet var userPic: UIImageView!
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var grandTotalLbl: UILabel!
    @IBOutlet var totalAmtLbl: UILabel!
    @IBOutlet var rideSummary: UILabel!
    @IBOutlet var minimumLbl: UILabel!
    @IBOutlet var parkingLbl: UILabel!
    @IBOutlet var rideLbl: UILabel!
    @IBOutlet var parkingAmtLbl: UILabel!
    @IBOutlet var rideAmtLbl: UILabel!
    @IBOutlet var paymentLbl: UILabel!
    @IBOutlet var minimumAmtLbl: UILabel!
    @IBOutlet var paymentTypeLbl: UILabel!
    @IBOutlet var collectBtn: UIButton!
    var paymentDict = NSDictionary()

    var onride_id = String()
    var totalAmt = NSNumber()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupInitialDetails()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.changeToRTL()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:initial setup
    func setupInitialDetails(){
        Utility.shared.fetchAdminData()
        self.navigationView.elevationEffect()
        self.userPic.makeItRound()
        self.getPaymentDetails()
        
        self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "ride_completion")
        self.userDetailLbl.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, text: "user_detail")
        self.userNameLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: EMPTY_STRING)
        self.rideLbl.config(color: TEXT_PRIMARY_COLOR, size: 15, align: .left, text: EMPTY_STRING)
        self.grandTotalLbl.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .right, text: "grand_total")
        self.totalAmtLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .right, text: EMPTY_STRING)

        self.rideSummary.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, text: "ride_summary")
        self.paymentLbl.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, text: "payment_method")
        self.paymentTypeLbl.config(color: TEXT_SECONDARY_COLOR, size: 17, align: .left, text: EMPTY_STRING)
      
        self.minimumLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .left, text: "ride_fare")
        self.rideLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .left, text: "tax")
        self.parkingLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .left, text: "total_bill")
        self.minimumAmtLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .right, text: EMPTY_STRING)
        self.rideAmtLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .right, text: EMPTY_STRING)
        self.parkingAmtLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .right, text: EMPTY_STRING)

        self.collectBtn.config(color: .white, size: 17, align: .center, title: "collect")
        self.collectBtn.cornerMiniumRadius()
        self.collectBtn.backgroundColor = PRIMARY_COLOR
    }
    
    func setCompleteionDetails(paymentDict:NSDictionary) {
   
        let rideFare:NSNumber = paymentDict.value(forKey: "ride_fare") as! NSNumber
        let tax:NSNumber = paymentDict.value(forKey: "ride_tax") as! NSNumber
        totalAmt = paymentDict.value(forKey: "ride_total") as! NSNumber
        self.userNameLbl.text = paymentDict.value(forKey: "username") as? String
        self.totalAmtLbl.text = "\(String(describing: Utility().currency())) \(totalAmt)"
        self.rideAmtLbl.text = "\(String(describing: Utility().currency())) \(tax)" //tax
        self.minimumAmtLbl.text = "\(Utility().currency()) \(rideFare)"//ride fare
        self.parkingAmtLbl.text = "\(Utility().currency()) \(totalAmt)" //total amt
        self.userPic.sd_setImage(with: URL(string: paymentDict.value(forKey: "user_image") as! String ), placeholderImage: #imageLiteral(resourceName: "placeholder_image"))
        self.paymentTypeLbl.text = paymentDict.value(forKey: "payment_type") as? String
        if self.paymentTypeLbl.text?.lowercased() == "cash" {
            self.paymentTypeLbl.text = Utility.shared.getLanguage()?.value(forKey: paymentTypeLbl.text!) as? String
        }
        else {
            self.paymentTypeLbl.text = Utility.shared.getLanguage()?.value(forKey: "card") as? String

        }
    }

    @IBAction func backBtnTapped(_ sender: Any) {
        Utility.shared.goToHomePage()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.textAlignment = .right
            self.userDetailLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.userDetailLbl.textAlignment = .right
            self.userNameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.userNameLbl.textAlignment = .right
            self.grandTotalLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.grandTotalLbl.textAlignment = .left
            self.totalAmtLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.totalAmtLbl.textAlignment = .left
            self.rideSummary.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.rideSummary.textAlignment = .right
            self.minimumLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.minimumLbl.textAlignment = .right
            self.parkingLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.parkingLbl.textAlignment = .right
            self.rideLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.rideLbl.textAlignment = .right
            self.parkingAmtLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.parkingAmtLbl.textAlignment = .left
            self.rideAmtLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.rideAmtLbl.textAlignment = .left
            self.paymentLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.paymentLbl.textAlignment = .right
            self.minimumAmtLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.minimumAmtLbl.textAlignment = .left
            self.paymentTypeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.paymentTypeLbl.textAlignment = .right
            self.collectBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.userPic.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else {
            self.view.transform = .identity
            self.titleLbl.transform = .identity
            self.titleLbl.textAlignment = .left
            self.userDetailLbl.transform = .identity
            self.userDetailLbl.textAlignment = .left
            self.userNameLbl.transform = .identity
            self.userNameLbl.textAlignment = .left
            self.grandTotalLbl.transform = .identity
            self.grandTotalLbl.textAlignment = .right
            self.totalAmtLbl.transform = .identity
            self.totalAmtLbl.textAlignment = .right
            self.rideSummary.transform = .identity
            self.rideSummary.textAlignment = .left
            self.minimumLbl.transform = .identity
            self.minimumLbl.textAlignment = .left
            self.parkingLbl.transform = .identity
            self.parkingLbl.textAlignment = .left
            self.rideLbl.transform = .identity
            self.rideLbl.textAlignment = .left
            self.rideAmtLbl.transform = .identity
            self.rideAmtLbl.textAlignment = .right
            self.parkingAmtLbl.transform = .identity
            self.parkingAmtLbl.textAlignment = .right
            self.paymentLbl.transform = .identity
            self.paymentLbl.textAlignment = .left
            self.minimumAmtLbl.transform = .identity
            self.minimumAmtLbl.textAlignment = .right
            self.paymentTypeLbl.transform = .identity
            self.paymentTypeLbl.textAlignment = .left
            self.collectBtn.transform = .identity
            self.userPic.transform = .identity
        }
    }
    @IBAction func collectBtnTapped(_ sender: Any) {
        let paymentObj = RideServices()
        if self.paymentDict.value(forKey: "basefare") as? NSNumber != nil {
            paymentObj.paybyCash(amount: totalAmt.stringValue, onride_id: self.onride_id, basefare: self.paymentDict.value(forKey: "basefare") as? NSNumber ?? 0, commissionamount: self.paymentDict.value(forKey: "commissionamount") as? NSNumber ?? 0, tax: self.paymentDict.value(forKey: "ride_tax") as! NSNumber, customer_id: self.paymentDict.value(forKey: "rideuserid") as? String ?? "", onSuccess: {response in
               
                let status:NSString = response.value(forKey: "status") as! NSString
                if status.isEqual(to: STATUS_TRUE){
                    let successObj = SuccessPage()
                    successObj.modalPresentationStyle = .fullScreen
                    successObj.amount = Double(self.totalAmt)
                    self.present(successObj, animated: true, completion: nil)
                }else if status.isEqual(to: STATUS_FALSE){
                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage: response.value(forKey: "message") as! String, status: "", completion: { (index, title) in
                        let successObj = SuccessPage()
                        successObj.modalPresentationStyle = .fullScreen
                        successObj.amount = Double(self.totalAmtLbl.text!)!
                        self.present(successObj, animated: true, completion: nil)
                    })
                }
            })
        }
    }
    //get payment details
    func getPaymentDetails(){
        let paymentInfo = RideServices()
        paymentInfo.getCompletedRideDetails(onride_id: self.onride_id, onSuccess: {response in
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                self.setCompleteionDetails(paymentDict: response)
                self.paymentDict = response

            }
        })
    }
}
