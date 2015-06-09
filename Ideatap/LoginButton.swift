//
//  LoginButton.swift
//  Ideatap
//
//  Created by Joshua Kidd on 6/7/15.
//  Copyright (c) 2015 Ideatap. All rights reserved.
//

import Foundation
import UIKit

class LoginButton: UIButton {
    
    var loginIcon: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 2.0
    }
    
    func setFontIcon(icon: String) {
        loginIcon = UILabel(frame: CGRectMake(0, 0, 40.0, self.bounds.height))
        loginIcon.font = UIFont.fontAwesomeOfSize(16)
        loginIcon.textColor = UIColor.whiteColor()
        loginIcon.textAlignment = .Center
        loginIcon.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
        loginIcon.text = icon
        
        self.addSubview(loginIcon)
        self.sendSubviewToBack(loginIcon)

        self.setNeedsDisplay()
    }
    
}