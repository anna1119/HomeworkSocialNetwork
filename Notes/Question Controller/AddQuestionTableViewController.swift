//
//  AddQuestionTableViewController.swift
//  Notes
//
//  Created by Yuying Li on 2019-01-03.
//  Copyright © 2019 Yuying Li. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSAuthUI
import AWSCore
import AWSDynamoDB
import AWSS3
import AWSUserPoolsSignIn
class AddQuestionTableViewController: UITableViewController {

    @IBOutlet weak var pageNumTextField: UITextField!
    
    @IBOutlet weak var questionNumTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    
    //Only when the user provide all information, she/he will be able to save this question. Also, if the user puts string in the textfield, she/he also cannot save this question
    func updateSaveState() {
       let pageNumText = pageNumTextField.text ?? ""
       let questionNumText = questionNumTextField.text ?? ""
       let descriptionText = descriptionTextField.text ?? ""
       
        saveButton.isEnabled = !pageNumText.isEmpty && !questionNumText.isEmpty && !descriptionText.isEmpty && (Int(pageNumText) != nil) && (Int(questionNumText) != nil)
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       updateSaveState()
         self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        print("userName: \(userName)")
        print("add question grade9 \(test.count)")
       
    }
    
    //As soon as the user provide all the information, the save button will be enabled.
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveState()
    }

    @IBAction func saveButton(_ sender: Any) {
    }
    
    //The color of the cell will turn back to white
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //When the user click the save button, the create function will be called and the question pool will be updated.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveUnwind" else {return}
        createQuestion(subject: specificSub, pageNumber: Int(pageNumTextField.text!)!, questionNumber: Int(questionNumTextField.text!)!, descrip: descriptionTextField.text!, asked: userName)
        
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
        
    }
  

}
