//
//  PopVC.swift
//  PixelCity
//
//  Created by Ścibor Budkowski on 09/09/2020.
//  Copyright © 2020 Ścibor Budkowski. All rights reserved.
//

import UIKit

class PopVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var popImageView: UIImageView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var photoNameLbl: UILabel!
    @IBOutlet weak var photographerLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var gotoPageBtn: CircleButton!
    
    var isDetailsHidden = true
    
    var photo = PhotoCollection()
    
    func initData(forPhoto photo: PhotoCollection) {
        self.photo = photo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTap()
        
        popImageView.image = photo.image
        hideDetails(true)
        photo.webpage = photo.webpage!.replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")", with: "")
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func detailsPressed(_ sender: Any) {
        photoNameLbl.text = photo.title
        photographerLbl.text = photo.username
        dateLbl.text = "(\(photo.date!))"
        
        if photo.description != "" {
            descriptionLbl.text = photo.description
        }
        
        UIView.transition(with: detailsView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.hideDetails(!self.isDetailsHidden)
        })
    }
    
    @IBAction func imageViewModePressed(_ sender: Any) {
        let mode = popImageView.contentMode
        
        if mode == .scaleAspectFill {
            UIImageView.transition(with: popImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.popImageView.contentMode = .scaleAspectFit
            })
            return
        }
        if mode == .scaleAspectFit {
            UIImageView.transition(with: popImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.popImageView.contentMode = .scaleAspectFill
            })
            return
        }
    }
    
    func addTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideDetailsView))
        tap.numberOfTouchesRequired = 1
        tap.delegate = self
        detailsView.addGestureRecognizer(tap)
    }
    
    @objc func hideDetailsView() {
        UIView.transition(with: detailsView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.hideDetails(true)
        })
    }
    
    override func viewWillLayoutSubviews() {
        descriptionLbl.sizeToFit()
    }
    
    func hideDetails(_ to: Bool) {
        isDetailsHidden = to
        detailsView.isHidden = to
        photoNameLbl.isHidden = to
        photographerLbl.isHidden = to
        dateLbl.isHidden = to
        descriptionLbl.isHidden = to
        
        if photo.webpage == "" {
            gotoPageBtn.isHidden = true
        } else {
            gotoPageBtn.isHidden = to
        }
    }
    
    @IBAction func gotoPagePressed(_ sender: Any) {
        if let url = URLComponents(string: (photo.webpage!)) {
            UIApplication.shared.open(url.url!)
        }
    }
}
