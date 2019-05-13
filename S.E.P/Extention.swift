//
//  extentions.swift
//  S.E.P
//
//  Created by Artem Golovanev on 11.05.2019.
//  Copyright © 2019 Artem Golovanev. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {

    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }

    static var customMilkWhite: UIColor = {
        return UIColor(r: 245, g: 245, b: 220)
    }()

    static var customDark: UIColor = {
        return UIColor(r: 105, g: 105, b: 105)
    }()
}
