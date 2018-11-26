//
//  AddNewBeerTableViewController.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 26/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import UIKit

class AddNewBeerTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
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
    
    var years: [Int] = []
    var yearPickerCollapsed : Bool = false {
        didSet {
            yearPicker.isHidden = !yearPickerCollapsed
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for year in 1500...Calendar.current.component(Calendar.Component.year, from: Date()) {
            years.append(year)
        }
        years.reverse()
        yearPicker.delegate = self
        yearPicker.dataSource = self
        
        updateYearLabel()
        
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
        case (2, 5):
            //picket itself
            break
        case (2, 6):
            openImageSelection();
            break
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
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            dismiss(animated: true, completion: nil)
        }
    }

}
