//
//  Person.swift
//  iMeet
//
//  Created by dominator on 31/03/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import SwiftUI
import CoreLocation
class Person: Codable, ObservableObject, Identifiable {
    var id = UUID()
    var name: String
    var description: String
    var profileImage: UIImage?
    var location: CLLocationCoordinate2D?
    
    init(name: String, description: String, profileImage: UIImage? = nil, location: CLLocationCoordinate2D? = nil) {
        self.name = name
        self.description = description
        self.profileImage = profileImage
    }
    
    enum CodingKeys: CodingKey{
        case id, name, description, profileImage, lattitude, longitude
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        if let imageData = try container.decodeIfPresent(Data.self, forKey: .profileImage){
            self.profileImage = UIImage(data: imageData)!
        }else{
            self.profileImage = nil
        }
        
        guard let lat = try container.decodeIfPresent(Double.self, forKey: .lattitude) else {
            self.location = nil
            return
        }
        
        guard let lon = try container.decodeIfPresent(Double.self, forKey: .longitude) else{
            self.location = nil
            return
        }
        
        self.location = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon))
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        if let image = profileImage{
            try container.encode(image.jpegData(compressionQuality: 1), forKey: .profileImage)
            
        }
        
        if let location = location{
            try container.encode(Double(location.latitude), forKey: .lattitude)
            try container.encode(Double(location.longitude), forKey: .longitude)
        }
    }
}
