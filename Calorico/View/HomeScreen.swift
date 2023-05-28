//
//  ViewController.swift
//  Calorico
//
//  Created by Dane Jensen on 4/3/23.
//

import UIKit
import BarcodeScanner

class HomeScreen: UIViewController, UINavigationControllerDelegate{

    var cameraButton = UIButton()
    var addButton = UIButton()
    var searchButton = UIButton()
    var createButton = UIButton()
    var buttonsRevealed = false

    
    var macroStack = UIStackView()
    
    let networkManager = NetworkManager()
    let protein = MacroView(FoodType: .protein, maxValue: 120, currentValue: 60)
    let carbs = MacroView(FoodType: .carbs, maxValue: 120, currentValue:30)
    let fats = MacroView(FoodType: .fat, maxValue: 120, currentValue: 120)
    let calorie = CalorieView(totalValue: 2000, currentValue: 1200)
    let titleLabel : MainLabel = MainLabel(labelText: "Today", labelType: .heading, labelColor: .white)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.delegate = self
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(named: "MainBG")
        DispatchQueue.main.async { [self] in
            setupTitle()
            setupButton()
            setupMacros()
        }
    
        currentUser = User(height: Measurement(value:70, unit: UnitLength.inches), weight: Measurement(value:190, unit: UnitMass.pounds), age: 22, userExerciseLevel: .moderate, userGender: .male, userDietModel: .maintaining, dailyFood: [])
        currentUser?.updateGoals()
        print(currentUser?.goals)

    }
    
    func setCurrentValues() {
    }
    
    func setupTitle(){
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30),
            titleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30)
            
        ])
    }
    
    func setupMacros(){

        macroStack.addArrangedSubview(calorie)
        macroStack.addArrangedSubview(protein)
        macroStack.addArrangedSubview(carbs)
        macroStack.addArrangedSubview(fats)

        macroStack.axis = .vertical
        macroStack.alignment = .center
        //macroStack.distribution = .equalSpacing
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
    
    func setupButton(){
        
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
            cameraButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            
        ])
        
        addButton.addTarget(self, action: #selector(toggleButtons), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(showScanner), for: .touchUpInside)

    }

    @objc func toggleButtons(){
            
            if buttonsRevealed {
                hideButtons()
            }
            else {
                showButtons()
            }
            
        
        buttonsRevealed.toggle()

    }
    
    func showButtons(){
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        UIView.animate(withDuration: 0.5, //1
            delay: 0.0, //2
                       usingSpringWithDamping: 0.9, //3
            initialSpringVelocity: 5, //4
            options: UIView.AnimationOptions.curveEaseInOut, //5
            animations: ({ //6
            self.addButton.alpha = 0.5

            self.cameraButton.center.x = self.cameraButton.center.x + 80
            self.cameraButton.center.y = self.cameraButton.center.y - 55

            self.searchButton.center.y = self.searchButton.center.y - 105
            
            self.createButton.center.x = self.createButton.center.x - 80
            self.createButton.center.y = self.createButton.center.y - 55
        }), completion: nil)
        
    }
    func hideButtons() {

        UIView.animate(withDuration: 0.5, //1
            delay: 0.0, //2
                       usingSpringWithDamping: 0.9, //3
            initialSpringVelocity: 5, //4
            options: UIView.AnimationOptions.curveEaseInOut, //5
            animations: ({ //6
            self.addButton.alpha = 1

            self.cameraButton.center.x = self.cameraButton.center.x - 80
            self.cameraButton.center.y = self.cameraButton.center.y + 55

            self.searchButton.center.y = self.searchButton.center.y + 105
            
            self.createButton.center.x = self.createButton.center.x + 80
            self.createButton.center.y = self.createButton.center.y + 55
        }), completion: nil)
    }
    
    @objc func showScanner() {
        let barcodeScanner = BarcodeScannerViewController()
        barcodeScanner.codeDelegate = self
        barcodeScanner.errorDelegate = self
        barcodeScanner.dismissalDelegate = self
        barcodeScanner.headerViewController.titleLabel.text = "Scan barcode"
        barcodeScanner.headerViewController.titleLabel.textColor = .white

        barcodeScanner.headerViewController.closeButton.tintColor = .white
        barcodeScanner.modalPresentationStyle = .fullScreen
        
        DispatchQueue.main.async {
            self.present(barcodeScanner, animated: true, completion: nil)

        }
    }
    
}

extension HomeScreen : BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didReceiveError error: Error) {
        print("ERROR")
    }
    
    func scannerDidDismiss(_ controller: BarcodeScanner.BarcodeScannerViewController) {
        print("Scanner Dismissed")
        controller.dismiss(animated: true, completion: nil)
        toggleButtons()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.42) {
            self.protein.animateProgress(to: 100)
            self.carbs.animateProgress(to: 100)
            
        }
    }
    
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print(code)
        networkManager.getFoodInfo(from: code, completion: { result in
            switch result {
               case .success(let food):
                food.printFood()

                DispatchQueue.main.async {
                    controller.reset(animated: true)
                    let newVC = AddFood()
                    self.present(newVC, animated: true)
                }
               case .failure(let error):
                   print(error.localizedDescription)
                DispatchQueue.main.async {
                    controller.resetWithError(message: "Did not find product.")

                }

               }
        })
        
    }
    
    
}
