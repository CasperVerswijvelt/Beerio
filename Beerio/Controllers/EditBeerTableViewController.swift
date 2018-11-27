//
//  AddNewBeerTableViewController.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 26/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import UIKit
import PopupDialog

class EditBeerTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var originalGravityTextField: UITextField!
    @IBOutlet weak var alcoholByVolumeTextField: UITextField!
    @IBOutlet weak var internationalBitteringUnitTextField: UITextField!
    @IBOutlet weak var servingTemperatureTextField: UITextField!
    @IBOutlet weak var foodPairingsTextView: UITextView!
    @IBOutlet weak var isRetiredSwitch: UISwitch!
    @IBOutlet weak var isOrganicSwitch: UISwitch!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var yearPicker: UIPickerView!
    @IBOutlet weak var bottleLabelCell: UITableViewCell!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var currentPickedImage : UIImage?
    
    var years: [Int] = []
    var yearPickerCollapsed : Bool = false {
        didSet {
            yearPicker.isHidden = !yearPickerCollapsed
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    var editBeer : Beer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for year in 1500...Calendar.current.component(Calendar.Component.year, from: Date()) {
            years.append(year)
        }
        years.reverse()
        yearPicker.delegate = self
        yearPicker.dataSource = self
        
        nameTextField.addTarget(self, action: #selector(nameChanged), for: .editingChanged)
        
        updateYearLabel()
        
        if let beer = editBeer {
            self.nameTextField.text = beer.name
            self.descriptionTextView.text = beer.beerDescription
            self.originalGravityTextField.text = beer.originalGravity
            self.alcoholByVolumeTextField.text = beer.alcoholByVolume
            self.internationalBitteringUnitTextField.text = beer.internationalBitteringUnit
            self.servingTemperatureTextField.text = beer.servingTemperature
            self.foodPairingsTextView.text = beer.foodPairings
            self.isRetiredSwitch.isOn = beer.isRetiredRealm.value ?? false
            self.isOrganicSwitch.isOn = beer.isOrganicRealm.value ?? false
            self.yearPicker.selectRow(years.firstIndex(of: beer.year ?? 2018) ?? 0, inComponent: 0, animated: false)
            self.currentPickedImage = DocumentsDirectoryController.singleton.getImage(fileName: beer.id)
            nameChanged()
            updateLabelPickerCell()
            updateYearLabel()
        }
        
        self.navigationItem.title = editBeer == nil ? "Add new beer" : "Edit beer"
        
    }
    
    //Picker methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(years[row])
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        let section = indexPath.section
        //print("section: \(section), row: \(row)")
        switch(section,row){
            
        case (0, 0):
            self.nameTextField.becomeFirstResponder()
        case (0, 1):
            self.descriptionTextView.becomeFirstResponder()
        case (0, 2):
            self.descriptionTextView.becomeFirstResponder()
        case (1, 0):
            self.originalGravityTextField.becomeFirstResponder()
        case (1, 1):
            self.alcoholByVolumeTextField.becomeFirstResponder()
        case (1, 2):
            self.internationalBitteringUnitTextField.becomeFirstResponder()
        case (1, 3):
            self.servingTemperatureTextField.becomeFirstResponder()
        case (2, 0):
            self.foodPairingsTextView.becomeFirstResponder()
        case (2, 1):
            self.foodPairingsTextView.becomeFirstResponder()
        case (2, 2):
            self.isRetiredSwitch.becomeFirstResponder()
        case (2, 3):
            self.isOrganicSwitch.becomeFirstResponder()
        case (2, 4):
            yearPickerCollapsed = !yearPickerCollapsed
        case (2, 6):
            openImageSelection();
            break
        case (_, _):
            break
        }
    }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        //print("section: \(section), row: \(row)")
        switch(section,row){
        case (2, 6):
            openImageSelection();
        case (_, _):
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        let section = indexPath.section
        switch(section,row) {
        case (0, 2):
            return 130.0
        case (2, 1):
            return 110.0
        case (2, 5):
            return yearPickerCollapsed ? 150.0 : 0
        case (_, _):
            return 44.0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateYearLabel()
    }
    func updateYearLabel() {
        self.yearLabel.text = String(years[yearPicker.selectedRow(inComponent: 0)])
    }
    func openImageSelection() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if currentPickedImage == nil {
            
            let alertController = UIAlertController(title: "Choose image", message: "Choose an image source", preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let cameraAction = UIAlertAction(title: "Take a picture", style: .default, handler:
            {action in
                imagePicker.sourceType = .camera
                self.present(imagePicker,animated: true, completion: nil)
            })
            let libraryAction = UIAlertAction(title: "Choose a picture", style: .default, handler:
            {action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker,animated: true, completion: nil)
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(cameraAction)
            alertController.addAction(libraryAction)
            alertController.popoverPresentationController?.sourceView = bottleLabelCell
            
            present(alertController,animated: true, completion: nil)
        } else {
            let popup = PopupDialog(title: "Current picked image", message: nil, image: currentPickedImage)
            
            let resetImageButton = DefaultButton(title: "Remove image",dismissOnTap: true) {
                self.currentPickedImage = nil
                self.updateLabelPickerCell()
            }
            
            let cancelPopupButton = CancelButton(title: "Cancel", dismissOnTap: true) {}
            
            popup.addButtons([resetImageButton, cancelPopupButton])
            
            // Present dialog
            self.present(popup, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            currentPickedImage = pickedImage
            updateLabelPickerCell()
            dismiss(animated: true, completion: nil)
        }
    }
    
    func updateLabelPickerCell() {
        if let _ = currentPickedImage {
            bottleLabelCell.accessoryType = .detailButton
            bottleLabelCell.detailTextLabel?.text = "Image selected"
        } else {
            bottleLabelCell.accessoryType = .disclosureIndicator
            bottleLabelCell.detailTextLabel?.text = "Choose an image"
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        let name = nameTextField.text!
        let description = descriptionTextView.text.count == 0 ? nil :  descriptionTextView.text
        let originalGravity = originalGravityTextField.text?.count ?? 0 == 0 ? nil :  originalGravityTextField.text
        let alcoholByVolume = alcoholByVolumeTextField.text?.count ?? 0  == 0 ? nil : alcoholByVolumeTextField.text
        let internationalBitteringUnit = internationalBitteringUnitTextField.text?.count ?? 0  == 0 ? nil : internationalBitteringUnitTextField.text
        let servingTemperature = servingTemperatureTextField.text?.count ?? 0  == 0 ? nil : servingTemperatureTextField.text
        let foodPairings = foodPairingsTextView.text.count == 0 ? nil : foodPairingsTextView.text
        let isRetired = isRetiredSwitch.isOn
        let isOrganic = isOrganicSwitch.isOn
        let year = years[yearPicker.selectedRow(inComponent: 0)]
        let image = currentPickedImage

        let beer = Beer()
        beer.name = name
        beer.beerDescription = description
        beer.originalGravity = originalGravity
        beer.alcoholByVolume = alcoholByVolume
        beer.internationalBitteringUnit = internationalBitteringUnit
        beer.servingTemperature = servingTemperature
        beer.foodPairings = foodPairings
        beer.isRetiredRealm.value = isRetired
        beer.isOrganicRealm.value = isOrganic
        beer.year = year
        
        if let editBeer = editBeer {
            RealmController.singleton.updateBeer(realmBeer: editBeer, dataBeer: beer, shouldUpdateTable: true) {
                error in
                if let error = error {
                    Toaster.makeErrorToast(view: self.navigationController?.view, text: "Couldn't edit beer: \(error.localizedDescription)")
                } else {
                    if let image = image {
                        beer.saveCustomImage(image: image)
                    }
                    Toaster.makeSuccesToast(view: self.navigationController?.view, text: "Succesfully edited beer '\(name)'")
                    self.performSegue(withIdentifier: "unwindToBeerDetails", sender: self)
                }
            }
        } else {
            beer.generateRandomId()
            beer.isSelfMade = true
            RealmController.singleton.addBeer(beer: beer, shouldUpdateTable: true) {
                error in
                if let error = error {
                    Toaster.makeErrorToast(view: self.navigationController?.view, text: "Couldn't add new beer: \(error.localizedDescription)")
                } else {
                    if let image = image {
                        beer.saveCustomImage(image: image)
                    }
                    Toaster.makeSuccesToast(view: self.navigationController?.view, text: "Succesfully added beer '\(name)'")
                    self.performSegue(withIdentifier: "unwindToMyBeers", sender: self)
                }
            }
        }
 
    }
    
    @objc func nameChanged() {
        saveButton.isEnabled = (nameTextField.text?.count ?? 0) > 0

    }
    @IBAction func cancelTapped(_ sender: Any) {
        if editBeer == nil {
            self.performSegue(withIdentifier: "unwindToMyBeers", sender: self)
        } else {
            self.performSegue(withIdentifier: "unwindToBeerDetails", sender: self)
        }
    }
}
