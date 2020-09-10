//
//  ViewController.swift
//  PixelCity
//
//  Created by Ścibor Budkowski on 08/09/2020.
//  Copyright © 2020 Ścibor Budkowski. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import AlamofireImage
import SwiftyJSON

class MapVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pullUpView: UIView!
    
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000
    let screenSize = UIScreen.main.bounds
    
    var spinner: UIActivityIndicatorView?
    var progressLabel: UILabel?
    var collectionView: UICollectionView?
    var flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    var imageUrls:[String: String] = [String: String]()
    //var imageArray:[UIImage] = [UIImage]()
    var photoArray:[PhotoCollection] = [PhotoCollection()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        
        configureLocationServices()
        addDoubleTap()
        //addPinch()
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: "photoCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = #colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 0.25)
        
        pullUpView.addSubview(collectionView!)
    }
    
    func addDoubleTap() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin(_ :)))
        doubleTap.numberOfTapsRequired = 1
        doubleTap.delegate = self
        mapView.addGestureRecognizer(doubleTap)
    }
    
    func addSwipe() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(animateViewDown))
        swipe.direction = .down
        pullUpView.addGestureRecognizer(swipe)
    }
    
    func animateViewUp() {
        heightConstraint.constant = 300
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func animateViewDown() {
        cancelAllSessions()
        heightConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func addSpinner() {
        spinner = UIActivityIndicatorView()
        spinner?.center = CGPoint(x: (screenSize.width / 2) - ((spinner?.frame.width)! / 2), y: 150)
        spinner?.style = .large
        spinner?.color = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        spinner?.startAnimating()
        collectionView?.addSubview(spinner!)
    }
    
    func removeSpinner() {
        if spinner != nil {
            spinner?.removeFromSuperview()
        }
    }
    
    func addProgressLabel() {
        self.progressLabel = UILabel()
        progressLabel?.frame = CGRect(x: (screenSize.width / 2) - 130, y: 175, width: 260, height: 40)
        progressLabel?.font = UIFont(name: "Avenir Next", size: 15)
        progressLabel?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        progressLabel?.textAlignment = .center
        progressLabel?.text = ""
        collectionView?.addSubview(progressLabel!)
    }
    
    func removeProgressLabel() {
        if progressLabel != nil {
            progressLabel?.removeFromSuperview()
        }
    }

    @IBAction func centerMapPressed(_ sender: Any) {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            centerMapOnUserLocation()
        }
    }
    
    @IBAction func settingsPressed(_ sender: Any) {
        let settingsVC = SettingsVC()
        settingsVC.modalPresentationStyle = .custom
        present(settingsVC, animated: true, completion: nil)
        
    }
}

extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
        pinAnnotation.pinTintColor = UIColor.orange
        pinAnnotation.animatesDrop = true
        
        return pinAnnotation
    }
    
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func dropPin(_ sender: UITapGestureRecognizer) {
        removePin()
        removeSpinner()
        removeProgressLabel()
        cancelAllSessions()
        removeImagesFromView()
                
        animateViewUp()
        addSwipe()
        addSpinner()
        addProgressLabel()
        
        let touchPoint = sender.location(in: mapView)
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = DropablePin(coordinate: touchCoordinate, identifier: "droppablePin")
        mapView.addAnnotation(annotation)
        
        let coordinateRegion = MKCoordinateRegion(center: touchCoordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
        retrieveURLs(forAnnotation: annotation) { (success) in
            if success {
                self.downloadImages { (success) in
                    if success {
                        self.removeSpinner()
                        self.removeProgressLabel()
                        self.collectionView?.reloadData()
                    }
                }
            }
        }
    }
    
    func removeImagesFromView() {
        imageUrls = [:]
        photoArray = []
        collectionView?.reloadData()
    }
    
    func removePin() {
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
    }
    
    func retrieveURLs(forAnnotation annotation: DropablePin, completion: @escaping (_ status: Bool) -> ()) {
        AF.request(flickrGetPhotosForLocation(withAnnotation: annotation, andNumberOfPhotos: 40)).responseJSON { (response) in
            guard let json = response.value as? Dictionary<String, AnyObject> else { return }
            let photosDict = json["photos"] as! Dictionary<String, AnyObject>
            let photosDictArray = photosDict["photo"] as! [Dictionary<String, AnyObject>]
            for photo in photosDictArray {
                // https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
                let postURL: String = "https://farm\(photo["farm"]!).staticflickr.com/\(photo["server"]!)/\(photo["id"]!)_\(photo["secret"]!).jpg"
                self.imageUrls["\(String(describing: photo["id"]))"] = postURL
            }
            completion(true)
        }
    }
    
    func downloadImages(completion: @escaping (_ status: Bool) -> ()) {
        for(key, value) in imageUrls {
            AF.request(value).responseImage { (response) in
                guard let image = response.value else { return }
                let keyForPhoto = key.replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")", with: "")
                AF.request(flickrGetPhotoDetails(forId: keyForPhoto)).responseJSON { (response) in
                    if response.error == nil {
                        guard let data = response.data else { return }
                        let json = JSON(data)
                        var username: String = json["photo"]["owner"]["username"].stringValue
                        if json["photo"]["owner"]["realname"].stringValue != "" {
                            username = "\(json["photo"]["owner"]["realname"].stringValue) (\(username))"
                        }
                        let photo = PhotoCollection(image: image, id: json["photo"]["id"].stringValue, username: username, date: json["photo"]["dates"]["taken"].stringValue, title: json["photo"]["title"]["_content"].stringValue, description: json["photo"]["description"]["_content"].stringValue, url: value, webpage: json["photo"]["urls"]["url"][0]["_content"].stringValue, hasDetails: true)
                        
                        self.photoArray.append(photo)
                    }
                    
                    self.progressLabel?.text = "\(self.photoArray.count)/40 IMAGES DOWNLOADED"
                    if self.photoArray.count == self.imageUrls.count {
                        completion(true)
                    }
                }
            }
        }
    }
    
    func cancelAllSessions() {
        Alamofire.Session.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { (task) in
                task.cancel()
            }
            downloadData.forEach { (task) in
                task.cancel()
            }
        }
    }
}

extension MapVC: CLLocationManagerDelegate {
    
    func configureLocationServices() {
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnUserLocation()
    }
}

extension MapVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        let imageFromIndex = photoArray[indexPath.row].image
        let imageView = UIImageView(image: imageFromIndex)
        imageView.contentMode = .scaleAspectFit
        
        cell.addSubview(imageView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let popVC = storyboard?.instantiateViewController(identifier: TO_POP_VC) as? PopVC else { return }
        popVC.initData(forPhoto: photoArray[indexPath.row])
        present(popVC, animated: true, completion: nil)
    }
}

//extension MapVC: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let size = UIScreen.main.bounds.width / 5
//        return(CGSize(width: size, height: size))
//    }
//}
