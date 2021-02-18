//
//  ImageStore.swift
//  LootLogger
//
//  Created by Saber on 08/02/2021.
//

import UIKit

class ImageStore {
    let cache = NSCache<NSString, UIImage>()
    
    func setImage(_ image: UIImage, forKey key: String) {
        
        let url = imageURL(forKey: key)
        if let data = image.jpegData(compressionQuality: 0.5){
            try? data.write(to: url)
        }
        
    }
    
    func removeImage(forKey key: String){
        
        cache.removeObject(forKey: key as NSString)
        
        let url = imageURL(forKey: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch  {
            print("Error deleting from the librbary")
        }
    }
    
    func image(forKey key: String) -> UIImage?{
        if let existingImage = cache.object(forKey: key as NSString){
            return existingImage
        }
        
        let url = imageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }
    
    
    func imageURL(forKey key: String)-> URL{
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.appendingPathComponent(key)
        
    }
    
    
}
