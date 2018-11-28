//
//  Toaster.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 25/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import Foundation
import Toast_Swift

//This class contains a couple method as shortcuts to the pod 'Toast_Swift'
class Toaster {
    
    static func makeSuccesToast(view : UIView?, text : String) {
        guard let view = view else { return }
        view.makeToast(text, duration: 2.0,
                       style: toastStyle(), completion: nil)
    }
    
    static func makeErrorToast(view : UIView?, text : String) {
        guard let view = view else { return }
        view.makeToast(text, duration: 4.0,
                       style: toastStyle(), completion: nil)
    }
    
    static func toastStyle() -> ToastStyle {
        var style = ToastStyle()
        style.backgroundColor = UIColor.gray
        return style
    }
}
