//
//  HSView+UIView.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 14/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import Foundation
extension UIView{
    
    func elevationEffect() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        self.layer.shadowRadius = 2;
        self.layer.shadowOpacity = 0.5;
    }
    
    func cornerViewRadius() {
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    
    func cornerViewMiniumRadius() {
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    func setBorder(color:UIColor,width:CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
}


