//
//  DocumentsDirectoryController.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 26/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import Foundation
import UIKit

class DocumentsDirectoryController {
    static let singleton = DocumentsDirectoryController()
    
    init() {
        print("Documents directory: \(getDirectoryPath())")
    }
    
    let imageExtension = ".jpg"
    func saveImageDocumentDirectory(image : UIImage, fileName : String) {
        let fileManager = FileManager.default
        do{
            try fileManager.createDirectory(atPath: getDirectoryPath().relativePath,withIntermediateDirectories: true, attributes: nil)
        } catch {
            //Folder exists already
        }
        
        let fileURL = getDirectoryPath().appendingPathComponent(fileName+imageExtension)
        let imageData = image.jpegData(compressionQuality: 1.0)
        try? imageData?.write(to: fileURL)
    }
    
    func getDirectoryPath() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("BeerImages")
    }
    
    func getImage(fileName : String) -> UIImage?{
        let fileManager = FileManager.default
        let imagePath = getDirectoryPath().appendingPathComponent(fileName+imageExtension)
        if fileManager.fileExists(atPath: imagePath.relativePath){
            return UIImage(contentsOfFile: imagePath.relativePath)
        }else{
            return nil
        }
    }
    
    func removeImage(fileName : String) {
        let fileManager = FileManager.default
        let imagePath = getDirectoryPath().appendingPathComponent(fileName+imageExtension)
        if fileManager.fileExists(atPath: imagePath.relativePath){
            try? fileManager.removeItem(at: imagePath)
        }
    }
}
