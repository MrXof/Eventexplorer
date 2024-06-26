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

class MapViewController: UIViewController, UIGestureRecognizerDelegate {
  //MapView @IBOutlet
  @IBOutlet weak var loaderView: UIView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet private weak var locationButton: UIButton!
  @IBOutlet private weak var collectionView: UICollectionView!
  @IBOutlet private weak var headerView: UIView!
  @IBOutlet private weak var blurHeaderView: UIVisualEffectView!
  @IBOutlet private weak var mapView: MKMapView!
  @IBOutlet private weak var countPeople: UILabel!
  //PopUp @IBOutlet
  @IBOutlet weak var popUpView: UIView!
  @IBOutlet weak var usersGoingLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var categoryView: UIView!
  @IBOutlet weak var dateView: UIView!
  @IBOutlet weak var priceView: UIView!
  @IBOutlet weak var timeView: UIView!
  @IBOutlet weak var openDetailsButton: UIButton!
  @IBOutlet weak var blurPopUpView: UIVisualEffectView!
  //popUpViewInfoTeg
  @IBOutlet weak var iconCategoryLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet var pinchGestureRecognizer: UIPanGestureRecognizer!
  
  let locationManager = CLLocationManager()
  var cancellables = [AnyCancellable]()
  let module = MapModule()
  var canUpdateMapCenter: Bool = true
  var countActivities = Int()
  var previousRegion: MKCoordinateRegion?
  var arrayPoints: [PinAnnotation] = []
  var trayOriginalCenter: CGPoint!
  var trayDownOffset: CGFloat!
  var trayUp: CGPoint!
  var trayDown: CGPoint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    createShadowView()
    createCornerRadius()
    configureLocationButton()
    setupMapView()
    setupBindings()
    settingsMap()
    settingsPopup()
    addBorderForView()
    pinchGestureRecognizer.delegate = self
    trayDownOffset = 160
    trayUp = popUpView.center
    trayDown = CGPoint(x: popUpView.center.x ,y: popUpView.center.y + trayDownOffset)
    settingFont()
  }
  //MARK: setting Header View and PopUp View
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
    alpha: Float = 0.3,
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
    let attributs : [NSAttributedString.Key: Any] = [
      .font: UIFont(name: "RedHatDisplay-Bold", size: 29)!,
      .foregroundColor: UIColor.black
    ]
    locationButton.configuration = locationButton.configuration ?? .plain()
    locationButton.configuration?.contentInsets.leading = 0
  }
  
  func addBorderForView() {
    let borderColor = UIColor(red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
    categoryView.layer.borderWidth = 1
    categoryView.layer.borderColor = borderColor.cgColor
    dateView.layer.borderWidth = 1
    dateView.layer.borderColor = borderColor.cgColor
    timeView.layer.borderWidth = 1
    timeView.layer.borderColor = borderColor.cgColor
    priceView.layer.borderWidth = 1
    priceView.layer.borderColor = borderColor.cgColor
  }
  
  func settingsPopup() {
    popUpView.backgroundColor = UIColor.white
    hidePopView(animated: false)
    let attributs : [NSAttributedString.Key: Any] =
    [.font: UIFont(name: "RedHatDisplay-Bold", size: 16)!,
     .foregroundColor: UIColor.white
    ]
    let attributedString = NSAttributedString(string: "Open details", attributes: attributs)
    openDetailsButton.setAttributedTitle(attributedString, for: .normal)
    openDetailsButton.configuration = openDetailsButton.configuration ?? .plain()
    openDetailsButton.configuration?.contentInsets.leading = 0
    
    scrollView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    self.popUpView.backgroundColor = UIColor(red: 246/255, green: 248/255, blue: 245/255, alpha: 0.9)
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
    
    mapView.overrideUserInterfaceStyle = .light
  }
  
  func setupBindings() {
    module.$pinArray.sink { array in
      print(array)
      self.addPointsToMap(array)
      self.countActivities = array.count
      self.countPeople.text = String(format: "%d %@", self.countActivities, NSLocalizedString("header_view.label.count_people", comment: ""))
      print(self.module.isLoading)
    }.store(in: &cancellables)
    module.$isLoading.sink { status in
      self.setLoaderStatus(status)
    }.store(in: &cancellables)
  }
  
  func settingsMap() {
    mapView.register(PinWithFriendAnnotationView.self,
                     forAnnotationViewWithReuseIdentifier: String(describing: PinWithFriendAnnotationView.self))
    mapView.register(PinAnnotationView.self,
                     forAnnotationViewWithReuseIdentifier: String(describing: PinAnnotationView.self))
  }
  
  //MARK: - Annotation and map settings
  
  func addPointsToMap(_ points: [AirtableRecord<Pin>]) {
    let oldAnnotation = self.mapView.annotations
    mapView.removeAnnotations(oldAnnotation)

    let newPoints = generateAnnotations(from: points)
    mapView.addAnnotations(newPoints)
    arrayPoints = newPoints
  }
  
  func generateAnnotations(from points: [AirtableRecord<Pin>]) -> [PinAnnotation] {
    var arrayPoints: [PinAnnotation] = []
    guard !points.isEmpty else {
      return arrayPoints
    }
    
    for record in points {
      let latitude = record.fields.latitudeLocation
      let longitude = record.fields.longitudeLocation
      let annotation = PinAnnotation(latitude: latitude,
                                     longitude: longitude,
                                     image: record.fields.friendAvatar?.url,
                                     icon: record.fields.icon,
                                     usersGoing: record.fields.usersGoing,
                                     friendsAreGoing: record.fields.friendsAreGoing,
                                     name: record.fields.name,
                                     adress: record.fields.address,
                                     category: record.fields.category,
                                     date: record.fields.date,
                                     priceTier: record.fields.priceTier)
      arrayPoints.append(annotation)
    }
    
    return arrayPoints
  }
  
  @IBAction func cancelButton(_ sender: Any) {
    hidePopView()
  }
  
  @IBAction func cahngeCityButton(_ sender: Any) {
    alertCommingSoon()
  }
  
  @IBAction func exploreButton(_ sender: Any) {
    alertCommingSoon()
  }
  
  @IBAction func filtersButton(_ sender: Any) {
    alertCommingSoon()
  }
  
  @IBAction func openDetailsButton(sender: Any) {
    alertCommingSoon()
  }
  
  func savePreviousRegion() {
    previousRegion = mapView.region
  }
  
  func restorePreviousRegion() {
    if let previousRegion = previousRegion {
      mapView.setRegion(previousRegion, animated: true)
    }
  }
  
  @IBAction func panGestureRecognizerPopUpView(sender: UIPanGestureRecognizer) {
    let translation = sender.translation(in: popUpView)
    
    if sender.state == .began {
      self.trayOriginalCenter = popUpView.center
    } else if sender.state == .changed {
      if translation.y > 0 {
        popUpView.transform = CGAffineTransform(translationX: 0, y: translation.y)
      }
    } else if sender.state == .ended {
      let velocity = sender.velocity(in: popUpView)
      
      if velocity.y > 0 {
        self.hidePopView()
      } else {
        self.showPopView()
      }
    }
  }
  
  func showPopView() {
    UIView.animate(withDuration: 0.15) {
      self.popUpView.transform = CGAffineTransform(translationX: 0, y: 0)
    }
  }
  
  func hidePopView(animated: Bool = true) {
    UIView.animate(withDuration: animated ? 0.15 : 0.0, animations: {
      self.popUpView.transform = CGAffineTransform(translationX: 0, y: self.popUpView.bounds.height)
    })
    self.mapView.selectedAnnotations = []
    let annotations: [MKAnnotation] = self.arrayPoints.compactMap { $0 }
    self.mapView.addAnnotations(annotations)
    restorePreviousRegion()
  }
  
  func alertCommingSoon(){
    let alert = UIAlertController(title: nil, message: "Coming Soon…", preferredStyle: .alert)
    self.present(alert, animated: true, completion: nil)
    
    let duration: Double = 2.0
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
      alert.dismiss(animated: true, completion: nil)
    }
  }
  
  func setLoaderStatus(_ status: Bool) {
    if status {
      activityIndicator.startAnimating()
      loaderView.isHidden = false
    } else {
      activityIndicator.stopAnimating()
      loaderView.isHidden = true
    }
  }
  
  func settingFont() {
    let attributs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "RedHatDisplay-Bold", size: 29)]
    let attributedString = NSAttributedString(string: "Dnipro", attributes: attributs)
    locationButton.setAttributedTitle(attributedString, for: .normal)
  }
  
}

