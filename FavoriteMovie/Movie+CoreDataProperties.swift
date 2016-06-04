//
//  Movie+CoreDataProperties.swift
//  FavoriteMovie
//
//  Created by sanchez on 17.12.15.
//  Copyright © 2015 KOT LLC. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Movie {

    @NSManaged var actors: String?
    @NSManaged var director: String?
    @NSManaged var fullDescription: String?
    @NSManaged var genre: String?
    @NSManaged var image: NSData?
    @NSManaged var imdbId: String?
    @NSManaged var personalDescription: String?
    @NSManaged var releaseDate: String?
    @NSManaged var title: String?
    @NSManaged var writer: String?
    @NSManaged var movieType: String?
    @NSManaged var rate: String?

}
