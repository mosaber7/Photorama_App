//
//  PhotoInfoViewController.swift
//  Photrama
//
//  Created by Saber on 19/02/2021.
//

import UIKit

class PhotoInfoViewController: UIViewController{
    @IBOutlet var imageView: UIImageView!
    var photo: Photo!{
        didSet{
            navigationItem.title = photo.title
        }
    }
    var store:PhotStore!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchImage(for: photo) { (resault) in
            switch resault{
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("error fetching image for photo: \(error)")
                
            }
        }
    }
}
