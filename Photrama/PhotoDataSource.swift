//
//  PhotoDataSource.swift
//  Photrama
//
//  Created by Saber on 18/02/2021.
//

import UIKit

class PhotoDataSource: NSObject, UICollectionViewDataSource {
    var photos = [Photo]()

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionViewCell", for: indexPath) as!
            PhotoCollectionViewCell
        cell.update(displaying: nil)
        return cell
    }
    
}
