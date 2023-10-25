//
//  MacroView.swift
//  Calorico
//
//  Created by Dane Jensen on 4/4/23.
//

import UIKit
import SwiftUI

class MacroView: UIView {

    enum FoodTypes {
        case protein
        case fat
        case carbs
    }

    public private(set) var FoodType: FoodTypes
    public private(set) var maxValue: Double
    public private(set)  var currentValue: Double

    let circleView = UIView()
    let images = Images()
    let colors = Colors()

    let progressMeter = UIView()
    let screenBounds = UIScreen.main.bounds
    var percentLabel = UILabel()
    var checkImage = UIImageView()
    var amountLabel = UILabel()

     init(FoodType: FoodTypes, maxValue: Double, currentValue: Double) {

        self.FoodType = FoodType
        self.maxValue = maxValue
        self.currentValue = currentValue

         super.init(frame: .zero)
         // setupView()

    }

    func updateValues(newMax: Double, newValue: Double) {

        self.maxValue = newMax

        self.currentValue = newValue

        setupView()

    }

       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

       func setupView() {
           // Can do the setup of the view, including adding subviews

           backgroundColor = .white
           self.layer.cornerRadius = 20
           self.clipsToBounds = true
           heightAnchor.constraint(equalToConstant: 100).isActive = true
           widthAnchor.constraint(equalToConstant: screenBounds.width - 60).isActive = true
           self.translatesAutoresizingMaskIntoConstraints = false
           setupProgress()
           setupPercent()
           setupCounter()
       }

    func setupProgress() {

        progressMeter.backgroundColor = colors.lightGray

        progressMeter.frame = CGRect(x: 0, y: 0, width: getPosition(value: currentValue), height: 100)

        if currentValue >= maxValue {
            meterFull()
        }

        addSubview(progressMeter)

       // circleView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

    }

    func setupPercent() {

        circleView.layer.cornerRadius = 40
        circleView.backgroundColor = .orange

        circleView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(circleView)

       // circleView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        circleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        circleView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: 80).isActive = true

        percentLabel = MainLabel(labelText: getPercent(), labelType: .percent, labelColor: .white)
        circleView.addSubview(percentLabel)
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        percentLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor).isActive = true
        percentLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor).isActive = true

        checkImage = UIImageView(image: images.check)
        circleView.addSubview(checkImage)
        checkImage.translatesAutoresizingMaskIntoConstraints = false
        checkImage.centerYAnchor.constraint(equalTo: circleView.centerYAnchor).isActive = true
        checkImage.centerXAnchor.constraint(equalTo: circleView.centerXAnchor).isActive = true
        checkImage.heightAnchor.constraint(equalToConstant: 52).isActive = true
        checkImage.widthAnchor.constraint(equalToConstant: 52).isActive = true
        checkImage.isHidden = true

    }

    func getPercent() -> String {
        let percent = currentValue / maxValue
        let roundedPercent = Int((percent * 100).rounded())

        return String(roundedPercent) + "%"
    }

       func setupCounter() {
          let container = UIView()

           container.layer.cornerRadius = 20
           container.backgroundColor = UIColor(named: "MainBG")

           addSubview(container)
           container.translatesAutoresizingMaskIntoConstraints = false
           container.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
           container.trailingAnchor.constraint(equalTo: circleView.leadingAnchor, constant: -30).isActive = true
           container.heightAnchor.constraint(equalToConstant: 85).isActive = true
           container.centerYAnchor.constraint(equalTo: circleView.centerYAnchor).isActive = true

           let foodImage = getImage()
           let foodImageView = UIImageView(image: foodImage)

           container.addSubview(foodImageView)

           foodImageView.translatesAutoresizingMaskIntoConstraints = false
           foodImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10).isActive = true
           foodImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
           foodImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
           foodImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true

           let typeLabel = MainLabel(labelText: getTitle(), labelType: .percent, labelColor: .white)
           container.addSubview(typeLabel)
           typeLabel.translatesAutoresizingMaskIntoConstraints = false
           typeLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 13).isActive = true
           typeLabel.leftAnchor.constraint(equalTo: foodImageView.rightAnchor, constant: 10).isActive = true

            amountLabel = MainLabel(labelText: "\(Int(currentValue))/\(Int(maxValue)) grams", labelType: .subheading, labelColor: .lightGray)
           container.addSubview(amountLabel)
           amountLabel.translatesAutoresizingMaskIntoConstraints = false
           amountLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 1).isActive = true
           amountLabel.leftAnchor.constraint(equalTo: foodImageView.rightAnchor, constant: 10).isActive = true
       }

    func animateProgress(to new: Double) {

        print(new)

        UIView.animate(withDuration: 1, animations: {
            self.progressMeter.frame.size.width = self.getPosition(value: new)

            })

        var min = Int((self.currentValue/self.maxValue * 100).rounded())
        let max = Int((new/self.maxValue * 100).rounded())
        let total = max - min + 6

        Timer.scheduledTimer(withTimeInterval: 1.0/Double(total), repeats: true) { timer in
                min += 1
                self.percentLabel.text = "\(min)%"

                 if min >= max {
                     timer.invalidate()
                 }
            if min >= 100 {
                self.meterFull()
            }
             }

        self.currentValue = new

    }

    func getPosition(value: Double) -> Double {
        let newPercent = value/maxValue
        let newPosition = newPercent * Double(screenBounds.width - 60)

        return newPosition

    }

    func meterFull() {
        progressMeter.backgroundColor = colors.lightGreen
        checkImage.isHidden = false
    }

    func getImage() -> UIImage {
        switch FoodType {
        case .protein:
            return images.meat!
        case .carbs:
            return images.bread!
        case .fat:
            return images.avacado!
        }
    }

    func getTitle() -> String {
        switch FoodType {
        case .protein:
            return "Protein"
        case .carbs:
            return "Carbs"
        case .fat:
            return "Fat"
        }
    }

}

struct MacroView_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            // Return whatever controller you want to preview
            let vc  = MacroView(FoodType: .fat, maxValue: 100, currentValue: 25)
            vc.setupView()
            return vc
        }
    }
}
