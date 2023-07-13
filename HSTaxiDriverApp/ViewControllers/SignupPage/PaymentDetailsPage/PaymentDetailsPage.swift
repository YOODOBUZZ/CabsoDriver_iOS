//
//  PaymentDetailsPage.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 20/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import GoogleMobileAds


class PaymentDetailsPage: UIViewController,brainTreeDelegate {

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var brainTreeSelectionLbl: UILabel!
    @IBOutlet var CodSelectionLbl: UILabel!
    @IBOutlet var brainTreeLbl: UILabel!
    @IBOutlet var byCashLbl: UILabel!
    @IBOutlet var nextBtn: UIButton!
    var chooseBrainTree = Bool()
    var chooseByCash = Bool()
    var viewType = String()
    var paymentDict = NSDictionary()
    var paymentType = String()
    var type = String()

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
            self.brainTreeSelectionLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.brainTreeSelectionLbl.textAlignment = .right
            self.brainTreeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.brainTreeLbl.textAlignment = .right
            self.byCashLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.byCashLbl.textAlignment = .right

            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.textAlignment = .right
            self.nextBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else {
            self.view.transform = .identity
            self.brainTreeSelectionLbl.transform = .identity
            self.brainTreeSelectionLbl.textAlignment = .left
            self.brainTreeLbl.transform = .identity
            self.brainTreeLbl.textAlignment = .left
            self.byCashLbl.transform = .identity
            self.byCashLbl.textAlignment = .left
            self.nextBtn.transform = .identity

            self.titleLbl.transform = .identity
            self.titleLbl.textAlignment = .left
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: set up intial details
    func setupInitialDetails()  {
        self.chooseBrainTree = false
        self.chooseByCash = false
        self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "payment_management")
        self.nextBtn.config(color: .white, size: 17, align: .center, title: "next")
        self.nextBtn.cornerMiniumRadius()
        self.nextBtn.backgroundColor = PRIMARY_COLOR
        self.brainTreeLbl.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, text: "by_account")
        self.byCashLbl.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, text: "by_cash")
        self.navigationView.elevationEffect()
        if self.viewType == EDIT_VIEW {
            HPLActivityHUD.showActivity(with: .withMask)
            self.getPaymentDetailsService()
        }
        if self.type == "1" {
            self.nextBtn.isHidden = true
        }
        if IS_IPHONE_X {
            let adjustFrame = nextBtn.frame
            nextBtn.frame = CGRect.init(x: adjustFrame.origin.x, y: adjustFrame.origin.y-2, width: adjustFrame.size.width, height: adjustFrame.size.height)
        }
        self.bannerAds()
    }

    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func brainTreeBtnTapped(_ sender: Any) {
        let addBrainTreeObj = BrainTreeDetailsPage()
        if self.viewType == EDIT_VIEW  && self.paymentType == "bankaccount"{
            addBrainTreeObj.viewType = EDIT_VIEW
            addBrainTreeObj.paymentDict = self.paymentDict
        }
        addBrainTreeObj.delegate = self
        addBrainTreeObj.modalPresentationStyle = .fullScreen
        self.navigationController?.present(addBrainTreeObj, animated: true, completion: nil)
    }
    
    @IBAction func byCashBtnTapped(_ sender: Any) {
        HPLActivityHUD.showActivity(with: .withMask)
        let  paymentObj = UserServices()
        paymentObj.updatePaymentDetails(type: "cash", routing_no: EMPTY_STRING, bank_ac: EMPTY_STRING, name: EMPTY_STRING, address: EMPTY_STRING, onSuccess:{ response in
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                self.chooseByCash = true
                self.brainTreeSelectionLbl.backgroundColor = .clear
                self.CodSelectionLbl.backgroundColor = PRIMARY_COLOR
                if self.type != "1" {
                Utility.shared.getStatusService()
                }else{
                    HPLActivityHUD.dismiss()
                }
              }
            })
    }
    
    //MARK: get payment details
    func getPaymentDetailsService() {
        let getPaymentObj = UserServices()
        getPaymentObj.getPaymentInfo(onSuccess: {response in
            HPLActivityHUD.dismiss()
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                self.setPaymentDetails(paymentDict: response)
            }
        })
    }
    
    //set payment details
    func setPaymentDetails(paymentDict:NSDictionary)  {
        paymentType =  paymentDict.value(forKey: "type") as! String
        if paymentType == "bankaccount" {
            chooseBrainTree = true
            self.brainTreeSelectionLbl.backgroundColor = PRIMARY_COLOR
            self.CodSelectionLbl.backgroundColor = .clear
            self.paymentDict = paymentDict
        }else{
            self.chooseByCash = true
            self.brainTreeSelectionLbl.backgroundColor = .clear
            self.CodSelectionLbl.backgroundColor = PRIMARY_COLOR
        }
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        if self.chooseByCash || self.chooseBrainTree {
            let vehicleInsObj = VehicleInspectionPage()
            self.navigationController?.pushViewController(vehicleInsObj, animated: true)
        }else{
            Utility.shared.showAlert(msg: "choose_payment", status: "1")
        }
    }
    
    //MARK: brain tree details page delegate
    func BTdetailsStatus(enable: Bool) {
        if enable {
            chooseBrainTree = enable
            self.brainTreeSelectionLbl.backgroundColor = PRIMARY_COLOR
            self.CodSelectionLbl.backgroundColor = .clear
            if self.type != "1" {
                HPLActivityHUD.showActivity(with: .withMask)
                Utility.shared.getStatusService()
            }else{
                self.getPaymentDetailsService()
                HPLActivityHUD.dismiss()
            }
        }
    }
    

}
extension PaymentDetailsPage: GADBannerViewDelegate {
    func bannerAds() {
        if (BANNER_AD_ENABLED == true) {
            self.bannerView.isHidden = true
            self.configAds()
        }
        else {
            self.bannerView.isHidden = true
        }
    }
    func configAds()  {
        bannerView.adUnitID = AD_UNIT_ID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
    //banner view delegate
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.isHidden = false
    }
//    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
//        print("BANNER ERROR \(error.localizedDescription)")
//    }
}
