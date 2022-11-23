//
//  FavMovies+CoreDataProperties.swift
//  Movies
//
//  Created by Murilo Ribeiro de Oliveira on 01/11/22.
//

import Foundation
import CoreData


extension FavMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavMovie> {
       
        let request = NSFetchRequest<FavMovie>(entityName:"FavMovie")
        request.sortDescriptors = []
        return request
        
    }

    @NSManaged public var id: String
    @NSManaged public var movieName: String
    @NSManaged public var movieYear: String
    @NSManaged public var posterPath: String
    @NSManaged public var movieDescription: String
    @NSManaged public var movieGenre: String

}

extension FavMovie : Identifiable {

}
