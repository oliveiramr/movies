//
//  MovieCollectionViewCell.swift
//  Movies
//
//  Created by Murilo Ribeiro de Oliveira on 01/11/22.
//
import UIKit
protocol MovieCollectionViewCellDelegate {
    func isFavoritedButtonTouched(indexPath: Int)
}


class MovieCollectionViewCell: UICollectionViewCell {
   
    
    var cellDelegate: MovieCollectionViewCellDelegate?
       
    @IBOutlet weak var posterMovieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var isFavoriteButtonOutlet: UIButton!
    @IBAction func isFavoriteButtonAction(_ sender: UIButton) {
       
        cellDelegate?.isFavoritedButtonTouched(indexPath: sender.tag)
       
    }

   
 
}
