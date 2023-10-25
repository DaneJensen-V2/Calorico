//
//  ViewController.swift
//  Calorico
//
//  Created by Dane Jensen on 4/3/23.
//

import UIKit
import BarcodeScanner
import SwiftUI

//
// MARK: - HomeScreen View Controller
//

class HomeScreen: UIViewController, UINavigationControllerDelegate {

    //
    // MARK: - UI Initializers
    //
    var cameraButton = UIButton()
    var addButton = UIButton()
    var searchButton = UIButton()
    var createButton = UIButton()
    var macroStack = UIStackView()
    let protein = MacroView(FoodType: .protein, maxValue: 120, currentValue: 0)
    let carbs = MacroView(FoodType: .carbs, maxValue: 120, currentValue: 0)
    let fats = MacroView(FoodType: .fat, maxValue: 120, currentValue: 0)
    let calorie = CalorieView(totalValue: 2000, currentValue: 0)
    let titleLabel: MainLabel = MainLabel(labelText: "Today", labelType: .heading, labelColor: .white)
    
    //
    // MARK: - Variables And Properties
    //
    let networkManager = NetworkManager()
    var buttonsRevealed = false

    //
    // MARK: - View Controller
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        
        // Do any additional setup after loading the view.

        NotificationCenter.default.addObserver(self, selector: #selector(self.foodAdded(notification:)), name: Notification.Name("FoodAdded"), object: nil)

        view.backgroundColor = UIColor(named: "MainBG")

        if let data = UserDefaults.standard.data(forKey: "UserData") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                currentUser = try decoder.decode(User.self, from: data)

                if newDay {
                    currentUser?.dailyFood = []
                }

                print(currentUser ?? "No User")
                currentUser?.updateGoals()
                currentUser?.updateProgess()

                let macros = currentUser!.currentValues
                let goals = currentUser!.goals!

                calorie.updateValues(newMax: goals.calories, newValue: macros!.calories)

                protein.updateValues(newMax: Double(goals.protein), newValue: Double(macros!.protein))

                fats.updateValues(newMax: Double(goals.fat), newValue: Double(macros!.fat))

                carbs.updateValues(newMax: Double(goals.carbs), newValue: Double(macros!.carbs))
          //

            } catch {
                print("Unable to Decode UserData (\(error))")
            }
        } else {
            currentUser = User(height: Measurement(value: 70.0, unit: UnitLength.inches), weight: Measurement(value: 185.0, unit: UnitMass.pounds), age: 22, userExerciseLevel: .moderate, userGender: .male, userDietModel: .cutting, dailyFood: [])
            currentUser?.updateGoals()
            currentUser?.updateProgess()
            let macros = currentUser!.currentValues
            let goals = currentUser!.goals!

            calorie.updateValues(newMax: goals.calories, newValue: macros!.calories)

            protein.updateValues(newMax: Double(goals.protein), newValue: Double(macros!.protein))

            fats.updateValues(newMax: Double(goals.fat), newValue: Double(macros!.fat))

            carbs.updateValues(newMax: Double(goals.carbs), newValue: Double(macros!.carbs))
        }

        

        if (currentUser) != nil {
            currentUser?.updateGoals()
            print(currentUser?.goals ?? "No Goals")

        }
        setupViews()
    }
    
    //
    // MARK: - Setup Views
    //

    func setupViews() {
        DispatchQueue.main.async { [self] in
            setupTitle()
            setupButton()
            setupMacros()
        }
    }

    func setupTitle() {
        let dateButton = UIButton()
        dateButton.setTitle("Today", for: .normal)
        dateButton.titleLabel?.font = UIFont(name: "Poppins-ExtraBold", size: 34)

        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30),
            titleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30)

        ])
    }

    func setupMacros() {
        print("Adding Macro")

        macroStack.addArrangedSubview(calorie)
        macroStack.addArrangedSubview(protein)
        macroStack.addArrangedSubview(carbs)
        macroStack.addArrangedSubview(fats)

        macroStack.axis = .vertical
        macroStack.alignment = .center
        // macroStack.distribution = .equalSpacing
        macroStack.spacing = 20

        macroStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(macroStack)
        view.sendSubviewToBack(macroStack)

        NSLayoutConstraint.activate([
            macroStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            macroStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            macroStack.bottomAnchor.constraint(lessThanOrEqualTo: addButton.topAnchor, constant: 20),
            macroStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15)

        ])

    }

    func setupButton() {

        addButton = CircleButton(SymbolText: "plus", BGColor: .orange, SymbolSize: 24, buttonSize: 70)
        createButton = CircleButton(SymbolText: "square.and.pencil", BGColor: .orange, SymbolSize: 28, buttonSize: 70)
        searchButton = CircleButton(SymbolText: "magnifyingglass", BGColor: .orange, SymbolSize: 26, buttonSize: 70)
        cameraButton = CircleButton(SymbolText: "barcode.viewfinder", BGColor: .orange, SymbolSize: 30, buttonSize: 70)

        view.addSubview(createButton)
        view.addSubview(searchButton)
        view.addSubview(cameraButton)
        view.addSubview(addButton)

        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cameraButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)

        ])

        addButton.addTarget(self, action: #selector(toggleButtons), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(showScanner), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(addFood), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(showSearch), for: .touchUpInside)

    }
    
    //
    // MARK: - Button Selectors
    //
    @objc func showSearch() {
        let searchPage = SearchViewController()

       // searchPage.modalPresentationStyle = .fullScreen

            searchPage.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: searchPage, action: nil)

        let transition = CATransition()
           transition.duration = 0.4
           transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
           transition.type = CATransitionType.moveIn
           transition.subtype = CATransitionSubtype.fromTop
           self.navigationController?.view.layer.add(transition, forKey: nil)
           self.navigationController?.pushViewController(searchPage, animated: false)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.42) {
            self.toggleButtons()

        }
    }
    
    @objc func toggleButtons() {

            if buttonsRevealed {
                hideButtons()
            } else {
                showButtons()
            }

        buttonsRevealed.toggle()

    }
    
    func showButtons() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()

        UIView.animate(withDuration: 0.4, // 1
            delay: 0.0, // 2
                       usingSpringWithDamping: 0.9, // 3
            initialSpringVelocity: 5, // 4

                       options: [UIView.AnimationOptions.curveEaseInOut, UIView.AnimationOptions.allowUserInteraction],// 5
            animations: ({ // 6
            self.addButton.alpha = 0.5

            self.cameraButton.center.x += 80
            self.cameraButton.center.y -= 55

            self.searchButton.center.y -= 105

            self.createButton.center.x -= 80
            self.createButton.center.y -= 55
        }), completion: nil)

    }
    
    func hideButtons() {

        UIView.animate(withDuration: 0.4, // 1
            delay: 0.0, // 2
                       usingSpringWithDamping: 0.9, // 3
            initialSpringVelocity: 5, // 4
            options: UIView.AnimationOptions.curveEaseInOut, // 5
            animations: ({ // 6
            self.addButton.alpha = 1

            self.cameraButton.center.x -= 80
            self.cameraButton.center.y += 55

            self.searchButton.center.y += 105

            self.createButton.center.x += 80
            self.createButton.center.y += 55
        }), completion: nil)
    }

    @objc func showScanner() {
        let barcodeScanner = BarcodeScannerViewController()
        barcodeScanner.codeDelegate = self
        barcodeScanner.errorDelegate = self
        barcodeScanner.dismissalDelegate = self
        barcodeScanner.headerViewController.titleLabel.text = "Scan barcode"
        barcodeScanner.headerViewController.titleLabel.textColor = .black

        barcodeScanner.headerViewController.closeButton.tintColor = .black
        barcodeScanner.modalPresentationStyle = .fullScreen

        DispatchQueue.main.async {
            self.present(barcodeScanner, animated: true, completion: nil)

        }
    }
    @objc func addFood() {
        let addPage = AddFoodViewController()
        addPage.existingFood = nil

        addPage.modalPresentationStyle = .fullScreen

        DispatchQueue.main.async {
            self.present(addPage, animated: true, completion: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.42) {
            self.toggleButtons()

        }
    }
    
    @objc func foodAdded(notification: Notification) {

        calorie.amountLeft.text = String(Int(calorie.totalValue - currentUser!.currentValues!.calories)) + " left"
        protein.amountLabel.text = "\(Int(currentUser!.currentValues!.protein))/\(Int(protein.maxValue)) grams"
        carbs.amountLabel.text = "\(Int(currentUser!.currentValues!.carbs))/\(Int(carbs.maxValue)) grams"
        fats.amountLabel.text = "\(Int(currentUser!.currentValues!.fat))/\(Int(fats.maxValue)) grams"

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.42) {
            self.calorie.animateProgress(to: (currentUser?.currentValues!.calories)!)
            self.protein.animateProgress(to: Double(currentUser!.currentValues!.protein))
            self.carbs.animateProgress(to: Double(currentUser!.currentValues!.carbs))
            self.fats.animateProgress(to: Double(currentUser!.currentValues!.fat) )

        }
        currentUser!.saveToCoreData()
        print(currentUser!)

    }
}

