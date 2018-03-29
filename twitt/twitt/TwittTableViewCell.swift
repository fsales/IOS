//
//  TwittTableViewCell.swift
//  twitt
//
//  Created by Fábio Sales on 15/08/17.
//  Copyright © 2017 Fábio Sales. All rights reserved.
//

import UIKit
import Twitter

class TwittTableViewCell: UITableViewCell {

    @IBOutlet weak var imagemView: UIImageView!
    
    @IBOutlet weak var tituloTwitterLabel: UILabel!
    
    @IBOutlet weak var conteudoTwitterLabel: UILabel!
    
    @IBOutlet weak var usuarioTwitterLabel: UILabel!
    
    var tweet: Twitter.Tweet?{
        didSet{
            updateView()
        }
    }
    
    private func updateView(){
        setTitulo(titulo: tweet?.user.description)
        setConteudo(conteudo: tweet?.text)
        
        if let profileImageURL = tweet?.user.profileImageURL {
            if let imageData = try? Data(contentsOf: profileImageURL) {
                imagemView?.image = UIImage(data: imageData)
            }
        }else {
            imagemView?.image = nil
        }
       
        if let createdAt = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(createdAt) > 24*60*60 {
                formatter.dateStyle = .short
            }else {
                formatter.timeStyle = .short
            }
            usuarioTwitterLabel?.text = formatter.string(from: createdAt)
        }else {
            usuarioTwitterLabel?.text = nil
        }
    }
    
    private func setTitulo(titulo: String!){
        tituloTwitterLabel?.text = titulo
    }
    
    private func setConteudo(conteudo: String!){
        conteudoTwitterLabel?.text = conteudo
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
