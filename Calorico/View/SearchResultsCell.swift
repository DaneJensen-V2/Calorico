//
//  TableViewCell.swift
//  Calorico
//
//  Created by Dane Jensen on 9/30/23.
//

import UIKit

//
// MARK: - SearchResults Table Cell
//

class SearchResultsCell: UITableViewCell {

    //
    // MARK: - Outlets
    //
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    //
    // MARK: - Variables And Properties
    //
    var food: finalFoodItem?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addButton.layer.cornerRadius = addButton.frame.width / 2
        backgroundColor = .clear
        setupBG()
        updateView()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))

    }
    override func layoutSubviews() {
         super.layoutSubviews()
         let bottomSpace: CGFloat = 10.0 // Let's assume the space you want is 10
         self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: bottomSpace, left: bottomSpace, bottom: bottomSpace, right: bottomSpace))
    }
    
    func updateView() {
        if let finalFood = food {
            foodName.text = finalFood.name
            servingLabel.text = finalFood.servingDescription
            calorieLabel.text = String(Int(finalFood.calories)) + " cal"
            proteinLabel.text = String(Int(finalFood.protein)) + " g"
            fatLabel.text = String(Int(finalFood.fats)) + " g"
            carbsLabel.text = String(Int(finalFood.carbs)) + " g"
            brandLabel.text = food?.brandName ?? "Generic"
            if food?.brandName == "" {
                brandLabel.text = "Generic"
            }

        }
    }
    
    func setupBG() {
        // add shadow on cell
        backgroundColor = .clear // very important
        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor

        // add corner radius on `contentView`
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
    }

    @IBAction func addButtonClicked(_ sender: UIButton) {
        print("Add Food \(food!.name)")
    }
}
