//
//  MoviesGridViewModel.swift
//  Movies
//
//  Created by Murilo Ribeiro de Oliveira on 01/11/22.
//

import UIKit

protocol MoviesGridViewModelDelegate : AnyObject {
    func didGetMovieList()
    func searchIsEmpty()
    func finishedFiltering()
}

class MoviesGridViewModel {
    
    private  let service = Service()
    private let coreData = CoreData()
    weak var delegate : MoviesGridViewModelDelegate?
    var listMovie : [Movie] = []
    var movieImages : [UIImage] = []
    var favorites : [FavMovie] = []
    

    func buttonHeartTappedAt(movieIndex: Int){
       let toFavorite = listMovie[movieIndex]
        if checkFavorite(movieName: toFavorite.originalTitle){
          let favMovie = favorites.filter { item in item.movieName.contains(toFavorite.originalTitle) }
            deleteFavorite(movie: favMovie[0])
            fetchCoreData()
    
        }else{
            saveFavorite(movie: toFavorite)
            fetchCoreData()
        }
    }
    

    func checkFavorite(movieName: String) -> Bool{return favorites.contains(where: {$0.movieName == movieName})}
    
    func deleteFavorite(movie: FavMovie) {coreData.delete(movie: movie)}
    
    func saveFavorite(movie: Movie){
        
        let convertDate = movie.releaseDate
        let year = String(convertDate.prefix(4))
        let favoriteMovie: MovieToCoreData = MovieToCoreData(
            id: String(movie.id),
            movieName: movie.originalTitle,
            movieYear: year,
            posterPath: movie.posterPath,
            movieDescription: movie.overview,
            movieGenre: String(movie.genreIDS[0]))
        
        coreData.save(movie: favoriteMovie)
    }
    
    func getMovieList(){
        service.getPopularMovies { (movies: Result<SetMovie, NetworkError>) in
            switch movies {
            case.success(let movies):
                self.listMovie = movies.results
               
                for i in self.listMovie {
               
                    self.requestImageFrom(path: i.posterPath)
                
                }
                               
                self.delegate?.didGetMovieList()
            case.failure(let error):
                print(error)
            }
        }
    }
    
    func fetchCoreData(){
        coreData.requestFavorites { (favoritesMoviesCoreData:Result<[FavMovie], Error>) in
            switch favoritesMoviesCoreData {
            case.success(let favoritesMoviesCoreData):
                self.favorites = favoritesMoviesCoreData
            case.failure(let error):
                print(error)
            }
        }
    }
    
    func requestImageFrom(path: String) {
        guard let urlImage = URL(string: "https://image.tmdb.org/t/p/w200\(path)") else { return }
        guard let data = try? Data(contentsOf: urlImage) else { return }
        let image = UIImage(data: data)!
        
        movieImages.append(image)
        
    }
    
    func searchMovies(from movies: [Movie], searchText: String) {
        let filtered = movies.filter { item in item.originalTitle.lowercased().contains(searchText.lowercased()) }
        
        if filtered.isEmpty {
            delegate?.searchIsEmpty()
            return
        }
        listMovie = filtered
        delegate?.finishedFiltering()
    }
        
}
