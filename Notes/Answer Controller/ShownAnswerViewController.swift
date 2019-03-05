//
//  ShownAnswerViewController.swift
//  Notes
//
//  Created by Yuying Li on 2019-01-04.
//  Copyright © 2019 Yuying Li. All rights reserved.
//

import UIKit

class ShownAnswerViewController: UIViewController, UIScrollViewDelegate{

    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    //Enable the user to zoom image
    func updateZoomFor(size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let scale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = scale
        print("chage")
    }
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.25
        scrollView.maximumZoomScale = 5.0
        
        scrollView.delegate = self
        updateZoomFor(size: view.bounds.size)
         self.navigationItem.title = "\(name)'s Answer"
        queryComment(commentKey: key)
        comments.removeAll()
        determineWhichSegue = "fromShownAnswer"
    }
   
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        print("zoom")
        return imageView
    }
    
    //This will download the data before the view is shown
    override func viewWillAppear(_ animated: Bool) {
        loadQuestion(subject: selectedQuestion?._subject, creation: selectedQuestion?._creationDate)
          key = "\(selectedQuestion!._creationDate!)\(name)\(selectedQuestion!._subject!)"
        downloadData(iv: imageView, imageKey: key)
    }
   
  
    
    @IBAction func unwindToAnswerTwo(segue: UIStoryboardSegue) {
       
    }
    
   
}
