//
//  CircleButton.swift
//  Calorico
//
//  Created by Dane Jensen on 4/3/23.
//

import UIKit

class CircleButton: UIButton {

       enum LabelType {
           case H1
           case H2
           case H3
       }

       enum ColorStyle {
           case orange
           case background

       }

       public private(set) var SymbolText: String
       public private(set) var SymbolSize: Double
       public private(set) var BGColor: ColorStyle
       public private(set) var buttonSize: Double

    init(SymbolText: String, BGColor: ColorStyle, SymbolSize: Double, buttonSize: Double) {
           self.SymbolText = SymbolText
           self.SymbolSize = SymbolSize
           self.BGColor = BGColor
           self.buttonSize = buttonSize

           super.init(frame: .zero)

           self.translatesAutoresizingMaskIntoConstraints = false // For AutoLayout

           configureBGColor()
           self.setImage(UIImage(systemName: SymbolText, withConfiguration: UIImage.SymbolConfiguration.init(pointSize: SymbolSize, weight: .bold)), for: .normal)
           self.tintColor = .white

           self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: buttonSize),
            self.heightAnchor.constraint(equalToConstant: buttonSize)

        ])

           self.layer.cornerRadius = buttonSize / 2

       }

       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

       private func configureBGColor() {
           switch BGColor {
           case .orange:
               self.backgroundColor = UIColor.orange
           case .background:
               self.backgroundColor = UIColor(named: "MainBG")

           }
       }

}
