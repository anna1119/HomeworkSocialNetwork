//
//  OthersViewController.swift
//  Notes
//
//  Created by Yuying Li on 2019-01-23.
//  Copyright © 2019 Yuying Li. All rights reserved.
//

import UIKit

class OthersViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate, UIScrollViewDelegate{

    @IBOutlet weak var keyWordTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var takePhotoButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var chooseFromAlbumButton: UIButton!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    //These two functions are used for zooming image
    func updateZoomFor(size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let scale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = scale
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //dismiss the keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        //update zoomed image
        scrollView.minimumZoomScale = 0.25
        scrollView.maximumZoomScale = 5.0
        scrollView.delegate = self
        updateZoomFor(size: view.bounds.size)
        
        //when the user gives all information needed, she/he is able to click the "Done" button
        updateDoneState()
        keyWordTextField.delegate = self
        descriptionTextField.delegate = self
    }
    
    func updateDoneState() {
        let keyWord = keyWordTextField.text ?? ""
        let description = descriptionTextField.text ?? ""
        doneButton.isEnabled = !keyWord.isEmpty && !description.isEmpty
        
       
    }
    
    //Check the state when the user is editing
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateDoneState()
    }
    
    //This function will be called when the user wants to take a photo
    @IBAction func takePhotoButton(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.camera
        image.allowsEditing = false
        self.present(image, animated: true)
        {
          
            self.updateDoneState()
        }
    }
    
    //used to allow user to pick a photo from album
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func chooseFromAlbumButton(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
        {
            
           
            self.updateDoneState()
        }
    }
    
    
    
    //Before the perform the segue, query the updated questions pool
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "done" else {return}
        createOtherQues(userName: userName, title: keyWordTextField.text!, description: descriptionTextField.text!, imageView: imageView)
        otherPool.removeAll()
        queryOtherQues(generalKey:generalKey)
        testArray = otherPool
    }

}
