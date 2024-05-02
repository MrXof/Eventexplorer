//
//  CollectionViewCell.swift
//  EventExplorer
//
//  Created by Даниил Чугуевский on 09.04.2024.
//

import Foundation
import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet private weak var collectionViewContent: UIView!
  @IBOutlet private weak var labelCategories: UILabel!
  @IBOutlet private weak var iconLabel: UILabel!
  @IBOutlet private weak var iconLabelView: UIView!
  @IBOutlet private weak var collectionViewCell: UIView!
  @IBOutlet private weak var iconeViewCell: UIView!
  @IBOutlet private weak var categoryNameViewCell: UIView!
  // additional elements for layout
  @IBOutlet weak var lhs: UIView!
  @IBOutlet weak var rhs: UIView!
  
  func display(_ сategories: Category, _ isSelected: Bool) {
    labelCategories.text = сategories.name
    switch сategories {
    case Category.allActivities:
      iconeViewCell.isHidden = true
      lhs.isHidden = false
      rhs.isHidden = false
    default:
      iconLabel.text = сategories.icon
      iconeViewCell.isHidden = false
      lhs.isHidden = true
      rhs.isHidden = true
    }
    
    collectionViewCell.layer.borderColor = UIColor(red: 0.233, green: 0.233, blue: 0.233, alpha: 0.2).cgColor
    collectionViewCell.layer.borderWidth = 1
    collectionViewContent.layer.cornerRadius = 17
    
    if isSelected {
      iconeViewCell.backgroundColor = UIColor(red: 28/255, green: 34/255, blue: 42/255, alpha: 1.0)
      categoryNameViewCell.backgroundColor = UIColor(red: 28/255, green: 34/255, blue: 42/255, alpha: 1.0)
      labelCategories.textColor = UIColor.white
      labelCategories.font = UIFont(name: "RedHatDisplay-Bold", size: 12)
      lhs.backgroundColor = UIColor(red: 28/255, green: 34/255, blue: 42/255, alpha: 1.0)
      rhs.backgroundColor = UIColor(red: 28/255, green: 34/255, blue: 42/255, alpha: 1.0)
    } else {
      iconeViewCell.backgroundColor = UIColor.white
      categoryNameViewCell.backgroundColor = UIColor.white
      labelCategories.textColor = UIColor.black
      labelCategories.font = UIFont(name: "RedHatDisplay-Medium", size: 12)
      lhs.backgroundColor = UIColor.white
      rhs.backgroundColor = UIColor.white
    }
  }

}
