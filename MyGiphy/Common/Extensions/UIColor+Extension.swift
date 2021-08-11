//
//  UIColor+Extension.swift
//  MyGiphy
//
//  Created by Abhishek Vasudev on 05/08/21.
//

import UIKit

extension UIColor {    
    convenience init(redValue: Int, greenValue: Int, blueValue: Int, withAlpha: CGFloat) {
        self.init(red: CGFloat(redValue)/255,
                  green: CGFloat(greenValue)/255,
                  blue: CGFloat(blueValue)/255,
                  alpha: withAlpha)
    }
}