//MARK: - Extension

extension MapViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard canUpdateMapCenter else { return }
    
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
  
  func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
    canUpdateMapCenter = false
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    showPopView()
    savePreviousRegion()
    mapView.removeAnnotations(mapView.annotations.filter {$0 !== view.annotation })
    mapView.selectedAnnotations = [view.annotation].compactMap({$0})
    guard let annotation = view.annotation as? PinAnnotation else { return }
    
    nameLabel.text = annotation.name
    addressLabel.text = annotation.adress
    usersGoingLabel.text = "\(annotation.usersGoing) people going"
    iconCategoryLabel.text = annotation.icon
    categoryLabel.text = annotation.category.name
    priceLabel.text = annotation.priceTier.title()
    
    //changeDateFormat
    let dateFormatterDate = DateFormatter()
    dateFormatterDate.dateFormat = "MMMM d"
    
    let dateFormatterTime = DateFormatter()
    dateFormatterTime.dateFormat = "h:mm a"
    
    let datePart = dateFormatterDate.string(from: annotation.date)
    let timePart = dateFormatterTime.string(from: annotation.date)
    self.dateLabel.text = datePart
    self.timeLabel.text = timePart
    
    let radius: CLLocationDistance = 2000
    let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
    mapView.setRegion(region, animated: true)
  }
  
}

extension MapViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    var indexesToReload: [IndexPath] = []
    let filterIndex = ObjectStore.shared.arrayCategories.firstIndex(of: module.currentFilter)
    guard let guardIndex = filterIndex else { return }
    
    let resultIndex = IndexPath(item: guardIndex, section: 0)
    indexesToReload.append(resultIndex)
    indexesToReload.append(indexPath)
    module.applyCurrentFilter(ObjectStore.shared.arrayCategories[indexPath.row])
    collectionView.reloadItems(at: indexesToReload)
  }
  
}

extension MapViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return ObjectStore.shared.arrayCategories.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
    cell.display(ObjectStore.shared.arrayCategories[indexPath.row], module.currentFilter == ObjectStore.shared.arrayCategories[indexPath.row])
    return cell
  }
  
}
