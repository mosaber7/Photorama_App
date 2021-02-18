//
//  PhotoCollectionViewCell.swift
//  Photrama
//
//  Created by Saber on 19/02/2021.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    func update(displaying image: UIImage?){
        if let imageToDisplay = image{
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        }else{
            spinner.startAnimating()
            imageView.image = nil
        }
        
    }
}
