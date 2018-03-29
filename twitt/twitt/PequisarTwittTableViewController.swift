//
//  PequisarTwittTableViewController.swift
//  twitt
//
//  Created by Fábio Sales on 15/08/17.
//  Copyright © 2017 Fábio Sales. All rights reserved.
//

import UIKit
import Twitter

class PequisarTwittTableViewController: UITableViewController, UITextFieldDelegate {
    
    private var tweet = [Array<Twitter.Tweet>]()
    
    var searchText: String? {
        didSet {
            searchForTweets()
            title = searchText
        }
    }


    @IBOutlet weak var pesquisaTextField: UITextField!{
        didSet{
            pesquisaTextField.delegate = self
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == pesquisaTextField {
            searchText = textField.text
            textField.resignFirstResponder()
            tweet.removeAll()
            tableView.reloadData()
        }
        return true
    }
    
    private func searchForTweets() {
        if let text = searchText, !text.isEmpty {
            let request = Twitter.Request(search: text, count: 100)
            request.fetchTweets { [weak self] newTweets in
                DispatchQueue.main.async {
                    self?.tweet.insert(newTweets, at: 0)
                    self?.tableView.insertSections([0], with: .fade)
                }
            }
        }
    }
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchText = "Timeline"
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension

    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweet.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweet[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "minhaCelulaTweet", for: indexPath)
        
        let twitter = tweet[indexPath.section][indexPath.row]
        
        if let celula = cell as? TwittTableViewCell {
            celula.tweet = twitter
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identificador = segue.identifier{
            if identificador == SegueTelaEnum.TELA_TWITTER.rawValue{
                if let detalhar = segue.destination as? DetalharTwitterTableViewController,
                    let cell = sender as? TwittTableViewCell{
                    
                    detalhar.tweet = cell.tweet
                }
            }
        }
    }
    
    
    enum SegueTelaEnum : String{
        case TELA_TWITTER = "tela_twitter"
    }
    
}
