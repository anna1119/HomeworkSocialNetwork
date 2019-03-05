//
//  AnswerPoolTableViewController.swift
//  Notes
//
//  Created by Yuying Li on 2019-01-04.
//  Copyright © 2019 Yuying Li. All rights reserved.
//

import UIKit

class AnswerPoolTableViewController: UITableViewController {

    
    //For a specific questioon, if there is no answer for that, an alert box will be shown.
     let alert = UIAlertController(title: "Sorry", message: "No one has answered that", preferredStyle: .alert)
    override func viewDidLoad() {
        super.viewDidLoad()
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        if let question = selectedQuestion {
            
            if question._imageKey?.count == 1 {
                present(alert, animated: true)
            }
        }
        
    }
    
    //Before the view is shown, specific question will be loaded, as well as all answers for it.
    override func viewWillAppear(_ animated: Bool) {
        loadQuestion(subject: selectedQuestion?._subject, creation: selectedQuestion?._creationDate)
        selectedQuestion?._answeredByArray?.remove("answeredBy")
        tableView.reloadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("view did appear")
       
      
    }
   
    var myArray: [String] = []
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return selectedQuestion?._answeredByArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath)
     
        loadQuestion(subject: selectedQuestion?._subject, creation: selectedQuestion?._creationDate)
        selectedQuestion?._answeredByArray?.remove("answeredBy")
        myArray = Array(selectedQuestion!._answeredByArray!)
        print("my array \(myArray)")
        cell.textLabel?.text = "\(myArray[indexPath.row])'s answer"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
          name = myArray[indexPath.row]
        
          key = "\(selectedQuestion!._creationDate!)\(name)\(selectedQuestion!._subject!)"
         
    }
    
    
    //Before the user moves to another view, all questions in all question pool will be queried again.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
    
    @IBAction func unwindToAnswerPool(for unwindSegue: UIStoryboardSegue) {
       
        
    }

    

}
