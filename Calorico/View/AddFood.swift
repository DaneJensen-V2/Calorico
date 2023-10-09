//
//  AddFoodVC.swift
//  Calorico
//
//  Created by Dane Jensen on 4/10/23.
//

import UIKit
import SwiftUI

class AddFoodViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    private var closeButton = UIButton()
    
    let textField = UITextField()
    
    let caloriesCounter = NutritionCounter(totalValue: 1000, currentValue: 0, type: .calorie)
    let proteinCounter = NutritionCounter(totalValue: 100, currentValue: 0, type: .protein)
    let carbsCounter = NutritionCounter(totalValue: 100, currentValue: 0, type: .carbs)
    let fatCounter = NutritionCounter(totalValue: 100, currentValue: 0, type: .fat)
    
    let colors = Colors()
    let sizeButton = UIButton()

    let images = Images()
    private var servingPicker = UIPickerView()
    private var toolBar = UIToolbar()
    var pickerOpen = false
    
    let pickerArray = [["-", "1", "2", "3", "4", "5"], ["-", "1/8", "1/4", "1/3", "3/8", "1/2", "5/8", "2/3", "3/4", "7/8"]]
    let unicodeDict = ["1/8": "215B", "1/4" : "00BC", "1/3" : "2153", "3/8" : "215C", "1/2" : "00BD", "5/8" : "215D", "2/3" : "2154", "3/4" : "00BE", "7/8" : "215E"]
    let valueDict : [String : Double] = ["1/8": 1/8, "1/4" : 1/4, "1/3" : 1/3, "3/8" : 3/8, "1/2" : 1/2, "5/8" : 5/8, "2/3" : 2/3, "3/4" : 3/4, "7/8" : 7/8]
    
    var existingFood : finalFoodItem?
    
    
    private let titleStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = colors.darkBlueBG
        
        setupTitle()
        addPicker()
        
        if existingFood != nil {
            setFoodValues()
        }
        
        self.hideKeyboardWhenTappedAround()
        
    }
    
    func addPicker() {
        
        
    }
    
    func setFoodValues(){
    let food = existingFood!
     
        caloriesCounter.currentValue = Int(food.calories)
        NotificationCenter.default.post(name: Notification.Name("CaloriesChanged"), object: nil)

        fatCounter.currentValue = Int(food.fats)
        carbsCounter.currentValue = Int(food.carbs)
        proteinCounter.currentValue = Int(food.protein)

       
        sizeButton.setTitle("\(Int(food.servingAmount)) \(food.servingUnit)", for: .normal)
   //     caloriesCounter.currentValue = Int(food.calories)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray[component].count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let row = pickerArray[component][row]
        return row
    }
    
    func setupTitle() {
        
        view.addSubview(titleStack)
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleStack.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            titleStack.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            titleStack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleStack.heightAnchor.constraint(equalToConstant: 100)
            
        ])
        
        titleStack.axis = .horizontal
        titleStack.alignment = .center
        titleStack.distribution = .equalSpacing
        
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Food name...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        textField.returnKeyType = UIReturnKeyType.next
        textField.text = existingFood?.name ?? ""
        textField.delegate = self
        textField.adjustsFontSizeToFitWidth = true
 
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.font = UIFont(name: "Poppins-ExtraBold", size: 34)
        textField.borderStyle = UITextField.BorderStyle.none
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.textColor = .white
        if existingFood == nil {
            textField.becomeFirstResponder()

        }
        closeButton = CircleButton(SymbolText: "xmark", BGColor: .orange, SymbolSize: 18, buttonSize: 40)
        titleStack.addArrangedSubview(textField)
        titleStack.addArrangedSubview(closeButton)
        
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        
        setupQuantity()
    }
    
    @objc func closeView(){
        self.dismiss(animated: true)
    }
    @objc func addFood(){
        let foodName = textField.text ?? "Food"
        let calories = Int(caloriesCounter.currentValue)
        let protein = Int(proteinCounter.currentValue)
        let carbs = Int(carbsCounter.currentValue)
        let fat = Int(fatCounter.currentValue)
        let dateAdded = Date()
        
        let newFood = food(name: foodName, id: UUID(), macros: userMacros(fat: fat, protein: protein, carbs: carbs, calories: calories))
        
        currentUser?.dailyFood.append(newFood)
        currentUser?.updateProgess()
        
        NotificationCenter.default.post(name: Notification.Name("FoodAdded"), object: nil)
        
        print(currentUser?.dailyFood)
        
        self.dismiss(animated: true)
        
    }
    func setupQuantity() {
        let quantityContainer = UIView()
        self.view.addSubview(quantityContainer)
        
        quantityContainer.backgroundColor = .white
        quantityContainer.layer.cornerRadius = 20
        quantityContainer.clipsToBounds = true
        NSLayoutConstraint.activate([
            quantityContainer.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            quantityContainer.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            quantityContainer.topAnchor.constraint(equalTo: titleStack.bottomAnchor, constant: 10),
            quantityContainer.heightAnchor.constraint(equalToConstant: 200)
            
        ])
        
        quantityContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let innerConatainer = UIView()
        quantityContainer.addSubview(innerConatainer)
        innerConatainer.backgroundColor = colors.darkBlueBG
        innerConatainer.layer.cornerRadius = 20
        innerConatainer.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            innerConatainer.leadingAnchor.constraint(equalTo: quantityContainer.leadingAnchor, constant: 10),
            innerConatainer.trailingAnchor.constraint(equalTo: quantityContainer.trailingAnchor, constant: -10),
            innerConatainer.topAnchor.constraint(equalTo: quantityContainer.topAnchor, constant: 10),
            innerConatainer.bottomAnchor.constraint(equalTo: quantityContainer.bottomAnchor, constant: -10),
            
            
        ])
        
        innerConatainer.translatesAutoresizingMaskIntoConstraints = false
        addQuantityComponents(containerView: innerConatainer)
        
        setupNutrition(quantityView: innerConatainer)
    }
    func addQuantityComponents(containerView : UIView) {
        let qLabel = MainLabel(labelText: "Quantity", labelType: .subheadingSmall, labelColor: .lightGray)
        containerView.addSubview(qLabel)
        NSLayoutConstraint.activate([
            qLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            qLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            
        ])
        
        let vStack = UIStackView()
        containerView.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            vStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            vStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 5),
            vStack.topAnchor.constraint(equalTo: qLabel.bottomAnchor, constant: -10)
            
        ])
        
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.distribution = .fillEqually
        vStack.spacing = -20
        
        let servingStack = UIStackView()
        vStack.addArrangedSubview(servingStack)
        
        let serveLabel = MainLabel(labelText: "Servings", labelType: .subheadingLarge, labelColor: .white)
        
        servingStack.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -30).isActive = true
        servingStack.translatesAutoresizingMaskIntoConstraints = false
        servingStack.axis = .horizontal
        servingStack.alignment = .center
        servingStack.distribution = .fill
        
        servingStack.addArrangedSubview(serveLabel)
        
        
        
        let servingButton = UIButton()
        servingStack.addArrangedSubview(servingButton)
        
        servingButton.backgroundColor = colors.mainOrange
        servingButton.layer.cornerRadius = 20
        
        NSLayoutConstraint.activate([
            servingButton.heightAnchor.constraint(equalToConstant: 50),
            servingButton.widthAnchor.constraint(equalToConstant: 90)
        ])
        
        servingButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 28)
        servingButton.titleLabel?.textColor = .white
        servingButton.setTitle("1", for: .normal)
        servingButton.translatesAutoresizingMaskIntoConstraints = false
        servingButton.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
        
        let sizeStack = UIStackView()
        vStack.addArrangedSubview(sizeStack)
        
        let sizeLabel = MainLabel(labelText: "Serving Size", labelType: .subheadingLarge, labelColor: .white)
        
        sizeStack.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -30).isActive = true
        sizeStack.translatesAutoresizingMaskIntoConstraints = false
        sizeStack.axis = .horizontal
        sizeStack.alignment = .center
        sizeStack.distribution = .fill
        
        sizeStack.addArrangedSubview(sizeLabel)
        
        
        
        sizeStack.addArrangedSubview(sizeButton)
        
        sizeButton.backgroundColor = colors.mainOrange
        sizeButton.layer.cornerRadius = 20
        
        NSLayoutConstraint.activate([
            sizeButton.heightAnchor.constraint(equalToConstant: 50),
            sizeButton.widthAnchor.constraint(equalToConstant: 90)
        ])
        
        sizeButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 28)
        sizeButton.titleLabel?.textColor = .white
        sizeButton.setTitle("-", for: .normal)
        sizeButton.translatesAutoresizingMaskIntoConstraints = false
   //     sizeButton.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
    }
    func setButtonText() {
        
    }
    
    func setupNutrition(quantityView : UIView) {
        let quantityContainer = UIView()
        self.view.addSubview(quantityContainer)
        
        quantityContainer.backgroundColor = .white
        quantityContainer.layer.cornerRadius = 20
        quantityContainer.clipsToBounds = true
        NSLayoutConstraint.activate([
            quantityContainer.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            quantityContainer.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            quantityContainer.topAnchor.constraint(equalTo: quantityView.bottomAnchor, constant: 40),
            quantityContainer.heightAnchor.constraint(equalToConstant: 325)
            
        ])
        
        quantityContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let innerConatainer = UIView()
        quantityContainer.addSubview(innerConatainer)
        innerConatainer.backgroundColor = colors.darkBlueBG
        innerConatainer.layer.cornerRadius = 20
        innerConatainer.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            innerConatainer.leadingAnchor.constraint(equalTo: quantityContainer.leadingAnchor, constant: 10),
            innerConatainer.trailingAnchor.constraint(equalTo: quantityContainer.trailingAnchor, constant: -10),
            innerConatainer.topAnchor.constraint(equalTo: quantityContainer.topAnchor, constant: 10),
            innerConatainer.bottomAnchor.constraint(equalTo: quantityContainer.bottomAnchor, constant: -10),
            
            
        ])
        
        innerConatainer.translatesAutoresizingMaskIntoConstraints = false
        addFoodButton(nutritionView: quantityContainer)
        addNutritionComponents(containerView: innerConatainer)
    }
        
    func addNutritionComponents(containerView : UIView) {
        let nLabel = MainLabel(labelText: "Nutrition Values", labelType: .subheadingSmall, labelColor: .lightGray)
        containerView.addSubview(nLabel)
        NSLayoutConstraint.activate([
            nLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            nLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            
        ])
        
        let vStack = UIStackView()
        containerView.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            vStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            vStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            vStack.topAnchor.constraint(equalTo: nLabel.bottomAnchor, constant: 10)
            
        ])
        
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.distribution = .equalSpacing
        
       
        
        vStack.addArrangedSubview(caloriesCounter)
        vStack.addArrangedSubview(proteinCounter)
        vStack.addArrangedSubview(carbsCounter)
        vStack.addArrangedSubview(fatCounter)
        
    }
    
    func addFoodButton(nutritionView : UIView) {
        let addButton = UIButton()
        self.view.addSubview(addButton)
        
        addButton.backgroundColor = colors.mainOrange
        addButton.layer.cornerRadius = 20
        
        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.widthAnchor.constraint(equalToConstant: 180),
            addButton.topAnchor.constraint(equalTo: nutritionView.bottomAnchor, constant: 20),
            addButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            
        ])
        
        addButton.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 25)
        addButton.titleLabel?.textColor = .white
        addButton.setTitle("Add Food", for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addFood), for: .touchUpInside)
    }
    
    
    @objc func showPicker(){
        
        if !pickerOpen {
        servingPicker = UIPickerView.init()
        servingPicker.delegate = self
        servingPicker.dataSource = self
        servingPicker.backgroundColor = colors.darkBlueBG
        servingPicker.setValue(UIColor.white, forKey: "textColor")
        servingPicker.autoresizingMask = .flexibleWidth
        servingPicker.contentMode = .center
        servingPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 300)
            self.view.addSubview(servingPicker)
        
     
            toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
    
            toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
            self.view.addSubview(toolBar)
        UIView.animate(withDuration: 0.1, animations: {
                self.view.layoutIfNeeded() // add this
            self.servingPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
            self.toolBar.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50)


            })
            pickerOpen = true
        }
    }
    
    @objc func onDoneButtonTapped() {
        if pickerOpen {
            UIView.animate(withDuration: 0.1, animations: {
                self.view.layoutIfNeeded() // add this
                
                
                self.servingPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 300)
                self.toolBar.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 50)
                
            }){ (success) in
                self.toolBar.removeFromSuperview()
                self.servingPicker.removeFromSuperview()
            }
            pickerOpen = false
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case textField:
            caloriesCounter.textField.becomeFirstResponder()
            break
        
        default:
            textField.resignFirstResponder()

        }
         return true
    }
}

    


extension UIViewController {

    @objc func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


struct AddFood_Preview: PreviewProvider {
  static var previews: some View {
    Container().edgesIgnoringSafeArea(.all)
  }
  struct Container: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
      UINavigationController(rootViewController: AddFoodViewController())
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    typealias UIViewControllerType = UIViewController
  }
}



