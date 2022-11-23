//
//  DetailsViewController.swift
//  Movies
//
//  Created by Murilo Ribeiro de Oliveira on 01/11/22.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var moviePosterImageView: UIImageView!
    
    @IBOutlet weak var movieNameLabel: UILabel!
    
    @IBOutlet weak var movieYearLabel: UILabel!
    
    @IBOutlet weak var movieGenreLabel: UILabel!
    
    @IBOutlet weak var isFavoriteButtonOutlet: UIButton!
    
    @IBOutlet weak var movieDescriptionTextView: UITextView!

    var viewModel = DetailsViewModel()
   
 
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.fetchFavorites()
        showDetails()
        viewModel.getGenreMovie()
        changeStatusHeart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        changeStatusHeart()
    }
    
    @IBAction func favoriteMovieButtonAction(_ sender: Any) {
        guard let favMovie = viewModel.movie else {return}
        
        if viewModel.isFavorite{
            viewModel.deleteFavorite(movie: favMovie)
            viewModel.fetchFavorites()
            changeStatusHeart()
        } else {
            viewModel.saveFavorite(movie: favMovie)
            viewModel.fetchFavorites()
            changeStatusHeart()
        }
        
    }
    
    private func changeStatusHeart(){
        if viewModel.isFavorite{
            isFavoriteButtonOutlet.setImage(UIImage(named: "favorite_full_icon"), for: .normal)
        } else {
            isFavoriteButtonOutlet.setImage(UIImage(named: "favorite_empty_icon"), for: .normal)
        }
    }
        
    
    private func showDetails(){
        
        moviePosterImageView.image = viewModel.requestImageFrom(path: viewModel.movie?.posterPath ?? "")
        movieNameLabel.text = viewModel.movie?.originalTitle
        movieYearLabel.text = viewModel.getMovieYearFrom(fullDate: viewModel.movie?.releaseDate ?? "")
        movieDescriptionTextView.text = viewModel.movie?.overview
    }
}


extension DetailsViewController: DetailsViewModelDelegate {
    
    func didGetGenres(genres: [Genre]) {
        for genre in genres {
            if viewModel.movie?.genreIDS.contains(genre.id) == true {
                movieGenreLabel.text = "\(movieGenreLabel.text! + genre.name) "
            }
        }
    }
    
    
}


