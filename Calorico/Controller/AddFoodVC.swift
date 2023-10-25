//
//  AddFoodVC.swift
//  Calorico
//
//  Created by Dane Jensen on 4/10/23.
//

import UIKit
import SwiftUI

//
// MARK: - AddFood View Controller
//

class AddFoodViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    //
    // MARK: - UI Initializers
    //
    private var closeButton = UIButton()
    let textField = UITextField()
    let sizeButton = UIButton()
    let servingButton = UIButton()
    var servingPicker = UIPickerView()
    var toolBar = UIToolbar()
    private let titleStack = UIStackView()
    let caloriesCounter = NutritionCounter(totalValue: 1000, currentValue: 0, type: .calorie)
    let proteinCounter = NutritionCounter(totalValue: 100, currentValue: 0, type: .protein)
    let carbsCounter = NutritionCounter(totalValue: 100, currentValue: 0, type: .carbs)
    let fatCounter = NutritionCounter(totalValue: 100, currentValue: 0, type: .fat)
    
    //
    // MARK: - Variables And Properties
    //
    let colors = Colors()
    let images = Images()
    var pickerOpen = false
    var existingFood: finalFoodItem?
    var selectedServing: FoodServing = FoodServing()
    let pickerArray = [["-", "1", "2", "3", "4", "5"], ["-", "1/8", "1/4", "1/3", "3/8", "1/2", "5/8", "2/3", "3/4", "7/8"]]

    //
    // MARK: - View Controller
    //

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

        NotificationCenter.default.addObserver(self, selector: #selector(self.nextTapped(_:)), name: Notification.Name("nextClicked"), object: nil)

    }
    
    //
    // MARK: - Setup Views
    //
    
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
            innerConatainer.bottomAnchor.constraint(equalTo: quantityContainer.bottomAnchor, constant: -10)

        ])

        innerConatainer.translatesAutoresizingMaskIntoConstraints = false
        addQuantityComponents(containerView: innerConatainer)

        setupNutrition(quantityView: innerConatainer)
    }
    func addQuantityComponents(containerView: UIView) {
        let qLabel = MainLabel(labelText: "Quantity", labelType: .subheadingSmall, labelColor: .lightGray)
        containerView.addSubview(qLabel)
        NSLayoutConstraint.activate([
            qLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            qLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10)

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

        sizeButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 24)
        sizeButton.titleLabel?.textColor = .white
        sizeButton.setTitle("1 item", for: .normal)
        sizeButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //
    // MARK: - Picker Setup
    //
    func addPicker() {
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
        servingPicker.selectRow(1, inComponent: 0, animated: true)
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
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("You selected \(row) \(component)")

        if component == 0 {
            selectedServing.value = pickerArray[component][row]

        } else if component == 1 {
            selectedServing.fraction = pickerArray[component][row]
        }
        setServingsString()
        servingChanged()
    }
    
    func setServingsString() {
        DispatchQueue.main.async {
            self.servingButton.setTitle(self.selectedServing.displayString, for: .normal)
        }
    }

    @objc func nextTapped(_ notification: NSNotification) {
        if let currentField = notification.object as? NutritionTypes {
            switch currentField {
            case .calorie:
                print("calorie")
                proteinCounter.textField.becomeFirstResponder()
            case .protein:
                print("Protein")
                carbsCounter.textField.becomeFirstResponder()
            case .carbs:
                print("Carbs")
                fatCounter.textField.becomeFirstResponder()
            case .fat:
                print("Fat")
                fatCounter.textField.resignFirstResponder()

            }
        }
    }

    func setFoodValues() {
    let food = existingFood!

        caloriesCounter.displayValue = Int(food.calories)
        NotificationCenter.default.post(name: Notification.Name("CaloriesChanged"), object: nil)

        fatCounter.displayValue = Int(food.fats)
        carbsCounter.displayValue = Int(food.carbs)
        proteinCounter.displayValue = Int(food.protein)

        sizeButton.setTitle("\(Int(food.servingAmount)) \(food.servingUnit)", for: .normal)
   //     caloriesCounter.currentValue = Int(food.calories)
    }

    

    func servingChanged() {
        caloriesCounter.serving = selectedServing.finalValue
        proteinCounter.serving = selectedServing.finalValue
        carbsCounter.serving = selectedServing.finalValue
    }

    
    @objc func closeView() {
        self.dismiss(animated: true)
    }
    
    @objc func addFood() {
        let foodName = textField.text ?? "Food"
        let calories = Int(caloriesCounter.displayValue)
        let protein = Int(proteinCounter.displayValue)
        let carbs = Int(carbsCounter.displayValue)
        let fat = Int(fatCounter.displayValue)
        let dateAdded = Date()

        let newFood = food(name: foodName, id: UUID(), macros: userMacros(fat: fat, protein: protein, carbs: carbs, calories: calories))

        currentUser?.dailyFood.append(newFood)
        currentUser?.updateProgess()

        foodHistory.insert(newFood, at: 0)

        if foodHistory.count == 20 {
            foodHistory.remove(at: foodHistory.count - 1)
        }
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode Note
            let data = try encoder.encode(foodHistory)

            // Write/Set Data
            UserDefaults.standard.set(data, forKey: "foodHistory")

        } catch {
            print("Unable to Encode Array of Notes (\(error))")
        }

        NotificationCenter.default.post(name: Notification.Name("FoodAdded"), object: nil)

        print(currentUser?.dailyFood ?? "No Daily Food")

        self.dismiss(animated: true)

    }

    func setupNutrition(quantityView: UIView) {
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
            innerConatainer.bottomAnchor.constraint(equalTo: quantityContainer.bottomAnchor, constant: -10)

        ])

        innerConatainer.translatesAutoresizingMaskIntoConstraints = false
        addFoodButton(nutritionView: quantityContainer)
        addNutritionComponents(containerView: innerConatainer)
    }

    func addNutritionComponents(containerView: UIView) {
        let nLabel = MainLabel(labelText: "Nutrition Values", labelType: .subheadingSmall, labelColor: .lightGray)
        containerView.addSubview(nLabel)
        NSLayoutConstraint.activate([
            nLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            nLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10)

        ])

        let vStack = UIStackView()
        containerView.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            vStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            vStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            vStack.topAnchor.constraint(equalTo: nLabel.bottomAnchor, constant: 20)

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

    func addFoodButton(nutritionView: UIView) {
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

    @objc func showPicker() {
        print(pickerOpen)
        print("SHOW PICKER")
        if !pickerOpen {
            pickerOpen = true
            print("TEST PICKER")

        UIView.animate(withDuration: 0.1, animations: {
              //  self.view.layoutIfNeeded() // add this
            self.servingPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
            self.toolBar.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50)

            })
        }

    }
// swiftlint:disable multiple_closures_with_trailing_closure
    @objc func onDoneButtonTapped() {
        if pickerOpen {
            UIView.animate(withDuration: 0.1, animations: {
                // self.view.layoutIfNeeded() // add this

                self.servingPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 300)
                self.toolBar.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 50)

            }) { (success) in
                print(success)

            }
            pickerOpen = false
        }
    }
    // swiftlint:enable multiple_closures_with_trailing_closure

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case textField:
            caloriesCounter.textField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()

        }
         return true
    }
}

extension UIViewController {

    @objc func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

struct AddFoodPreview: PreviewProvider {
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
