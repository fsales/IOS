//
//  EscolasViewController.swift
//  E-Escola
//
//  Created by Fábio Sales on 19/12/2017.
//  Copyright © 2017 Fábio Sales. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class EscolasTableViewController: UITableViewController {
    
    private var localizacao:LocalizacaoDispositivoService?
    private var escola: EscolaService = EscolaService.shared()
    
    private var persistentContainer = AppDelegate.persistentContainer

    
    private lazy var fetchRequest: NSFetchRequest<Escola> = {
        let request: NSFetchRequest<Escola> = Escola.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "nome", ascending: true)]
        return request
    }()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Escola> = { [unowned self] in
        let frc = NSFetchedResultsController(fetchRequest: self.fetchRequest,
                                             managedObjectContext: self.persistentContainer.viewContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
         NotificationCenter.default.addObserver(self, selector: #selector(onEscalasCoreData(_:)), name: Notification.Name.EscolaFetched, object: nil)
        DispatchQueue.global(qos: .background).sync {
            
            self.localizacao = LocalizacaoDispositivoService.shared()
            self.localizacao?.delegate = self
            self.escola.delegate = self
            self.localizacao?.iniciaAtualizarLocalizacao()
            self.localizacao?.location()
            
        }
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc private func onEscalasCoreData(_ notification: Notification) {
        DispatchQueue.main.sync { [unowned self] in
            do {
                try self.fetchedResultsController.performFetch()
                self.tableView.reloadData()
            }catch {
                self.alert(withTitle: "Erro ao realizar Fetch", message: error.localizedDescription)
                print("Erro ao realizar fetch:")
                debugPrint(error)
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        }else {
            return 0
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return fetchedResultsController.sectionIndexTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return fetchedResultsController.section(forSectionIndexTitle: title, at: index)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EscolasTableViewController.NOME_CELL, for: indexPath)

        let escola = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = escola.nome
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = escola.endereco?.bairro
        cell.detailTextLabel?.numberOfLines = 0

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let escola = fetchedResultsController.object(at: indexPath)
        performSegue(withIdentifier: EscolasTableViewController.ESCOLA_SEGUE, sender: escola)
    }
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == EscolasTableViewController.ESCOLA_SEGUE {
            if let destination = segue.destination  as? DetalharEscolaViewController, let escola = sender as? Escola{
                destination.escola = escola
            }
        }
    }
    

}

extension EscolasTableViewController: LocalizacaoDispositivo, EscolaDelegate{
    func resultadoEscolaCoreData(_ escolas: [Escola]?, error: Error?) {
        
        if let err = error{
            ProgressView.hide()
            self.genericErrorAlert(err)
            return
        }
        
        //marcarEscolasMapa(escolas)
    }
    
    func localizacaAtual(localizacaoAtual localizacaoDispositivo: CLLocation, _ error: Error?) {
        
        if let err = error{
            ProgressView.hide()
            self.genericErrorAlert(err)
            return
        }
        ProgressView.show()
        //marcarLocalizacaoAtual()
        print(localizacaoDispositivo)
        self.escola.buscarEscolas(localizacaoDispositivo.coordinate)
    }
}


extension EscolasTableViewController: NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            tableView.insertSections([sectionIndex], with: .bottom)
        case .delete:
            tableView.deleteSections([sectionIndex], with: .bottom)
        case .update:
            tableView.reloadSections([sectionIndex], with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .left)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .left)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .middle)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

extension EscolasTableViewController {
    public static let ESCOLA_SEGUE: String = "detalharEscola"
    
    public static let NOME_CELL: String = "defaultCell"
}




