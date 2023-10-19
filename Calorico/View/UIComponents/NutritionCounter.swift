//
//  NutritionCounter.swift
//  Calorico
//
//  Created by Dane Jensen on 6/12/23.
//

import UIKit

var newCalorieValue = 0

class NutritionCounter: UIView {
    
   
   
    enum nutritionType {
        case calorie
        case protein
        case carbs
        case fat
    }

    let circleView = UIView()
    let images = Images()
    let colors = Colors()
    let step:Float = 1 // If you want UISlider to snap to steps by 10
    let textField = UITextField()

    private var sliderColor : UIColor = .black
    private var sliderTitle : String = "Default"
    private var sliderImage : UIImage = UIImage()
    var type : nutritionType = .calorie
    
    let mySlider = CustomSlider()
    let containerView = UIView()
    let screenBounds = UIScreen.main.bounds
    var percentLabel = UILabel()
    var checkImage = UIImageView()
    
    public private(set) var totalValue: Int = 100
       
    public var currentValue: Int = 0{
     
        didSet{
            print("Setting \(self.type) value to \(currentValue)")
            if (self.type == .calorie){
                newCalorieValue = currentValue
            }
            updateUI()
           // self.currentValue = newValue
        }
    }
    
    
    init(totalValue : Int, currentValue : Int, type : nutritionType) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: 280, height: 45))


       self.totalValue = totalValue
       self.currentValue = currentValue
       self.type = type


        
        NotificationCenter.default.addObserver(self, selector: #selector(self.caloriesChanged(notification:)), name: Notification.Name("CaloriesChanged"), object: nil)

       customizeSlider(counterType: type)
       setupView()
       
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        // Can do the setup of the view, including adding subviews


        heightAnchor.constraint(equalToConstant: 45).isActive = true
        //widthAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        drawIcon()
       
    }
    
    func updateUI(){
        if self.type == .calorie {
            self.textField.text = String(currentValue)
            self.mySlider.setValue(Float(currentValue), animated: false)

        }
        else {
            self.textField.text = String(currentValue) + "g"
            self.mySlider.setValue(Float(currentValue), animated: true)


        }
    }

    
    func drawIcon() {
        let outerView = UIView()
        let nutritionIcon = UIImageView()
        
      
        self.addSubview(outerView)
        outerView.addSubview(nutritionIcon)
        
        outerView.backgroundColor = .white
        outerView.layer.cornerRadius = 10
        outerView.layer.borderWidth = 1
        outerView.layer.borderColor = UIColor.lightGray.cgColor
        nutritionIcon.image = sliderImage
        nutritionIcon.contentMode = .scaleAspectFit
        
        outerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            outerView.topAnchor.constraint(equalTo: self.topAnchor),
            outerView.heightAnchor.constraint(equalToConstant: 40),
            outerView.widthAnchor.constraint(equalToConstant: 40),
            outerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5)
            
            
        ])
        nutritionIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nutritionIcon.leadingAnchor.constraint(equalTo: outerView.leadingAnchor, constant: 3),
            nutritionIcon.trailingAnchor.constraint(equalTo: outerView.trailingAnchor, constant: -3),
            nutritionIcon.topAnchor.constraint(equalTo: outerView.topAnchor , constant: 3),
            nutritionIcon.bottomAnchor.constraint(equalTo: outerView.bottomAnchor, constant: -3)
            
            
        ])
        addProgressBar(icon: outerView)
        
    }
    
    func addProgressBar(icon: UIView){
        addSubview(mySlider)

        mySlider.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mySlider.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            mySlider.heightAnchor.constraint(equalToConstant: 30),
            mySlider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            mySlider.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10)
            
            
        ])
        mySlider.setThumbImage(UIImage(), for: .normal)

        mySlider.minimumValue = 0
                mySlider.maximumValue = 100
                mySlider.isContinuous = true
                mySlider.tintColor = sliderColor
                mySlider.addTarget(self, action: #selector(self.sliderValueDidChange(_:)), for: .valueChanged)
        
        
        let titleLabel = MainLabel(labelText: sliderTitle, labelType: .nutritionLabel, labelColor: .white)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: mySlider.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
            
        ])
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        if type == .calorie {
            textField.attributedPlaceholder = NSAttributedString(
                string: "0",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
            )
        }
        else {
            textField.attributedPlaceholder = NSAttributedString(
                string: "0g",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
            )
        }
       
        textField.keyboardType = UIKeyboardType.numberPad
        textField.textAlignment = .right
        textField.returnKeyType = UIReturnKeyType.next
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.font = UIFont(name: "Poppins-Regular", size: 22)
        textField.borderStyle = UITextField.BorderStyle.none
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.textColor = .white
        textField.backgroundColor = colors.lightGray!.withAlphaComponent(0.2)
        textField.layer.cornerRadius = 10
        textField.setLeftPaddingPoints(2)
        textField.setRightPaddingPoints(2)

        
        let bar = UIToolbar(frame:CGRect(x:0, y:0, width:100, height:100))
        let next = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.items = [flexibleSpace, next]
        bar.sizeToFit()
  
        textField.inputAccessoryView = bar
        
        textField.addTarget(self, action: #selector(textFieldDidEnd(_:)), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.addTarget(self, action: #selector(textFieldDidBegin(_:)), for: .editingDidBegin)

        addSubview(textField)
        NSLayoutConstraint.activate([
            textField.bottomAnchor.constraint(equalTo: mySlider.topAnchor, constant: 2),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -17),
            textField.widthAnchor.constraint(equalToConstant: 65),
            textField.heightAnchor.constraint(equalToConstant: 30)
        ])
        
    }
    @objc func textFieldDidBegin(_ textField: UITextField) {
        textField.text = ""
    }
    
    @objc func nextClicked() {
        print("Next")
        
        
    }
    
    @objc func textFieldDidEnd(_ textField: UITextField) {
        if type == .calorie {
            currentValue = Int(textField.text ?? "0") ?? 0
            NotificationCenter.default.post(name: Notification.Name("CaloriesChanged"), object: nil)

        }
        else {
            currentValue = Int(textField.text ?? "0") ?? 0
            
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if type != .calorie {
                
        }
        
        else {
            
        }
    }
    
    func customizeSlider(counterType : nutritionType){
       switch counterType {
           
       case .calorie:
           sliderColor = colors.CalorieOrange!
           sliderImage = images.calorie!
           sliderTitle = "Calories"
           break
           
       case .protein:
           sliderColor = colors.ProteinRed!
           sliderImage = images.meat!
           sliderTitle = "Protein"
           break
           
       case .carbs:
           sliderColor = colors.CarbsBrown!
           sliderImage = images.bread!
           sliderTitle = "Carbs"
           break
           
       case .fat:
           sliderColor = colors.FatGreen!
           sliderImage = images.avacado!
           sliderTitle = "Fat"
           break
        
       }
       
    }
    @objc func sliderValueDidChange(_ sender:UISlider!)
       {
           // Use this code below only if you want UISlider to snap to values step by step
           let roundedStepValue = round(sender.value / step) * step
           sender.value = roundedStepValue
           
           if type == .calorie {
               textField.text = String(Int(roundedStepValue))

           }
           else {
               textField.text = String(Int(roundedStepValue)) + "g"

           }
            
           
       }
    
    func addLabels(){
        
    }
    
    
    @objc func caloriesChanged(notification: Notification) {
        //print("CaloresChanged")
        var newValue = 0.0
        
        switch type {
            
        case .calorie:
            mySlider.maximumValue = Float(2 * newCalorieValue)
            mySlider.value = Float(newCalorieValue)
            break
            
        case .protein:
            newValue =  Double(newCalorieValue) / 4.0
            UIView.animate(withDuration: 0.2) {
                self.mySlider.maximumValue = Float(newValue)
                self.mySlider.layoutIfNeeded()
            }
            break
            
        case .carbs:
            newValue =  Double(newCalorieValue) / 4.0
            UIView.animate(withDuration: 0.2) {
                self.mySlider.maximumValue = Float(newValue)
                self.mySlider.layoutIfNeeded()
            }
            break
            
        case .fat:
            newValue = Double(newCalorieValue) / 9.0
            UIView.animate(withDuration: 0.2) {
                self.mySlider.maximumValue = Float(newValue)
                self.mySlider.layoutIfNeeded()
            }
            break
         
        }
        
    }

}

open class CustomSlider : UISlider {
    @IBInspectable open var trackWidth:CGFloat = 17 {
        didSet {setNeedsDisplay()}
    }

    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        let defaultBounds = super.trackRect(forBounds: bounds)
        return CGRect(
            x: defaultBounds.origin.x,
            y: defaultBounds.origin.y + defaultBounds.size.height/2 - trackWidth/2,
            width: defaultBounds.size.width,
            height: trackWidth
        )
    }
}
