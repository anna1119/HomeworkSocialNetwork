//
//  QuestionPoolTableViewController.swift
//  Notes
//
//  Created by Yuying Li on 2019-01-01.
//  Copyright © 2019 Yuying Li. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSAuthUI
import AWSCore
import AWSDynamoDB
import AWSS3
import AWSUserPoolsSignIn
class QuestionPoolTableViewController: UITableViewController {
    
//When the user logs in and directly accesses the question pool, this function will check if the user exists in the userinformation pool. If not, this function will create a group of information for him/her. Then the user will be loaded.
    override func viewWillAppear(_ animated: Bool) {
        queryUserInformation(userPollArray: &userInformationPool)
        print(userInformationPool.count)
        for user in userInformationPool {
            if user._userId == AWSIdentityManager.default().identityId {
                exist = true
            }
        }
        if exist == false {
            createUserInformation(userId: AWSIdentityManager.default().identityId!, userName: userName)
        }
        userInformationPool.removeAll()
        print("\(exist)")
        print(userInformationPool.count)
        loadUser(Key: KeyForUser)
         print("question pool \(submitArray.count)")
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
     self.navigationItem.title = specificSub
    }
   
   
    override func viewDidAppear(_ animated: Bool) {
        
        //This is used to initialize the point and submitArray for this user
        //submit array means the answers that the user has submitted
        if let point = LoggedInUser?._point, let array = LoggedInUser?._submittedArray {
            newPoint = array.count-1
            submitArray = array
        }
     
       //According to the subject the user chooses, a specific question pool will be queried and shown.
       if specificSub == "Grade9Math" {
        queryQuestion(subject: specificSub, specificPool: &grade9Math)
        test = grade9Math
        grade9Math.removeAll()
        }
        if specificSub == "Grade10Math" {
            queryQuestion(subject: specificSub, specificPool: &grade10Math)
            test = grade10Math
            grade10Math.removeAll()
        }
        if specificSub == "Grade11Functions" {
            queryQuestion(subject: specificSub, specificPool: &grade11Functions)
            test = grade11Functions
            print("grade 11 \(grade11Functions.count)")
            grade11Functions.removeAll()
        }
        if specificSub == "Grade12AdFunc" {
            queryQuestion(subject: specificSub, specificPool: &grade12AdFunc)
            test = grade12AdFunc
            grade12AdFunc.removeAll()
        }
        if specificSub == "Grade12DM" {
            queryQuestion(subject: specificSub, specificPool: &grade12DM)
            test = grade12DM
            grade12DM.removeAll()
        }
        if specificSub == "Grade12Cal" {
            queryQuestion(subject: specificSub, specificPool: &grade12Cal)
            test = grade12Cal
            grade12Cal.removeAll()
        }
        if specificSub == "Grade11Phy" {
            queryQuestion(subject: specificSub, specificPool: &grade11Phy)
            test = grade11Phy
            grade11Phy.removeAll()
        }
        if specificSub == "Grade12Phy" {
            queryQuestion(subject: specificSub, specificPool: &grade12Phy)
            test = grade12Phy
            grade12Phy.removeAll()
        }
        if specificSub == "Grade11Che" {
            queryQuestion(subject: specificSub, specificPool: &grade11Che)
            test = grade11Che
            grade11Che.removeAll()
        }
        if specificSub == "Grade12Che" {
            queryQuestion(subject: specificSub, specificPool: &grade12Che)
            test = grade12Che
            grade12Che.removeAll()
        }
        if specificSub == "Grade11Bio" {
            queryQuestion(subject: specificSub, specificPool: &grade11Bio)
            test = grade11Bio
            grade11Bio.removeAll()
        }
        if specificSub == "Grade12Bio" {
            queryQuestion(subject: specificSub, specificPool: &grade12Bio)
            test = grade12Bio
            grade12Bio.removeAll()
        }
        
        tableView.reloadData()
        
        print("did appear test \(test.count)")
        
    }
   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      
        return test.count
    }

    //When there are answers for this question, checkmark will be shown.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath)
    
        cell.textLabel?.text = "Page: \(test[indexPath.row]._pageNum!) / Question: \(test[indexPath.row]._questionNum!)"
        cell.detailTextLabel?.text = "\(test[indexPath.row]._description!) (asked by: \(test[indexPath.row]._askedBy!))"
         
        let oneQuestion = test[indexPath.row]
        if let answer = oneQuestion._answeredByArray, let image = oneQuestion._imageKey {
            if  image.count == 1{
                cell.accessoryType = .disclosureIndicator
            }  else {
                print(answer.count)
                cell.accessoryType = .checkmark
            }
        }  else {
           
            cell.accessoryType = .disclosureIndicator
        }
       
        return cell
    }
    
    
    //This determines which answer pool will be queried.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedQuestion = test[indexPath.row]
     loadQuestion(subject: selectedQuestion?._subject, creation: selectedQuestion?._creationDate)
      selectedQuestion?._answeredByArray?.remove("answeredBy")
        tableView.reloadData()
    }
    @IBAction func unwindToQuestionPool(for unwindSegue: UIStoryboardSegue) {
        test.removeAll()
        
        }
        
        
   

}
