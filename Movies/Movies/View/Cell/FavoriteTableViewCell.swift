//
//  FavoriteTableViewCell.swift
//  Movies
//
//  Created by Murilo Ribeiro de Oliveira on 01/11/22.
//
import UIKit

class FavoriteTableViewCell: UITableViewCell {

    
    @IBOutlet weak var favoritePosterImageView: UIImageView!
    @IBOutlet weak var favoriteMovieNameLabel: UILabel!
    @IBOutlet weak var favoriteMovieYearLabel: UILabel!
    @IBOutlet weak var favoriteMovieDescTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    
    
}
