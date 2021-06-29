//
//  TopChartCollectionViewCell.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/29/21.
//

import UIKit

class TopChartCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var albumCoverImageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func setupCell(forAlbum album: Album) {
        topLabel.text = album.name
        topLabel.textColor = .white
        topLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        bottomLabel.text = album.artist?.name
        bottomLabel.textColor = .white
        bottomLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        if let placeholderImage = UIImage(named: "albumCoverDefault") {
            albumCoverImageView.image = placeholderImage
        }
        
        // I thought about using this, but was not really sure about it in therms of architecture
        /*if let albumCoverAddress = album.image?.last?.text, let albumURL = URL(string: albumCoverAddress) {
            albumCoverImageView.af_setImage(withURL: albumURL, placeholderImage: UIImage(named: "albumCoverDefault"))
        }*/
        activityIndicator.startAnimating()
        contentView.bringSubviewToFront(activityIndicator)
    }
    
    func setupCover(image: UIImage) {
        albumCoverImageView.image = image
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
    }
    
}
