//
//  SearchTableViewController.swift
//  Notes
//
//  Created by Yuying Li on 2018-12-31.
//  Copyright © 2018 Yuying Li. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var pageNumTextField: UITextField!
    
    
    @IBOutlet weak var questionNumTextField: UITextField!
    
    
    //This will update the state of the search button
    func updateSearchButtonState() {
        let pageNumText = pageNumTextField.text ?? ""
        let questionNumText = questionNumTextField.text ?? ""
       
       searchButton.isEnabled = !pageNumText.isEmpty && !questionNumText.isEmpty && (Int(pageNumText) != nil) && (Int(questionNumText) != nil)
    }
    let alert = UIAlertController(title: "Sorry", message: "No one has asked this question", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        updateSearchButtonState()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
   
    @IBAction func textEditingChanged(_ sender: UITextField) {
       updateSearchButtonState()
    }
    
   
    //if there is a question, the answer will be shown. If there is not answer, alert box will be shown
    @IBAction func searchButton(_ sender: Any) {
     searchFunc(pageNum: Int(pageNumTextField.text!)!, questionNum: Int(questionNumTextField.text!)!)
        if presentAlert == true {
            present(alert, animated: true)
            presentAlert = false
        } else {
            performSegue(withIdentifier: "showAnswer", sender: nil)
        }
      
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
  

}
