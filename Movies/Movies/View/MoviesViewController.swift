//
//  MoviesViewController.swift
//  Movies
//
//  Created by Murilo Ribeiro de Oliveira on 01/11/22.
//

import UIKit


class MoviesViewController: UIViewController {
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var loadingGridActivityIndicator: UIActivityIndicatorView!
    
    let viewModel = MoviesGridViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieSearchBar.delegate = self
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getMovieList()
        viewModel.fetchCoreData()
        movieCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "goToDetailsSegue" else {return}
        guard let MovieDetailViewController = segue.destination as? DetailsViewController else {return}
        MovieDetailViewController.viewModel.movie = sender as? Movie
    }
}


extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.listMovie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        cell.cellDelegate = self
        cell.isFavoriteButtonOutlet.tag = indexPath.row
        cell.movieNameLabel.text = viewModel.listMovie[indexPath.row].originalTitle
        cell.posterMovieImageView.image = viewModel.movieImages[indexPath.row]

        if viewModel.checkFavorite(movieName: viewModel.listMovie[indexPath.row].originalTitle){
            cell.isFavoriteButtonOutlet.setImage(UIImage(named: "favorite_full_icon"), for: .normal)
        } else {
            cell.isFavoriteButtonOutlet.setImage(UIImage(named: "favorite_empty_icon"), for: .normal)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = viewModel.listMovie[indexPath.row]
        performSegue(withIdentifier: "goToDetailsSegue", sender: selectedMovie)
        
    }
}


extension MoviesViewController : MoviesGridViewModelDelegate {
    func finishedFiltering() {
        movieCollectionView.reloadData()
    }
    
    func searchIsEmpty() {
        getAlert(title: "Movie not Found 🎞", message: "We don't have any popular movies with your specifications")
        movieSearchBar.text = ""
        viewModel.getMovieList()
        movieCollectionView.reloadData()
        
    }
    func didGetMovieList() {
        movieCollectionView.reloadData()
        loadingGridActivityIndicator.isHidden = true
    }
}


extension MoviesViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchMovie = movieSearchBar.text, !searchMovie.isEmpty {
            viewModel.searchMovies(from: viewModel.listMovie, searchText: searchText)
        } else {
            viewModel.getMovieList()
            movieCollectionView.reloadData()
        }
    }
    
    private func getAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
        
    }
}


extension MoviesViewController : MovieCollectionViewCellDelegate{
    func isFavoritedButtonTouched(indexPath: Int) {
        viewModel.buttonHeartTappedAt(movieIndex: indexPath)
        movieCollectionView.reloadData()
    }
}
