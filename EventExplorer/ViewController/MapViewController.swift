//
//  ViewController.swift
//  Eventexplorer
//
//  Created by Даниил Чугуевский on 09.04.2024.
//

import UIKit

class MapViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

  @IBOutlet weak var locationButton: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var mapView: UIView!
  
  var currentFilter = ObjectStore.shared.arrayCategories[0]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    creaeteBlur()
    createShadowView()
    createCornerRadius()
    if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
        layout.scrollDirection = .horizontal
    }
    configureLocationButton()
    collectionView.dataSource = self
    collectionView.delegate = self
  }
  
  func createCornerRadius() {
    mapView.layer.cornerRadius = 21
    mapView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner ]
  }
  
  func createShadowView(
    color: UIColor = .black,
    alpha: Float = 0.3,
    x: CGFloat = 0,
    y: CGFloat = 20,
    blur: CGFloat = 25,
    spread: CGFloat = -12
  )
  {
    mapView.layer.shadowColor = color.cgColor
    mapView.layer.shadowOpacity = alpha
    mapView.layer.shadowOffset = CGSize(width: x, height: y)
    mapView.layer.shadowRadius = blur
    mapView.layer.shadowRadius += spread
  }
  
  func creaeteBlur() {
    let blurEffect = UIBlurEffect(style: .light)
    let blurView = UIVisualEffectView(effect: blurEffect)
    
    let containerBlur = UIView(frame: mapView.bounds)
    containerBlur.layer.cornerRadius = 21
    containerBlur.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner ]
    containerBlur.clipsToBounds = true
        
    containerBlur.addSubview(blurView)
    mapView.addSubview(containerBlur)
    mapView.sendSubviewToBack(containerBlur)
  }
  
  func configureLocationButton() {
    let nameButton = "Dnipro"
    let attributs : [NSAttributedString.Key: Any] = [
      .font: UIFont(name: "RedHatDisplay-Bold", size: 29)!,
      .foregroundColor: UIColor.black
    ]
    let attributedString = NSAttributedString(string: nameButton, attributes: attributs)
    locationButton.setAttributedTitle(attributedString, for: .normal)
    locationButton.configuration = locationButton.configuration ?? .plain()
    locationButton.configuration?.contentInsets.leading = 0
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return ObjectStore.shared.arrayCategories.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
    cell.display(ObjectStore.shared.arrayCategories[indexPath.row], currentFilter == ObjectStore.shared.arrayCategories[indexPath.row])
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    var indexToReload: [IndexPath] = []
    let filterIndex = ObjectStore.shared.arrayCategories.firstIndex(of: currentFilter)
    guard let guardIndex = filterIndex else { return }
    
    var resultIndex = IndexPath(item: guardIndex, section: 0)
    indexToReload.append(resultIndex)
    indexToReload.append(indexPath)
    currentFilter = ObjectStore.shared.arrayCategories[indexPath.row]
    collectionView.reloadItems(at: indexToReload)
  }
  
}

