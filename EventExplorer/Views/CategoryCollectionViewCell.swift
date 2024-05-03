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
  @IBOutlet weak var leadingView: UIView!
  @IBOutlet weak var trailingView: UIView!
  let color = UIColor(red: 28/255, green: 34/255, blue: 42/255, alpha: 1.0)
  
  func display(_ сategories: Category, _ isSelected: Bool) {
    labelCategories.text = сategories.name
    switch сategories {
    case Category.allActivities:
      iconeViewCell.isHidden = true
      leadingView.isHidden = false
      trailingView.isHidden = false
    default:
      iconLabel.text = сategories.icon
      iconeViewCell.isHidden = false
      leadingView.isHidden = true
      trailingView.isHidden = true
    }
    
    collectionViewCell.layer.borderColor = UIColor(red: 0.233, green: 0.233, blue: 0.233, alpha: 0.2).cgColor
    collectionViewCell.layer.borderWidth = 1
    collectionViewContent.layer.cornerRadius = 17
    
    if isSelected {
      iconeViewCell.backgroundColor = color
      categoryNameViewCell.backgroundColor = color
      labelCategories.textColor = UIColor.white
      labelCategories.font = UIFont(name: "RedHatDisplay-Bold", size: 12)
      leadingView.backgroundColor = color
      trailingView.backgroundColor = color
    } else {
      iconeViewCell.backgroundColor = UIColor.white
      categoryNameViewCell.backgroundColor = UIColor.white
      labelCategories.textColor = UIColor.black
      labelCategories.font = UIFont(name: "RedHatDisplay-Medium", size: 12)
      leadingView.backgroundColor = UIColor.white
      trailingView.backgroundColor = UIColor.white
    }
  }

}
