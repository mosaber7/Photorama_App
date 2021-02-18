//
//  PhotoSource.swift
//  Photrama
//
//  Created by Saber on 17/02/2021.
//

import UIKit

enum PhotoError:Error {
    case imageCreationError
    case missingImageURL
}

class PhotSource{
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchInterstingPhotos(completion: @escaping (Result<[Photo], Error>)-> Void){
        let url = FlickrApI.interstingPhotosURL
        
        let request = URLRequest(url: url)
        session.dataTask(with: request) { (data, url, erroe) in
            
            let result = self.processPhotoRequest(data: data, error: erroe)
            OperationQueue.main.addOperation {
                completion(result)

            }
        }.resume()
     
    }
    
    private func processPhotoRequest(data: Data?, error: Error?) -> Result<[Photo], Error>{
        guard let jsonData = data else {
            return .failure(error!)
        }
        return FlickrApI.photos(fronJson: jsonData)
    }
    func fetchImage(for photo: Photo, completion: @escaping(Result<UIImage, Error>)->Void){
        guard let photoURL = photo.remoteURL else {
            completion(.failure(PhotoError.missingImageURL))
            return
        }
        let request = URLRequest(url: photoURL)
        session.dataTask(with: request){(data, response, error) in
            let result = self.processImageRequest(data: data, error: error)
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
