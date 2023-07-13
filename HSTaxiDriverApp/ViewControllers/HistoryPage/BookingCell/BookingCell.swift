//
//  BookingCell.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 20/04/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class BookingCell: UITableViewCell {

    @IBOutlet var idLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var statusLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.idLbl.config(color: TEXT_SECONDARY_COLOR, size: 13, align: .left, text: EMPTY_STRING)
        self.statusLbl.config(color: TEXT_SECONDARY_COLOR, size: 13, align: .left, text: EMPTY_STRING)
        self.timeLbl.config(color: TEXT_PRIMARY_COLOR, size: 16, align: .left, text: EMPTY_STRING)
        self.changeToRTL()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.idLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.idLbl.textAlignment = .right
            self.statusLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.statusLbl.textAlignment = .right
            self.timeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.timeLbl.textAlignment = .right

        }
        else {
            self.idLbl.transform = .identity
            self.idLbl.textAlignment = .left
            self.statusLbl.transform = .identity
            self.statusLbl.textAlignment = .left
            self.timeLbl.transform = .identity
            self.timeLbl.textAlignment = .left

        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func config(bookingDict:NSDictionary)  {
        self.idLbl.text =  bookingDict.value(forKey: "vehicle_no") as? String
        let createdDate = (bookingDict.value(forKey: "pickup_time") as AnyObject).doubleValue//time stamp
        self.timeLbl.text = Utility.shared.timeStamp(stamp: createdDate!, format: "EEE, MMM d, YYYY, h:mm a")
        let status:String = (bookingDict.value(forKey: "ride_status") as? String)!
        if status == "accepted" {
            self.statusLbl.config(color: .darkGray, size: 14, align: .left, text: "accepted")
        }else if status == "onride" {
            self.statusLbl.config(color: .blue, size: 14, align: .left, text: "onride")
        }else if status == "scheduled"{
            self.statusLbl.config(color: GREEN_COLOR, size: 14, align: .left, text: "upcoming")
        }else if status == "ontheway"{
            self.statusLbl.config(color: .brown, size: 14, align: .left, text: "ontheway")
        }
        self.changeToRTL()
    }
    
}
