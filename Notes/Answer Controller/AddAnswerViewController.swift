//
//  AddAnswerViewController.swift
//  Notes
//
//  Created by Yuying Li on 2018-12-31.
//  Copyright © 2018 Yuying Li. All rights reserved.
//

import UIKit

class AddAnswerViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var takePhotoButton: UIButton!
    
    @IBOutlet weak var chooseFromLibraryButton: UIButton!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    //Enable the user to zoom image
    func updateZoomFor(size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let scale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = scale
        print("chage")
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        print("zoom")
        return imageView
    } 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.25
        scrollView.maximumZoomScale = 5.0
        scrollView.delegate = self
         updateZoomFor(size: view.bounds.size)
        
        saveButton.isEnabled = false
        print("add answer \(userName)")
    }
    
    @IBAction func takePhotoButton(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.camera
        image.allowsEditing = false
        self.present(image, animated: true)
        {
            self.saveButton.isEnabled = true
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func chooseFromLibraryButton(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
        {
           self.saveButton.isEnabled = true
        }
        
    }
    //When the user chooses to save the photo, the user will get one point only if they never answer this question. This means that for each question, they can only get one point, does not matter how many answers they submitted.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveAnswer" else {return}
        
        
        if let point = LoggedInUser?._point, let array = LoggedInUser?._submittedArray {
            newPoint = Int(point)!
            submitArray = array
        }
        
        let checkString = "\(selectedQuestion?._subject)\(selectedQuestion?._creationDate)"

        for existedAnswer in submitArray {
            if existedAnswer != checkString {
                submitArray.insert(checkString)
            }
        }
        
        newPoint = submitArray.count-1
        print(submitArray.count)
        
        updataUserInformation(answerArray: submitArray, newPoint: "\(newPoint)", Key: KeyForUser)
        loadUser(Key: KeyForUser)
        newPoint = Int(LoggedInUser!._point!)!
        submitArray = LoggedInUser!._submittedArray!
        uploadFile(imageView: imageView)
        if specificSub == "Grade9Math" {
            queryQuestion(subject: "Grade9Math", specificPool: &grade9Math)
            print("prepare \(grade9Math.count)")
            grade9Math.removeAll()
        }
        if specificSub == "Grade10Math" {
            queryQuestion(subject: "Grade10Math", specificPool: &grade10Math)
            grade10Math.removeAll()
        }
        
        if specificSub == "Grade11Functions" {
            queryQuestion(subject: "Grade11Functions", specificPool: &grade11Functions)
            grade11Functions.removeAll()
        }
        if specificSub == "Grade12AdFunc" {
            queryQuestion(subject: specificSub, specificPool: &grade12AdFunc)
            grade12AdFunc.removeAll()
        }
        if specificSub == "Grade12DM" {
            queryQuestion(subject: specificSub, specificPool: &grade12DM)
            grade12DM.removeAll()
        }
        if specificSub == "Grade12Cal" {
            queryQuestion(subject: specificSub, specificPool: &grade12Cal)
            grade12Cal.removeAll()
        }
        if specificSub == "Grade11Phy"{
            queryQuestion(subject: specificSub, specificPool: &grade11Phy)
            grade11Phy.removeAll()
        }
        if specificSub == "Grade12Phy" {
            queryQuestion(subject: specificSub, specificPool: &grade12Phy)
            grade12Phy.removeAll()
        }
        if specificSub == "Grade11Che"{
            queryQuestion(subject: specificSub, specificPool: &grade11Che)
            grade11Che.removeAll()
        }
        if specificSub == "Grade12Che" {
            queryQuestion(subject: specificSub, specificPool: &grade12Che)
            grade12Che.removeAll()
        }
        if specificSub == "Grade11Bio" {
            queryQuestion(subject: specificSub, specificPool: &grade11Bio)
            grade11Bio.removeAll()
        }
        if specificSub == "Grade12Bio"{
            queryQuestion(subject: specificSub, specificPool: &grade12Bio)
            grade12Bio.removeAll()
        }
        
        loadQuestion(subject: selectedQuestion?._subject, creation: selectedQuestion?._creationDate)
        print("image key \(selectedQuestion?._imageKey)")
        selectedQuestion?._answeredByArray?.remove("answeredBy")
    }
    

}
