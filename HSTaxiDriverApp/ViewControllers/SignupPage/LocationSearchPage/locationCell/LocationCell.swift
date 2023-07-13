//
//  LocationCell.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 19/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

    @IBOutlet var location_icon: UIImageView!
    @IBOutlet var locationSecondaryLbl: UILabel!
    @IBOutlet var locationPrimaryLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        locationSecondaryLbl.config(color: TEXT_TERTIARY_COLOR, size: 13, align: .left, text: "")
        locationPrimaryLbl.config(color: TEXT_PRIMARY_COLOR, size: 15, align: .left, text: "")
        self.changeToRTL()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.locationSecondaryLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.locationSecondaryLbl.textAlignment = .right
            self.locationPrimaryLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.locationPrimaryLbl.textAlignment = .right

        }
        else {
            self.locationPrimaryLbl.transform = .identity
            self.locationPrimaryLbl.textAlignment = .left
            self.locationSecondaryLbl.transform = .identity
            self.locationSecondaryLbl.textAlignment = .right

        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func configCell(locationDict:NSDictionary) {
        if locationDict.value(forKey: "address_second") == nil {
            locationSecondaryLbl.text = locationDict.value(forKey: "address_full") as? String
        }else{
            locationSecondaryLbl.text = locationDict.value(forKey: "address_second") as? String
        }
        locationPrimaryLbl.text = locationDict.value(forKey: "address_first") as? String
        location_icon.image = #imageLiteral(resourceName: "locaiton_search")
        locationSecondaryLbl.isHidden = false
    }
   
    
}
