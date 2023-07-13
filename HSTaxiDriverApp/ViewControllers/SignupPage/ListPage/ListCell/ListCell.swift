//
//  ListCell.swift
//  HSTaxiDriverApp
//
//  Created by APPLE on 28/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet var selectIcon: UIImageView!
    @IBOutlet var listNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        listNameLbl.config(color: TEXT_PRIMARY_COLOR, size: 15, align: .left, text: EMPTY_STRING)
        self.selectIcon.isHidden = true
        self.changeToRTL()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.listNameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.listNameLbl.textAlignment = .right
            self.selectIcon.transform = CGAffineTransform(scaleX: -1, y: 1)

        }
        else {
            self.listNameLbl.transform = .identity
            self.listNameLbl.textAlignment = .left
            self.selectIcon.transform = .identity

        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
