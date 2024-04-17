//
//  ViewController.swift
//  Eventexplorer
//
//  Created by Даниил Чугуевский on 09.04.2024.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

  @IBOutlet weak var locationButton: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var blurHeaderView: UIVisualEffectView!
  @IBOutlet weak var mapView: MKMapView!
  
  var currentFilter = ObjectStore.shared.arrayCategories[0]
  var locationManager: CLLocationManager!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager = CLLocationManager()
    locationManager.delegate = self
    
    fetch()
    createShadowView()
    createCornerRadius()
    collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .horizontal
    }
    configureLocationButton()
    collectionView.dataSource = self
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      self.locationManager.requestWhenInUseAuthorization()
    }
  }
  
  func createCornerRadius() {
    headerView.layer.cornerRadius = 21
    headerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner ]
    blurHeaderView.layer.cornerRadius = 21
    blurHeaderView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner ]
    blurHeaderView.clipsToBounds = true
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
    headerView.layer.shadowColor = color.cgColor
    headerView.layer.shadowOpacity = alpha
    headerView.layer.shadowOffset = CGSize(width: x, height: y)
    headerView.layer.shadowRadius = blur
    headerView.layer.shadowRadius += spread
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
  
  //MARK: - CoolectionView
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return ObjectStore.shared.arrayCategories.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
    cell.display(ObjectStore.shared.arrayCategories[indexPath.row], currentFilter == ObjectStore.shared.arrayCategories[indexPath.row])
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    var indexesToReload: [IndexPath] = []
    let filterIndex = ObjectStore.shared.arrayCategories.firstIndex(of: currentFilter)
    guard let guardIndex = filterIndex else { return }
    
    let resultIndex = IndexPath(item: guardIndex, section: 0)
    indexesToReload.append(resultIndex)
    indexesToReload.append(indexPath)
    currentFilter = ObjectStore.shared.arrayCategories[indexPath.row]
    collectionView.reloadItems(at: indexesToReload)
  }
  
  // MARK: - API
  
  func fetch() {
    NetworkManager.shared.fetchData { response in
      switch response {
      case .success(let PinTable):
        print(PinTable)
      case .failure(let error):
        print(error)
      }
    }
  }
    
}

extension MapViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else { return }
    
    let latitude = location.coordinate.latitude
    let longitude = location.coordinate.longitude
    
    print("Latitude: \(latitude), Longitude: \(longitude)")
    
    let initialLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    
    let regionRadius: CLLocationDistance = 1000
    let coordinateRegion = MKCoordinateRegion(center: initialLocation, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
    mapView.setRegion(coordinateRegion, animated: true)
    
    let annotation = MKPointAnnotation()
    annotation.coordinate = initialLocation
    annotation.title = "Мое текущее местоположение"
    mapView.addAnnotation(annotation)
  }
  
}
