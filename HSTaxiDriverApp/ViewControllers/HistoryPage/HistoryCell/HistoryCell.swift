//
//  HistoryCell.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 20/04/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet var idLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var priceLbl: UILabel!
    
    @IBOutlet weak var statusIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.idLbl.config(color: TEXT_SECONDARY_COLOR, size: 13, align: .left, text: EMPTY_STRING)
        self.timeLbl.config(color: TEXT_PRIMARY_COLOR, size: 16, align: .left, text: EMPTY_STRING)
        self.changeTORTL()
    }
    func changeTORTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.idLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.idLbl.textAlignment = .right
            self.priceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.priceLbl.textAlignment = .right
            self.timeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.timeLbl.textAlignment = .right
            self.statusIcon.transform = CGAffineTransform(scaleX: -1, y: 1)

        }
        else {
            self.idLbl.transform = .identity
            self.idLbl.textAlignment = .left
            self.priceLbl.transform = .identity
            self.priceLbl.textAlignment = .left
            self.timeLbl.transform = .identity
            self.timeLbl.textAlignment = .left
            self.statusIcon.transform = .identity

        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
       
    func config(historyDict:NSDictionary)  {
        //Set time
        let createdDate = (historyDict.value(forKey: "pickup_time") as AnyObject).doubleValue//time stamp
        self.timeLbl.text = Utility.shared.timeStamp(stamp: createdDate!, format: "EEE, MMM d, YYYY, h:mm a")
        let category_name = historyDict.value(forKey: "category_name") as! String
        let vehicle_no = historyDict.value(forKey: "vehicle_no") as! String //vehicle no

        self.idLbl.text = "\(category_name) \(vehicle_no)"
        let status:String = (historyDict.value(forKey: "ride_status") as? String)!
        if status == "cancelled" {
            self.priceLbl.isHidden = true
            statusIcon.image = UIImage.init(named: "ride_cancelled_icon.png")
        }else if status == "completed"{
            statusIcon.image = UIImage.init(named: "ride_completed_icon.png")
            self.priceLbl.isHidden = false
            let basePrice:NSNumber = historyDict.value(forKey: "total_price") as! NSNumber
            self.priceLbl.text = "\(Utility().currency()) \(Double(truncating: basePrice).clean)"
        }
        self.changeTORTL()
    }
}
