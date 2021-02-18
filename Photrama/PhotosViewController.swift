//
//  ViewController.swift
//  Photrama
//
//  Created by Saber on 16/02/2021.
//

import UIKit

class PhotosViewController: UIViewController {
    @IBOutlet private var imageView: UIImageView!
    var store: PhotSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        store.fetchInterstingPhotos{
            (photosResult) in
            switch photosResult{
            case let .success(photos):
                print("successfully found \(photos.count) photos")
                if let firstPhoto = photos.last{
                    self.updateImageView(for: firstPhoto)
                }
            case let .failure(errno):
                print("Error fetching intersting phots: \(errno)")
            }        }
    }
    
    func updateImageView(for photo: Photo){
        store.fetchImage(for: photo) { (imageResault) in
            switch imageResault{
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error: \(error)")
            }
        }
    }


}

