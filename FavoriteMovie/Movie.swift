//
//  Movie.swift
//  FavoriteMovie
//
//  Created by sanchez on 16.12.15.
//  Copyright © 2015 KOT LLC. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Movie: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    func setMoviePosterImage(img: UIImage) {
        let data = UIImagePNGRepresentation(img)
        self.image = data
    }
    
    func getMoviePosterImage() -> UIImage? {
        let img = UIImage(data: self.image!)!
        return img
    }
    
}
