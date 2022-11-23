//
//  FavoritesViewController.swift
//  Movies
//
//  Created by Murilo Ribeiro de Oliveira on 01/11/22.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var favoriteTableView: UITableView!
    @IBOutlet weak var favoriteSearchBar: UISearchBar!
    
    var viewModel = FavoritesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        viewModel.delegate = self
        favoriteSearchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getNewData()
        checkIfFavsIsEmpty()
    }
    
    private func getNewData() {
        viewModel.fetchFavorites()
        favoriteTableView.reloadData()
    }
    
    private func checkIfFavsIsEmpty(){
        if viewModel.favoritesMovies.isEmpty{
            getAlert(title: "No Movies here🎞", message: "💛 Save movies to show 💛 ")
        }
    }
}

extension FavoritesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoritesMovies.count
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoriteTableView.dequeueReusableCell(withIdentifier: "CellFavorite", for: indexPath) as? FavoriteTableViewCell
        cell?.favoriteMovieNameLabel.text = viewModel.favoritesMovies[indexPath.row].movieName
        cell?.favoriteMovieYearLabel.text = viewModel.favoritesMovies[indexPath.row].movieYear
        cell?.favoriteMovieDescTextView.text = viewModel.favoritesMovies[indexPath.row].movieDescription
        cell?.favoritePosterImageView.image = viewModel.requestImageFrom(path: viewModel.favoritesMovies[indexPath.row].posterPath)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteFavorite(movie: viewModel.favoritesMovies[indexPath.row])
            viewModel.favoritesMovies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            checkIfFavsIsEmpty()
        }
    }
}

extension FavoritesViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchMovie = favoriteSearchBar.text, !searchMovie.isEmpty {
            viewModel.searchMovies(from: viewModel.favoritesMovies, searchText: searchText)
        } else {
            viewModel.fetchFavorites()
            favoriteTableView.reloadData()
        }
    }
    
    private func getAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension FavoritesViewController : FavoritesViewModelDelegate {
    func finishedFiltering() {
        favoriteTableView.reloadData()
    }
    
    func searchIsEmpty() {
        getAlert(title: "Movie not Found 🎞", message: "You don't have any favorite movie with this specifications")
        favoriteSearchBar.text = ""
        viewModel.fetchFavorites()
        favoriteTableView.reloadData()
    }
    
}

