//
//  ViewController.swift
//  Face Recognition
//
//  Created by Михаил Атоян on 12.05.2018.
//  Copyright © 2018 Михаил Атоян. All rights reserved.
//

import UIKit
import CoreImage
import CoreML

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var myImgView: UIImageView!
    @IBOutlet weak var myTxtView: UITextView!
    @IBAction func `import`(_ sender: Any) {
        
        //let button = UIButton(type: .roundedRect)
        //button.layer.cornerRadius = 3
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //Pick photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            myImgView.image = image
        }
        
        detect()
        self.dismiss(animated: true, completion: nil)
    }
    
    func detect()
    {
        //Get image from image view
        let myImage = CIImage(image: myImgView.image!)!
        
        //Set up the detector
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: myImage, options: [CIDetectorSmile: true])
        
        if !faces!.isEmpty{
            for face in faces as! [CIFaceFeature]
            {
                let mouth = face.hasMouthPosition ? "\n Рот распознан" : "\n Рот не распознан"
                let isSmiling = face.hasSmile ? "\n Улыбка распознана" : "\n Улыбка не распознана"
                var bothEyes = "\n Глаза распознаны"
                
                if !face.hasRightEyePosition || !face.hasLeftEyePosition
                {
                    bothEyes = "\n Глаза не распознаны"
                }
                
                //Degree of suspiciousness
                let suspiciousness = ["Низкое","Среднее", "Высокое", "Очень Высокое"]
                var suspectDegree = 0
                if face.hasMouthPosition {suspectDegree += 1}
                if face.hasSmile {suspectDegree += 1}
                if face.hasRightEyePosition && face.hasLeftEyePosition {suspectDegree += 1}
                if face.faceAngle < 10 && face.faceAngle > -10  {suspectDegree += 1}
                
                myTxtView.text = " Распознание лиц: \(suspiciousness[suspectDegree - 1]) \(mouth) \(isSmiling) \(bothEyes)"
            }
        }
        else
        {
             myTxtView.text = "\n Лицо не распознано" 
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detect()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

