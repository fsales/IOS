//
//  DetalharTwitterTableViewController.swift
//  twitt
//
//  Created by Fábio Sales on 23/08/17.
//  Copyright © 2017 Fábio Sales. All rights reserved.
//

import UIKit
import Twitter
class DetalharTwitterTableViewController: UITableViewController {
    
    private struct DefinicaoSeccao {
        var tipo: String
        var itensSeccao: [SeccaoItem]
    }
    
    private enum SeccaoItem {     
        case texto(String)
        case imagem(URL, Double)
        
    }
    
    private var seccoes = [DefinicaoSeccao]()
    
    var tweet: Twitter.Tweet?{
        didSet{
            updateView()
        }
    }
    
    private func updateView(){
        title = tweet?.user.screenName
        
        if let t = tweet{
            print(t.created)
            seccoes = configurarSeccao(t)
        }
        
        tableView.reloadData()
    }
    
    private func configurarSeccao(_ tweet: Twitter.Tweet) -> [DefinicaoSeccao]{
        var seccaoesTemp = [DefinicaoSeccao]()
        
        if (tweet.media.count > 0){
            seccaoesTemp.append(DefinicaoSeccao(tipo: "Imagens", itensSeccao: tweet.media.map{ SeccaoItem.imagem($0.url, $0.aspectRatio)}))
        }
        
        
        if (tweet.urls.count > 0){
            seccaoesTemp.append(DefinicaoSeccao(tipo: "URLs", itensSeccao: tweet.urls.map{ SeccaoItem.texto($0.keyword)}))
        }
        
        if (tweet.hashtags.count > 0){
            seccaoesTemp.append(DefinicaoSeccao(tipo: "Hashtags", itensSeccao: tweet.hashtags.map{ SeccaoItem.texto($0.keyword)}))
        }
        
        var dadosUsuario = [SeccaoItem]()
        
        dadosUsuario += [SeccaoItem.texto("@" + tweet.user.screenName)]
        
        if(tweet.userMentions.count > 0){
            dadosUsuario += tweet.userMentions.map{SeccaoItem.texto($0.keyword)}
        }
        
        if (dadosUsuario.count > 0){
            seccaoesTemp.append(DefinicaoSeccao(tipo: "Usuários", itensSeccao: dadosUsuario))
        }
        
        
        return seccaoesTemp
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return seccoes.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return seccoes[section].itensSeccao.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     //

        let seccaoTemp = seccoes[indexPath.section].itensSeccao[indexPath.row]
        
        switch seccaoTemp {
            case .texto(let texto):
                let cell = tableView.dequeueReusableCell(withIdentifier: "texto_cell_detalhar", for: indexPath)
                cell.textLabel?.text = texto
                return cell
            case .imagem(let url, _):
                let cell = tableView.dequeueReusableCell(withIdentifier: "imagem_cell_detalhar", for: indexPath)
                if let imageCell = cell as? ImagemTwittTableViewCell {
                    imageCell.imagemURL = url
                }
                return cell
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let seccaoTemp = seccoes[indexPath.section].itensSeccao[indexPath.row]
        switch seccaoTemp {
        case .imagem(_, let ratio):
            return tableView.bounds.size.width / CGFloat(ratio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return seccoes[section].tipo
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if let identifier = segue.identifier {
            
            if identifier == "pesquisaTagMencao" {
                
                if let ttvc = segue.destination as? PequisarTwittTableViewController,
                    let cell = sender as? UITableViewCell,
                    var texto = cell.textLabel?.text {
                    if texto.hasPrefix("@") {
                        texto += " OR from:" + texto
                    }
                    
                    
                    ttvc.searchText = texto
                    
                }
                
            }
        }
    }
}
