//
//  CollectionViewCell.swift
//  EventExplorer
//
//  Created by Даниил Чугуевский on 09.04.2024.
//

import Foundation
import UIKit

class CollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var collectionView: UIView!
  @IBOutlet weak var labelCategories: UILabel!
  @IBOutlet weak var imageLabel: UILabel!
  @IBOutlet weak var imageView: UIView!
  @IBOutlet weak var collectionViewCell: UIView!
  @IBOutlet weak var leftImageViewCell: UIView!
  @IBOutlet weak var rightViewCell: UIView!
  
  func display(_ cellModel: Category, _ isSelected: Bool) {
    
    let cells = cellModel.name
    switch cells {
    case "All activities" :
      labelCategories.text = cellModel.name
      imageView.isHidden = true
    default:
      labelCategories.text = cellModel.name
      imageLabel.text = cellModel.image
      imageView.isHidden = false
    }
    
    collectionViewCell.layer.borderColor = UIColor(red: 0.233, green: 0.233, blue: 0.233, alpha: 0.2).cgColor
    collectionViewCell.layer.borderWidth = 1
    collectionView.layer.cornerRadius = 17
    
    if isSelected {
      leftImageViewCell.backgroundColor = UIColor.black
      rightViewCell.backgroundColor = UIColor.black
      labelCategories.textColor = UIColor.white
      labelCategories.font = UIFont(name: "RedHatDisplay-Bold", size: 12)
      collectionViewCell.layer.borderColor = UIColor.black.cgColor
      collectionViewCell.layer.borderWidth = 1
      collectionView.layer.cornerRadius = 17
      
    } else {
        
      leftImageViewCell.backgroundColor = UIColor.white
      rightViewCell.backgroundColor = UIColor.white
      labelCategories.textColor = UIColor.black
      labelCategories.font = UIFont(name: "RedHatDisplay-Medium", size: 12)
    }
  }
  
}