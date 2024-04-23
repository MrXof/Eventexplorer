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

class MapViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
  @IBOutlet weak var locationButton: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var blurHeaderView: UIVisualEffectView!
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var countPeople: UILabel!
  
  var currentFilter = ObjectStore.shared.arrayCategories[0]
  let locationManager = CLLocationManager()
  var cancellables = [AnyCancellable]()
  var annotation = MKPointAnnotation()
  var coordinate = CLLocationCoordinate2D()
  let module = MapModule()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addPoints()
    module.$pinTableArray.sink { array in
      self.updateMapData(with: array)
    }.store(in: &cancellables)
    
    mapView.delegate = self
    locationManager.delegate = self
    locationManager.startUpdatingLocation()
    self.locationManager.requestWhenInUseAuthorization()
    createShadowView()
    createCornerRadius()
    collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .horizontal
    }
    configureLocationButton()
    collectionView.dataSource = self
    collectionView.delegate = self
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
  

  func updateMapData(with array: [AirtableRecord<Pin>]) {
    for record in array {
      coordinate = CLLocationCoordinate2D(latitude: record.fields.latitudeLocation , longitude: record.fields.longitudeLocation)
    }
    
    annotation.coordinate = coordinate
    annotation.title = "Test Point"
    mapView.addAnnotation(annotation)
    
  }
  
  func addPoints() {
    
    let oldAnnotation = self.mapView.annotations
    mapView.removeAnnotations(oldAnnotation)
    
    let points = generatePoints(module.pinTableArray.count)
    mapView.addAnnotations(points)
    
  }
  
  func generatePoints(_ pointsCount: Int) -> [CustomAnnotation] {
    
    var points: [CustomAnnotation] = []
    
    guard !module.pinTableArray.isEmpty else {
      return points
    }
    
    for _ in 0..<pointsCount {

      for record in module.pinTableArray {
        let latitude = record.fields.latitudeLocation
        let longtitude = record.fields.latitudeLocation
        let annotation = CustomAnnotation(latitude: latitude, lontitude: longtitude)
        points.append(annotation)
      }
    }
    return points
  }
  
}

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
    guard !(annotation is MKUserLocation) else { return nil }
    
    let identifier = "CustomAnnotation"
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
    
    if annotationView == nil {
      annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      annotationView?.canShowCallout = true
      
    } else {
      annotationView?.annotation = annotation
    }
    
    annotationView?.image = UIImage()
    return annotationView
  }
  
}
