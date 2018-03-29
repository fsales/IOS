//
//  DetalharTwittTableViewCell.swift
//  twitt
//
//  Created by Fábio Sales on 07/09/17.
//  Copyright © 2017 Fábio Sales. All rights reserved.
//

import UIKit

class ImagemTwittTableViewCell: UITableViewCell {

     @IBOutlet weak var tweetImagem: UIImageView!
    var imagemURL: URL?{
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        if let url = imagemURL{
            DispatchQueue.global(qos: .userInitiated).async {
                
                let contentsOfURL = try? Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    if url == self.imagemURL {
                        if let imageData = contentsOfURL {
                            self.tweetImagem?.image = UIImage(data: imageData)
                        }
                        
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
