//
//  CoreData.swift
//  Movies
//
//  Created by Murilo Ribeiro de Oliveira on 01/11/22.
//
import UIKit
import CoreData



class CoreData {

    
    private let controller: NSFetchedResultsController<FavMovie>
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {fatalError()}
        let request = FavMovie.fetchRequest()
        let managedContext = appDelegate.persistentContainer.viewContext
        controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func requestFavorites(completion: @escaping ((Result<[FavMovie], Error>) -> Void)) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError()}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavMovie")

        controller.managedObjectContext.performAndWait {
   
            do {
                try self.controller.performFetch()
                let savedMovies = try managedContext.fetch(fetchRequest) as? [FavMovie]
                completion(.success(savedMovies ?? []))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func save(movie: MovieToCoreData) {
        controller.managedObjectContext.performAndWait {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "FavMovie",in: managedContext)!
            let favMovie = FavMovie(entity: entity, insertInto: managedContext)
                 
            favMovie.id = movie.id
            favMovie.movieName = movie.movieName
            favMovie.movieYear = movie.movieYear
            favMovie.posterPath = movie.posterPath
            favMovie.movieDescription = movie.movieDescription
            favMovie.movieGenre = movie.movieGenre
            
            self.controller.managedObjectContext.insert(favMovie)
            try? self.controller.managedObjectContext.save()
        }
    }
    
    func delete(movie: FavMovie) {
        
        controller.managedObjectContext.performAndWait {
            self.controller.managedObjectContext.delete(movie)
            try? self.controller.managedObjectContext.save()
        }
    }
    
}


