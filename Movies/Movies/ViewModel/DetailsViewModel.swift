//
//  DetailsViewModel.swift
//  Movies
//
//  Created by Murilo Ribeiro de Oliveira on 01/11/22.
//
import UIKit

protocol DetailsViewModelDelegate: AnyObject{
    func didGetGenres(genres : [Genre])
}

class DetailsViewModel {
    
    private let service = Service()
    private let coreData = CoreData()
    weak var delegate : DetailsViewModelDelegate?
    var genre: [Genre]?
    var favoritesMovies : [FavMovie] = []
    var movie: Movie?
    
    var isFavorite: Bool {favoritesMovies.contains(where: { $0.movieName == movie?.originalTitle ?? String()})}

    func deleteFavorite(movie: Movie) {
        if let movieToDelete = favoritesMovies.first(where: { $0.id == String(movie.id) }) {

            coreData.delete(movie: movieToDelete)
        }
    }
    
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

    func fetchFavorites(){
        coreData.requestFavorites { (favoritesMoviesCoreData:Result<[FavMovie], Error>) in
            switch favoritesMoviesCoreData {
            case.success(let favoritesMoviesCoreData):
                self.favoritesMovies = favoritesMoviesCoreData
            case.failure(let error):
                print(error)
            }
        }
    }
    
    func getGenreMovie(){
        service.getGenreMovie { (genre: Result<SetGenre, NetworkError>) in
            switch genre {
            case.success(let genre):
                self.delegate?.didGetGenres(genres: genre.genres)
            case.failure(let error):
                print(error)
            }
        }
    }
    
    
    
    func requestImageFrom(path: String) -> UIImage {
        guard let urlImage = URL(string: "https://image.tmdb.org/t/p/w200\(path)") else { return UIImage()}
        guard let data = try? Data(contentsOf: urlImage) else { return UIImage() }
        let image = UIImage(data: data)!
        return image
    }
    

    func getMovieYearFrom(fullDate: String) -> String {
        let convertDate = fullDate
        let year = String(convertDate.prefix(4))
        return year
    }
}
