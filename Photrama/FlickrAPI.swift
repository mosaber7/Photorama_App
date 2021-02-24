//
//  flickerAPI.swift
//  Photrama
//
//  Created by Saber on 16/02/2021.
//

import Foundation


enum EndPoint: String {
    case interestingPhotos = "flickr.interestingness.getList"
}

struct FlickrApI {
    
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let APIKey = "a6d819499131071f158fd740860a5a88"
    
    private static func flickrURL(endPoint: EndPoint, parameters: [String:String]?)-> URL{
        
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method":endPoint.rawValue,
            "format":"json",
            "nojsoncallback": "1",
            "api_key": APIKey]
        for (key, value) in baseParams{
            let queryItem = URLQueryItem(name: key, value: value)
            queryItems.append(queryItem)
        }
        
        if let additionalPrameters = parameters{
            for (key, value) in additionalPrameters{
                let queryItem = URLQueryItem(name: key, value: value)
                queryItems.append(queryItem)
            }
        }
        components.queryItems = queryItems
        return components.url!
    }
    
    static var interstingPhotosURL: URL{
        return flickrURL(endPoint: .interestingPhotos, parameters: ["extras": "url_z,date_taken"])
    }
    
    static func photos(fronJson data: Data) -> Result<[FlickrPhoto], Error>{
        do {
            let decoder = JSONDecoder()
            
            let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            let flickrResponce = try decoder.decode(FlickerResponse.self, from: data)
            return .success(flickrResponce.photosInfo.photos)
        } catch  {
            return .failure(error)
        }
        
    }
    
    
}
struct FlickerResponse: Codable {
    let photosInfo: FlickerPhotosResponse
    
    enum CodingKeys: String, CodingKey {
        case photosInfo = "photos"
    }
}
struct FlickerPhotosResponse: Codable {
    let photos : [FlickrPhoto]
    
    enum CodingKeys: String, CodingKey {
        case photos = "photo"
    }
    
}
