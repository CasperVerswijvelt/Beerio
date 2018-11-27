//
//  BeerDetailsTableViewController.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 23/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import UIKit
import Toast_Swift

class BeerDetailsTableViewController: LoaderTableViewController {
    //Outlets
    var addButton : UIBarButtonItem!
    var addNoteButton : UIBarButtonItem!
    var alreadySavedButton : UIBarButtonItem!
    var editButton : UIBarButtonItem!
    
    //Vars
    var beer : Beer? {
        didSet {
            if let beer = beer {
                if isLocal {
                    beer.fetchAndSaveImageIfNotAlreadySaved()
                }
                self.navigationItem.title = beer.name
                beerDetails = beer.tableLayout
                tableView.reloadData()
            }
        }
    }
    var isLocal : Bool = false 
    var beerDetails : [BeerSectionInfo] = [] {
        didSet {
            self.editButtonItem.isEnabled = getNotesSectionIndex() != nil
        }
    }
    @IBOutlet weak var dataCourtesy: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialising BarButtonItems
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        addNoteButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addNoteTapped))
        alreadySavedButton = UIBarButtonItem(image: UIImage(named: "checkmarkBarButtonItem.pdf"), style: .plain, target: self, action: #selector(alreadySavedTapped))
        editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        
        
        dataCourtesy.isHidden = beer?.isSelfMade ?? true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        updateBarButtonItems()
    }
    
    //Data source methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return beerDetails.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerDetails[section].cells.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let beerCellInfo = beerDetails[indexPath.section].cells[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: beerCellInfo.cellType.rawValue, for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = beerCellInfo.key
        cell.detailTextLabel?.text = beerCellInfo.value
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let beerSectionInfo = beerDetails[section]
        return beerSectionInfo.header
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if beerDetails.count > 0 && beerDetails[beerDetails.count-1].isNotes && beerDetails[beerDetails.count-1].cells.count > 0 && indexPath.section == beerDetails.count-1  {
            return true
        }
        return false
    }
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete) {
            guard let notesSectionIndex = getNotesSectionIndex() else {return}
            let notesSection = beerDetails[notesSectionIndex]
            
            
            if notesSection.cells.count > 0 && indexPath.section == notesSectionIndex  {
                if let beer = beer {
                    RealmController.singleton.removeNoteFromBeer(beer:beer,index:indexPath.row) {error in
                        if let error = error {
                            Toaster.makeErrorToast(view: self.navigationController?.view, text: "Note could not be removed: '\(error.localizedDescription)'")
                        } else {
                            self.tableView.beginUpdates()
                            self.beerDetails = beer.tableLayout
                            //Explanation for using async here:
                            // If we don't do it async, the delete animation is ugly
                            DispatchQueue.main.async {
                                if self.getNotesSectionIndex() == nil {
                                    self.tableView.deleteSections(IndexSet(arrayLiteral:
                                        notesSectionIndex), with: .fade)
                                    //Setting editing mode false, since the 'done' button can no longer be tapped (disabled now)
                                    self.isEditing = false
                                } else {
                                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                                }
                                self.tableView.endUpdates()
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLabel", let destination = segue.destination as? ImageViewController, let _ = tableView.indexPathForSelectedRow {
            
            destination.beer = self.beer!
        } else if segue.identifier == "editExistingBeer", let destination = (segue.destination as? UINavigationController)?.viewControllers.first as? EditBeerTableViewController, let beer = beer {
            destination.editBeer = beer
        }
    }
    
    @objc func addTapped() {
        let alert = UIAlertController(title: "Add to 'My Beers'", message: "Are you sure you want to add \(beer!.name) to your personal beer library?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default) { alert in
            if let beer = self.beer {
                beer.fetchAndSaveImageIfNotAlreadySaved()
                RealmController.singleton.addBeer(beer: beer, shouldUpdateTable: true) {
                    error in
                    
                    if let error = error {
                        Toaster.makeErrorToast(view: self.navigationController?.view, text: "Beer could not be added: '\(error.localizedDescription)'")
                    } else {
                        //There were no errors
                        Toaster.makeSuccesToast(view: self.navigationController?.view, text: "Beer succesfully added to your library")
                        self.updateBarButtonItems()
                    }
                    
                }
            }
        })
        self.present(alert, animated: true)
        
    }
    @objc func addNoteTapped() {
        let alert = UIAlertController(title: "Add a note to this beer", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "e.g. 'This one made me puke'"
        }
        
        alert.addAction(UIAlertAction(title: "Save", style: .default){ action -> Void in
            let noteTextfield = alert.textFields![0] as UITextField
            if let beer = self.beer, let noteText = noteTextfield.text {
                RealmController.singleton.addNoteToBeer(beer: beer, text: noteText) {error in
                    if let error = error {
                        Toaster.makeErrorToast(view: self.navigationController?.view, text: "Note could not be added: '\(error.localizedDescription)'")
                    } else {
                        Toaster.makeSuccesToast(view: self.navigationController?.view, text: "Note added!")
                        
                        self.tableView.beginUpdates()
                        let notesSectionIndex = self.getNotesSectionIndex()
                        self.beerDetails = beer.tableLayout
                        
                        //Determininging where we should insert a section
                        if notesSectionIndex == nil, let newNotesSectionIndex = self.getNotesSectionIndex() {
                            self.tableView.insertSections(IndexSet(arrayLiteral: newNotesSectionIndex), with: .automatic)
                            //If we don't do this async it would give us an out of range error
                            DispatchQueue.main.async {
                                self.tableView.scrollToRow(at: IndexPath(row: 0, section: newNotesSectionIndex), at: .bottom, animated: true)
                            }
                            
                        } else {
                            //We don't need to insert a new section, insert individual rows
                            let rowIndex = self.beerDetails[notesSectionIndex!].cells.count-1
                            let indexPath = IndexPath(row: rowIndex, section: notesSectionIndex!)
                            
                            self.tableView.insertRows(at: [indexPath], with: .automatic)
                            
                            //If we don't do this async it would give us an out of range error
                            DispatchQueue.main.async {
                                self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top , animated: true)
                            }
                            
                        }
                        self.tableView.endUpdates()
                    }
                }
            }
            
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
    @objc func alreadySavedTapped(){
        //doesn't do anything lmao
    }
    
    @objc func editTapped(){
        self.performSegue(withIdentifier: "editExistingBeer", sender: self);
    }
    
    func getNotesSectionIndex() -> Int? {
        if let notesSectionIndex = beerDetails.firstIndex(where: {$0.isNotes}) {
            return notesSectionIndex
        }
        return nil
    }
    
    func updateBarButtonItems() {
        var items : [UIBarButtonItem] = []
        
        if isLocal {
            if((beer?.isSelfMade)!) {
                items.append(editButton)
            }
            items.append(addNoteButton)
        } else {
            if let beer = beer, RealmController.singleton.hasBeerAlreadySaved(beer: beer) {
                items.append(alreadySavedButton)
            } else {
                items.append(addButton)
            }
        }
        self.navigationItem.rightBarButtonItems = items
    }
    
    @IBAction func unwindToBeerDetailScreen(segue : UIStoryboardSegue) {
        if let beer = beer {
            beerDetails = beer.tableLayout
            tableView.reloadData()
        }
    }
    
    
    
    
    
}
