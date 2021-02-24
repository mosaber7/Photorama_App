//
//  ViewController.swift
//  Photrama
//
//  Created by Saber on 16/02/2021.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate {
    @IBOutlet var collectionView: UICollectionView!

    var store: PhotStore!
    var photoDataSource = PhotoDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        store.fetchInterstingPhotos{
            (photosResult) in
            switch photosResult{
            case let .success(photos):
                print("successfully found \(photos.count) photos")
                self.photoDataSource.photos = photos
            case let .failure(errno):
                print("Error fetching intersting phots: \(errno)")
                self.photoDataSource.photos.removeAll()
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = photoDataSource.photos[indexPath.row]
        
        store.fetchImage(for: photo) { (result) in
            guard let photoIndex = self.photoDataSource.photos.firstIndex(of: photo), case let .success(image) = result else{
                return
            }
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
            if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell{
                cell.update(displaying: image)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPhoto":
            if let selectedIndex = collectionView.indexPathsForSelectedItems?.first{
                let photo = photoDataSource.photos[selectedIndex.row]
                let destinationVC = segue.destination as! PhotoInfoViewController
                destinationVC.photo = photo
                destinationVC.store = store
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }


}