//
// MARK: - Barcode Scanner
//
extension HomeScreen: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didReceiveError error: Error) {
        print("ERROR")
    }

    func scannerDidDismiss(_ controller: BarcodeScanner.BarcodeScannerViewController) {
        print("Scanner Dismissed")
        controller.dismiss(animated: true, completion: nil)
        toggleButtons()

    }

    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print(code)
        networkManager.getFoodFromBarcode(ID: code) { result in

            switch result {
               case .success(let food):
                food.printFood()

                DispatchQueue.main.async {
                    controller.reset(animated: true)
                    print(self)

                    self.dismiss(animated: true)
                    let addPage = AddFoodViewController()
                    addPage.existingFood = food

                    addPage.modalPresentationStyle = .overFullScreen

                        self.present(addPage, animated: true, completion: nil)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.42) {
                        self.toggleButtons()

                    }
                }
               case .failure(let error):
                   print(error.localizedDescription)
                DispatchQueue.main.async {
                    controller.resetWithError(message: "Did not find product.")

                }

               }
        }

    }

}
//
// MARK: - HomeScreen Preview
//
struct HomeViewController_Previews: PreviewProvider {
  static var previews: some View {
    Container().edgesIgnoringSafeArea(.all)
  }
  struct Container: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
      UINavigationController(rootViewController: HomeScreen())
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    typealias UIViewControllerType = UIViewController
  }
}
