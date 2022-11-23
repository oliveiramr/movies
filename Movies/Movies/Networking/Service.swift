//
//  Service.swift
//  Movies
//
//  Created by Murilo Ribeiro de Oliveira on 01/11/22.
//

import Foundation


protocol Networkable {
    func getPopularMovies(completion: @escaping ((Result<SetMovie, NetworkError>) -> Void))
    func getGenreMovie(completion: @escaping ((Result<SetGenre, NetworkError>) -> Void))

}



class Service: Networkable {

    private let baseURL = "https://api.themoviedb.org/3/movie/popular?api_key=fac7bcf7b467651b16fb9d8b092c85ea&language=en-US&page=1"
  
    
    func getPopularMovies(completion: @escaping ((Result<SetMovie, NetworkError>) -> Void)) {
        
        guard let url = URL(string: baseURL) else {
            completion(.failure(.wrongURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            
            DispatchQueue.main.async {
                
                if error != nil {
                    completion(.failure(.generic))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.generic))
                    return
                }
                guard let json = try? JSONDecoder().decode(SetMovie.self, from: data) else {
                    completion(.failure(.wrongModel))
                    return
                }
                completion(.success(json))
            }
            
        })
        task.resume()
    }
        

    private let baseURLGenre = "https://api.themoviedb.org/3/genre/movie/list?api_key=fac7bcf7b467651b16fb9d8b092c85ea&language=en-US"
    
    func getGenreMovie(completion: @escaping ((Result<SetGenre, NetworkError>) -> Void)) {
        guard let url = URL(string: baseURLGenre) else {
            completion(.failure(.wrongURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            
            DispatchQueue.main.async {
                
                if error != nil {
                    completion(.failure(.generic))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.generic))
                    return
                }
                
                
                guard let genres = try? JSONDecoder().decode(SetGenre.self, from: data) else {
                    
                    completion(.failure(.wrongModel))
                    
                    return
                }
                
                completion(.success(genres))

            }
            
        })
        task.resume()
    }
        
}
       
