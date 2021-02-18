//
//  Phot.swift
//  Photrama
//
//  Created by Saber on 17/02/2021.
//

import Foundation


class Photo: Codable, Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.photoID == rhs.photoID
    }
    
    
    
    let title: String
    let remoteURL: URL?
    let photoID: String
    let dateTaken: Date
    
    enum CodingKeys: String, CodingKey {
        case title
        case remoteURL = "url_z"
        case photoID = "id"
        case dateTaken = "datetaken"
    }
    
    

}
