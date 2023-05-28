//
//  CalorieView.swift
//  Calorico
//
//  Created by Dane Jensen on 4/8/23.
//

import UIKit

class CalorieView: UIView {

    


    public private(set) var totalValue: Double
    public private(set) var currentValue: Double


    let circleView = UIView()
    let images = Images()
    let colors = Colors()

    let containerView = UIView()
    let screenBounds = UIScreen.main.bounds
    var percentLabel = UILabel()
    var checkImage = UIImageView()
    
    init(totalValue : Double, currentValue : Double) {
      
       self.totalValue = totalValue
       self.currentValue = currentValue
       
        super.init(frame: .zero)

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
           heightAnchor.constraint(equalToConstant: 200).isActive = true
           widthAnchor.constraint(equalToConstant: screenBounds.width - 60).isActive = true
           self.translatesAutoresizingMaskIntoConstraints = false
           
           addContainerView()
       }
        
    func addContainerView(){
        containerView.backgroundColor = colors.darkBlueBG
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
        
        addSubview(containerView)

        
        containerView.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),


        ])
        addComponents()
    }

    func addComponents() {
        let stack = UIStackView()
        
        containerView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            stack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            stack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            stack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),


        ])
        
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
     
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
        
        let calorieLabel = MainLabel(labelText: String(Int(currentValue)), labelType: .calorieHeading, labelColor: .white)
        NSLayoutConstraint.activate([
            calorieLabel.heightAnchor.constraint(equalToConstant: 55),

        ])
        calorieStack.addArrangedSubview(calorieLabel)
       
        let amountString = String(Int(totalValue - currentValue)) + " left"
        let amountLeft = MainLabel(labelText: amountString, labelType: .subheading, labelColor: .lightGray)
        calorieStack.addArrangedSubview(amountLeft)

        stack.addArrangedSubview(calorieStack)
        let progessView = UIView()
        progessView.backgroundColor = .white
        progessView.layer.cornerRadius = 15
        progessView.clipsToBounds = true
        
        stack.addArrangedSubview(progessView)

        
        progessView.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            progessView.heightAnchor.constraint(equalToConstant: 35),
            progessView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            progessView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),



        ])
        
    }
   
    

}
