//
//  CalorieView.swift
//  Calorico
//
//  Created by Dane Jensen on 4/8/23.
//

import UIKit
import SwiftUI

class CalorieView: UIView {

    public private(set) var totalValue: Int
    public private(set) var currentValue: Int

    let circleView = UIView()
    let images = Images()
    let colors = Colors()

    let containerView = UIView()
    let screenBounds = UIScreen.main.bounds
    var percentLabel = UILabel()
    var checkImage = UIImageView()
    var calorieLabel = UILabel()
    var amountLeft = UILabel()

    init(totalValue: Int, currentValue: Int) {

       self.totalValue = totalValue
       self.currentValue = currentValue

        super.init(frame: .zero)

   }

       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

       func setupView() {
           // Can do the setup of the view, including adding subviews

           backgroundColor = .white
           self.layer.cornerRadius = 20
           self.clipsToBounds = true
           heightAnchor.constraint(equalToConstant: 200).isActive = true
           widthAnchor.constraint(equalToConstant: screenBounds.width - 60).isActive = true
           self.translatesAutoresizingMaskIntoConstraints = false

           addContainerView()
       }

    func addContainerView() {
        containerView.backgroundColor = colors.darkBlueBG
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true

        addSubview(containerView)

        containerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)

        ])
        addComponents()
    }

    func animateProgress(to new: Int) {

        print(new)

        let increment = new - currentValue

       var newCalorie = currentValue

        Timer.scheduledTimer(withTimeInterval: 0.8/Double(increment), repeats: true) { timer in
                newCalorie += 1

            self.calorieLabel.text = String(Int(newCalorie))

                 if newCalorie >= new {
                     timer.invalidate()
                 }
             }

        self.currentValue = new
    }

    func updateValues(newMax: Int, newValue: Int) {

        self.totalValue = newMax

        self.currentValue = newValue

        setupView()

    }
    func addComponents() {
        let stack = UIStackView()

        containerView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            stack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            stack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            stack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15)

        ])

        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillProportionally

        let titleStack = UIStackView()
        titleStack.axis = .horizontal
        titleStack.alignment = .center
        titleStack.distribution = .equalSpacing

        let calorieImage = images.calorie
        let calorieImageView = UIImageView(image: calorieImage)

        titleStack.addArrangedSubview(calorieImageView)

        calorieImageView.translatesAutoresizingMaskIntoConstraints = false
        calorieImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        calorieImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true

        let typeLabel = MainLabel(labelText: "Calories", labelType: .percent, labelColor: .white)
        titleStack.addArrangedSubview(typeLabel)

        stack.addArrangedSubview(titleStack)

        let calorieStack = UIStackView()
        calorieStack.axis = .vertical
        calorieStack.alignment = .center
        calorieStack.spacing = -5

         calorieLabel = MainLabel(labelText: String(Int(currentValue)), labelType: .calorieLabel, labelColor: .white)
        NSLayoutConstraint.activate([
            calorieLabel.heightAnchor.constraint(equalToConstant: 55)

        ])
        calorieStack.addArrangedSubview(calorieLabel)

        let amountString = String(Int(totalValue - currentValue)) + " left"
        amountLeft = MainLabel(labelText: amountString, labelType: .caloriesLeft, labelColor: .lightGray)
        calorieStack.addArrangedSubview(amountLeft)

        stack.addArrangedSubview(calorieStack)

    }

}
struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View

    init(_ builder: @escaping () -> View) {
        view = builder()
    }

    // MARK: UIViewRepresentable
    func makeUIView(context: Context) -> UIView {
        return view
    }

    func updateUIView(_ view: UIView, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
struct BestInClassPreviews_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            // Return whatever controller you want to preview
            let vc = CalorieView(totalValue: 2000, currentValue: 0)
            vc.setupView()
            return vc
        }
    }
}
