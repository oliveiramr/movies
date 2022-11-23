//
//  FavoritesViewModel.swift
//  Movies
//
//  Created by Murilo Ribeiro de Oliveira on 01/11/22.
//

import UIKit


protocol FavoritesViewModelDelegate : AnyObject {
    func searchIsEmpty()
    func finishedFiltering()
}


class FavoritesViewModel {
    
    private let service = Service()
    private var coreData = CoreData()
    weak var delegate : FavoritesViewModelDelegate?
    var favoritesMovies : [FavMovie] = []
    

    
    func fetchFavorites(){
        coreData.requestFavorites { (favorites: Result<[FavMovie], Error>) in
            switch favorites {
            case .success(let favorites):
                self.favoritesMovies = favorites
            case .failure(let failure):
                print(failure)
                
            }
        }
    }
    
    
    func deleteFavorite(movie: FavMovie) {coreData.delete(movie: movie)}
    
    
    func requestImageFrom(path: String) -> UIImage {
        guard let urlImage = URL(string: "https://image.tmdb.org/t/p/w200\(path)") else { return UIImage()}
        guard let data = try? Data(contentsOf: urlImage) else { return UIImage() }
        let image = UIImage(data: data)!
        return image
    }
    
    
    func searchMovies(from movies: [FavMovie], searchText: String) {
        let filtered = movies.filter { item in item.movieName.lowercased().contains(searchText.lowercased()) }
        
        if filtered.isEmpty {
            delegate?.searchIsEmpty()
            return
        }
        favoritesMovies = filtered
        delegate?.finishedFiltering()
    }
    
}
