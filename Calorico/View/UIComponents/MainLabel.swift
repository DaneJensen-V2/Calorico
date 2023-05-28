//
//  MainLabel.swift
//  Calorico
//
//  Created by Dane Jensen on 4/4/23.
//

import UIKit

class MainLabel: UILabel {
    
    enum labelTypeEnum {
        case heading
        case medium
        case base
        case percent
        case subheading
        case calorieHeading
    }
    
    enum colorStyle {
        case black
        case white
        case lightGray
    }
    
    public private(set) var labelType: labelTypeEnum
    public private(set) var labelText: String
    public private(set) var labelColor: colorStyle
    
    init(labelText: String, labelType: labelTypeEnum, labelColor: colorStyle) {
        self.labelText = labelText
        self.labelType = labelType
        self.labelColor = labelColor
        
        super.init(frame: .zero)
        self.configureLabelStyle()
        self.configureLabelColor()
        
        self.translatesAutoresizingMaskIntoConstraints = false //For AutoLayout
        let attributedString = NSMutableAttributedString(string: labelText)
        self.attributedText = attributedString //Setup Label to AttributedString for custom font
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabelColor() {
        switch labelColor {
        case .black:
            self.textColor = UIColor.black
        case .white:
            self.textColor = UIColor.white
        case .lightGray:
            self.textColor = UIColor.lightGray
        }
        
    }
    
    private func configureLabelStyle() {
        switch labelType {
        case .heading:
            self.font = UIFont(name: "Poppins-ExtraBold", size: 34)
        case .percent:
            self.font = UIFont(name: "Poppins-Medium", size: 24)
        case .medium:
            self.font = UIFont(name: "Poppins-Bold", size: 16)
        case .base:
            self.font = UIFont(name: "Poppins-Bold", size: 12)
        case .subheading:
            self.font = UIFont(name: "Poppins-Regular", size: 14)
        case .calorieHeading:
            self.font = UIFont(name: "Poppins-SemiBold", size: 52)
        }
        
    }
}
