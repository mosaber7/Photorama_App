//
//  PhotoSource.swift
//  Photrama
//
//  Created by Saber on 17/02/2021.
//

import UIKit
import CoreData

enum PhotoError:Error {
    case imageCreationError
    case missingImageURL
}

class PhotStore{
    let imageStore = ImageStore()
    
    let persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Photrama")
        container.loadPersistentStores { (description, error) in
            if let error = error{
                print("Error setting up coreData: \(error)")
            }
            
        }
        return container
    }()
    
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchInterstingPhotos(completion: @escaping (Result<[Photo], Error>)-> Void){
        let url = FlickrApI.interstingPhotosURL
        
        let request = URLRequest(url: url)
        session.dataTask(with: request) { (data, url, erroe) in
            
           var result = self.processPhotoRequest(data: data, error: erroe)
            if case .success = result{
                do{
                    try
                        self.persistentContainer.viewContext.save()
                }catch{
                    result = .failure(error)
                }
            }
            OperationQueue.main.addOperation {
                completion(result)
                
            }
        }.resume()
        
    }
    
    private func processPhotoRequest(data: Data?, error: Error?) -> Result<[Photo], Error>{
        guard let jsonData = data else {
            return .failure(error!)
        }
        let context = persistentContainer.viewContext
        switch FlickrApI.photos(fronJson: jsonData) {
            case let .success(flickrPhoto):
                let photos = flickrPhoto.map{
                    flickrPhoto -> Photo in
                    var photo: Photo!
                    context.performAndWait {
                        photo = Photo(context: context)
                        photo.title = flickrPhoto.title
                        photo.photoID = flickrPhoto.photoID
                        photo.remoteURL = flickrPhoto.remoteURL
                        photo.dateTaken = flickrPhoto.dateTaken
                        
                    }
                    return photo
                }
                return .success(photos)
            case let .failure(error):
                return .failure(error)
            }
    }
    func fetchImage(for photo: Photo, completion: @escaping(Result<UIImage, Error>)->Void){
        
        guard let photoKey = photo.photoID else{
            preconditionFailure("phot expected to have a photoID")
        }
        
        if let image = imageStore.image(forKey: photoKey){
            OperationQueue.main.addOperation {
                completion(.success(image))
            }
        }
        guard let photoURL = photo.remoteURL else {
            completion(.failure(PhotoError.missingImageURL))
            return
        }
        let request = URLRequest(url: photoURL)
        session.dataTask(with: request){(data, response, error) in
            let result = self.processImageRequest(data: data, error: error)
            
            if case let .success(image) = result{
                self.imageStore.setImage(image, forKey: photoKey)
            }
            OperationQueue.main.addOperation {
                completion(result)
                
            }
        }.resume()
        
    }
    private func processImageRequest(data: Data?, error: Error?)-> Result<UIImage, Error>{
        guard let imageData = data, let image = UIImage(data: imageData) else {
            if data == nil{
                return .failure(error!)
            }
            return .failure(PhotoError.imageCreationError)
        }
        return .success(image)
    }
}
