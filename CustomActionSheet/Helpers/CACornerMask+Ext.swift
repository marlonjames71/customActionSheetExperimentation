//
//  CACornerMask+Ext.swift
//  CustomActionSheet
//
//  Created by Raskin, Marlon on 7/1/21.
//

import UIKit

extension CACornerMask {
    
    /// Applies mask to all corners
    public static var allCorners: CACornerMask {
        [.layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
    }
    
    /// Applies mask to top left and top right corners
    public static var topCorners: CACornerMask {
        [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    /// Applies mask to bottom left and bottom right corners
    public static var bottomCorners: CACornerMask {
        [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    /// Applies mask to top left and bottom left corners
    public static var leftCorners: CACornerMask {
        [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
        
    /// Applies mask to top right and bottom right corners
    public static var rightCorners: CACornerMask {
        [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
}
