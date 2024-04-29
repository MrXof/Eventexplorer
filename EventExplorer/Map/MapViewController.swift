//
//  ViewController.swift
//  Eventexplorer
//
//  Created by Даниил Чугуевский on 09.04.2024.
//

import UIKit
import MapKit
import CoreLocation
import Combine

class MapViewController: UIViewController {
  //MapView @IBOutlet
  @IBOutlet private weak var locationButton: UIButton!
  @IBOutlet private weak var collectionView: UICollectionView!
  @IBOutlet private weak var headerView: UIView!
  @IBOutlet private weak var blurHeaderView: UIVisualEffectView!
  @IBOutlet private weak var mapView: MKMapView!
  @IBOutlet private weak var countPeople: UILabel!
  //PopUp @IBOutlet
  @IBOutlet weak var popUpView: UIView!
  @IBOutlet weak var friendsGoingLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var nameButton: UILabel!
  @IBOutlet weak var cancelButton: UIButton!
  
  @IBOutlet weak var openDetailsButton: UIButton!
  @IBOutlet weak var blurPopUpView: UIVisualEffectView!
  
  var currentFilter = ObjectStore.shared.arrayCategories[0]
  let locationManager = CLLocationManager()
  var cancellables = [AnyCancellable]()
  let module = MapModule()
  let identifier = "CustomAnnotation"
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    createShadowView()
    createCornerRadius()
    configureLocationButton()
    setupMapView()
    setupBindings()
    settingsMap()
    settingsPopup()
  }
  
  func createCornerRadius() {
    headerView.layer.cornerRadius = 21
    headerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner ]
    blurHeaderView.layer.cornerRadius = 21
    blurHeaderView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner ]
    blurHeaderView.clipsToBounds = true
    
    //popUpView
    popUpView.layer.cornerRadius = 21
    popUpView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    blurPopUpView.layer.cornerRadius = 21
    blurPopUpView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    blurPopUpView.clipsToBounds = true
  }
  
  func createShadowView(
    color: UIColor = .black,
    alpha: Float = 1,
    x: CGFloat = 0,
    y: CGFloat = 20,
    PopUpY: CGFloat = 2,
    blur: CGFloat = 25,
    spread: CGFloat = -12,
    popUpSpread: CGFloat = -5
  )
  {
    headerView.layer.shadowColor = color.cgColor
    headerView.layer.shadowOpacity = alpha
    headerView.layer.shadowOffset = CGSize(width: x, height: y)
    headerView.layer.shadowRadius = blur
    headerView.layer.shadowRadius += spread
    
    //popUpView
    popUpView.layer.shadowColor = color.cgColor
    popUpView.layer.shadowOpacity = alpha
    popUpView.layer.shadowOffset = CGSize(width: x, height: PopUpY)
    popUpView.layer.shadowRadius = blur
    popUpView.layer.shadowRadius += popUpSpread
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
  
  //MARK: - Other settings
  
  func setupMapView() {
    collectionView.dataSource = self
    collectionView.delegate = self
    mapView.delegate = self
    locationManager.delegate = self
    self.locationManager.requestWhenInUseAuthorization()
    
    collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .horizontal
    }
    locationManager.startUpdatingLocation()
  }
  
  func setupBindings() {
    module.$pinTableArray.sink { array in
      print(array)
      self.addPointsToMap(array)
    }.store(in: &cancellables)
  }
  
  func settingsMap() {
    mapView.register(PinWithFriendAnnotationView.self,
                     forAnnotationViewWithReuseIdentifier: String(describing: PinWithFriendAnnotationView.self))
    mapView.register(PinAnnotationView.self,
                     forAnnotationViewWithReuseIdentifier: String(describing: PinAnnotationView.self))
  }
  
  func settingsPopup() {
    popUpView.backgroundColor = UIColor.white
    popUpView.alpha = 0
    
    
    let attributs : [NSAttributedString.Key: Any] = 
    [.font: UIFont(name: "RedHatDisplay-Bold", size: 16)!,
      .foregroundColor: UIColor.white
    ]
    let attributedString = NSAttributedString(string: "Open details", attributes: attributs)
    openDetailsButton.setAttributedTitle(attributedString, for: .normal)
    openDetailsButton.configuration = openDetailsButton.configuration ?? .plain()
    openDetailsButton.configuration?.contentInsets.leading = 0
  }
  
  //MARK: - Annotation and map settings
  
  func addPointsToMap(_ points: [AirtableRecord<Pin>]) {
    let oldAnnotation = self.mapView.annotations
    mapView.removeAnnotations(oldAnnotation)
    
    let points = generateAnnotations(from: points)
    mapView.addAnnotations(points)
  }
  
  func generateAnnotations(from points: [AirtableRecord<Pin>]) -> [PinAnnotation] {
    var arrayPoints: [PinAnnotation] = []
    
    guard !points.isEmpty else {
      return arrayPoints
    }
    
    for record in points {
      let latitude = record.fields.latitudeLocation
      let longtitude = record.fields.longitudeLocation
      let annotation = PinAnnotation(latitude: latitude, lontitude: longtitude, image: record.fields.friendAvatar?.url, icon: record.fields.icon, usersGoing: record.fields.usersGoing, friendsAreGoing: record.fields.friendsAreGoing)
      arrayPoints.append(annotation)
    }
    
    return arrayPoints
  }
  
}

//MARK: - Extension

extension MapViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let latitude = 48.467707
    let longitude = 35.050814
    
    let initialLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    
    let regionRadius: CLLocationDistance = 2000
    let coordinateRegion = MKCoordinateRegion(center: initialLocation, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
    mapView.setRegion(coordinateRegion, animated: true)
  }
  
}

extension MapViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let customAnnotation = annotation as? PinAnnotation else { return nil }
    
    if !customAnnotation.friendsAreGoing {
      
      let annotationViewEventSecondPoint = mapView.dequeueReusableAnnotationView(withIdentifier: String(describing: PinAnnotationView.self)) as? PinAnnotationView
      annotationViewEventSecondPoint?.display(annotation)
      
      return annotationViewEventSecondPoint
    } else {
      
      let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: String(describing: PinWithFriendAnnotationView.self)) as! PinWithFriendAnnotationView
      annotationView.display(annotation)
      return annotationView
    }
    
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
      if let annotation = view.annotation {
        UIView.animate(withDuration: 0.5) {
          self.popUpView.alpha = 1
        }
        
      }
  }
  
}

extension MapViewController: UICollectionViewDelegate {
  
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
  
}

extension MapViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return ObjectStore.shared.arrayCategories.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
    cell.display(ObjectStore.shared.arrayCategories[indexPath.row], currentFilter == ObjectStore.shared.arrayCategories[indexPath.row])
    return cell
  }
  
}
