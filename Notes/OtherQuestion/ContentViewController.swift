//
//  ContentViewController.swift
//  Notes
//
//  Created by Yuying Li on 2019-01-23.
//  Copyright © 2019 Yuying Li. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
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
        downloadOtherPhoto(imageKey: otherSpecificQuestion!._photoKey!, iv: imageView)
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.text = "Specific Description: \n\(otherSpecificQuestion!._otherDescription!)"
        determineWhichSegue = "OtherPool"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("did dis appear \(otherPool.count)")
    }
    override func viewWillDisappear(_ animated: Bool) {
       queryOtherQues(generalKey: generalKey)
        otherPool.removeAll()
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        print("zoom")
        return imageView
    } 
    
    
    @IBAction func unwindToContent(for unwindSegue: UIStoryboardSegue) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
