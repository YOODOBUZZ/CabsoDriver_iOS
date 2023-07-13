//
//  HistoryPage.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 19/04/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HistoryPage: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var navigationView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet var bookingBtn: UIButton!
    @IBOutlet var historyBtn: UIButton!
    @IBOutlet var historyBorderLbl: UILabel!
    @IBOutlet var bookingBorderLbl: UILabel!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var bookingView: UIView!
    @IBOutlet var bookingTableView: UITableView!
    @IBOutlet var historyTableView: UITableView!
    @IBOutlet var historyView: UIView!
    @IBOutlet var no_resultView: UIView!
    @IBOutlet var noLbl: UILabel!
    var bookingArray = NSMutableArray()
    var historyArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpInitialDetails()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setUpInitialDetails()
        self.changeToRTL()
        self.bookingTableView.reloadData()
        self.historyTableView.reloadData()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.textAlignment = .right
            self.bookingBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.historyBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.noLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else {
            self.view.transform = .identity
            self.titleLbl.transform = .identity
            self.titleLbl.textAlignment = .left
            self.bookingBtn.transform = .identity
            self.historyBtn.transform = .identity
            self.noLbl.transform = .identity
        }
    }
    func setUpInitialDetails() {
        self.navigationView.elevationEffect()
        self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "your_rides")
        self.bookingBtn.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .center, title: "upcoming")
        self.historyBtn.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .center, title: "past")
        self.configBookingView()
        bookingTableView.register(UINib(nibName: "BookingCell", bundle: nil), forCellReuseIdentifier: "BookingCell")
        historyTableView.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
        self.bannerAds()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configBookingView()  {
        self.bookingBorderLbl.backgroundColor = PRIMARY_COLOR
        self.historyBorderLbl.backgroundColor = .clear
        self.bookingBtn.titleLabel?.textColor = TEXT_PRIMARY_COLOR
        self.historyBtn.titleLabel?.textColor = TEXT_SECONDARY_COLOR
        HPLActivityHUD.showActivity(with: .withMask)
        self.getDetails(type: "upcoming")
        noLbl.config(color: TEXT_TERTIARY_COLOR, size: 17, align: .center, text: "no_upcoming")

    }
    func configHistoryView()  {
        self.historyBorderLbl.backgroundColor = PRIMARY_COLOR
        self.bookingBorderLbl.backgroundColor = .clear
        self.historyBtn.titleLabel?.textColor = TEXT_PRIMARY_COLOR
        self.bookingBtn.titleLabel?.textColor = TEXT_SECONDARY_COLOR
        HPLActivityHUD.showActivity(with: .withMask)
        self.getDetails(type: "passed")
        noLbl.config(color: TEXT_TERTIARY_COLOR, size: 17, align: .center, text: "no_past")
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bookingBtnTapped(_ sender: Any) {
        self.configBookingView()
    }
    
    @IBAction func historyBtnTapped(_ sender: Any) {
        self.configHistoryView()
    }
    
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int{
        if (tableView == self.bookingTableView) {
            return bookingArray.count
        }else if(tableView == self.historyTableView){
            return historyArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var customCell = UITableViewCell()
        if (tableView == self.bookingTableView) {
            let bookingDict:NSDictionary =  self.bookingArray.object(at: indexPath.row) as! NSDictionary
            let bookingCell = tableView.dequeueReusableCell(withIdentifier: "BookingCell", for: indexPath) as! BookingCell
                bookingCell.config(bookingDict: bookingDict)
                customCell = bookingCell
        }else if(tableView == self.historyTableView){
            let historyDict:NSDictionary =  self.historyArray.object(at: indexPath.row) as! NSDictionary

            let historyCell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
                historyCell.config(historyDict: historyDict)
            customCell = historyCell
        }
        return customCell
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat{
            return 80
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        if (tableView == self.bookingTableView) {
            let bookingDict:NSDictionary =  self.bookingArray.object(at: indexPath.row) as! NSDictionary
            let status:String = (bookingDict.value(forKey: "ride_status") as? String)!
            let rideObj = RideNavigationPage()
                if status == "accepted"{
                    rideObj.viewType = "1"
                }else if status == "ontheway"{
                    rideObj.viewType = "2"
                }else if status == "onride"{
                    rideObj.viewType = "3"
                }
            rideObj.historyDict = bookingDict
            rideObj.onride_id = bookingDict.value(forKey: "onride_id") as! String
            rideObj.modalPresentationStyle = .fullScreen
            self.present(rideObj, animated: true, completion: nil)
            
        }else if(tableView == self.historyTableView){
//            let historyDict:NSDictionary =  self.historyArray.object(at: indexPath.row) as! NSDictionary
//            let historyDetailObj = HistoryDetailsPage()
//            historyDetailObj.onride_id = historyDict.value(forKey: "onride_id") as! String
//            historyDetailObj.historyDict = historyDict
//           self.present(historyDetailObj, animated: true)
        }
    }
    
    //get booking & history details from server
    func getDetails(type:String)  {
        let historyObj = RideServices()
        historyObj.rideHistory(type: type, onSuccess: {response in
            HPLActivityHUD.dismiss()
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                let tempArray : NSArray = response.value(forKey: "result") as! NSArray
                if type == "upcoming"{
                    self.bookingArray = tempArray.mutableCopy() as! NSMutableArray
                }else if type == "passed"{
                    self.historyArray = tempArray.mutableCopy() as! NSMutableArray
                }
                self.checkAvailability(type: type)
            }else{
                self.checkAvailability(type: type)
            }
        })
    }
    
    //check view availablity
    func checkAvailability(type:String) {
        self.bookingView.isHidden = true
        self.historyView.isHidden = true
        if type == "upcoming"{
            if self.bookingArray.count == 0{
                self.no_resultView.isHidden = false
            }else{
                self.no_resultView.isHidden = true
                self.bookingView.isHidden = false
                self.bookingTableView.reloadData()
            }
        }else if type == "passed"{
            if self.historyArray.count == 0{
                self.no_resultView.isHidden = false
            }else{
                self.no_resultView.isHidden = true
                self.historyView.isHidden = false
                self.historyTableView.reloadData()
            }
        }
    }
}
extension HistoryPage: GADBannerViewDelegate {
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
        let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: self.bookingTableView.frame.width, height: 50))
        self.bookingTableView.tableFooterView = bottomView
        self.historyTableView.tableFooterView = bottomView
    }
//    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
//        print("BANNER ERROR \(error.localizedDescription)")
//    }
}
