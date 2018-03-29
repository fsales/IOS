//
//  FATextView.swift
//  FakeApp
//
//  Created by Pedro Henrique on 26/09/2017.
//  Copyright © 2017 IESB. All rights reserved.
//

import UIKit

@IBDesignable
class FATextField: UITextField {
    
    @IBInspectable
    var editingRectInset: CGFloat = 10
    
    var validationError = false {
        didSet {
            if validationError && !isEditing {
                layer.borderColor = UIColor.red.cgColor
                backgroundColor = UIColor(named: "validationFailedBackgroundColor")
            }else {
                layer.borderColor = UIColor.lightGray.cgColor
                backgroundColor = UIColor.groupTableViewBackground.withAlphaComponent(0.5)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.borderWidth = 1
        let attributes = [NSAttributedStringKey.font.rawValue:UIFont.vertrina(ofSize: 26)]
        typingAttributes = attributes
        defaultTextAttributes = attributes
        validationError = false
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: bounds).insetBy(dx: editingRectInset, dy: editingRectInset)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: bounds).insetBy(dx: editingRectInset, dy: editingRectInset)
    }
    
}
