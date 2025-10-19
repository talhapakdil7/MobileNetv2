//
//  ViewController.swift
//  MobileNetV2
//
//  Created by Talha Pakdil on 19.10.2025.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var sonucLabel: UILabel!
    var chosenImage = CIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

   
    @IBAction func changeButton(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true)
        
        
        if let ciImage = CIImage(image: imageView.image!) {
            chosenImage = ciImage
        }
        
        RecognizeImage(image: chosenImage)
        
        
        
    }
    
    func RecognizeImage(image:CIImage){
        
        //reguest
        //handler
        
        if let model = try? VNCoreMLModel(for: MobileNetV2().model){
            
            
            
            let request = VNCoreMLRequest(model: model) { VNRequest, error in
                
                if let results = VNRequest.results as? [VNClassificationObservation]{
                    
                    
                    let topresult = results.first!
                    
                    
                    DispatchQueue.main.async {
                        
                        let conflevel =  (topresult.confidence ?? 0) * 100
                        
                        let rounded = Int(conflevel*100)/100
                        
                        
                        self.sonucLabel.text = "  \(rounded)% this \(topresult.identifier)"
                        
                        
                    }
                    
                  
                }
                
               
                
                
                
                
            }
            
            let handler =  VNImageRequestHandler(ciImage: image)
            DispatchQueue.global().async {
                try? handler.perform([request])
            }
            
            
            
        }
        
    }
    
}

