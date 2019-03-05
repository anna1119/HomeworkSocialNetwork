//
//  OtherQuestionTableViewController.swift
//  Notes
//
//  Created by Yuying Li on 2019-01-23.
//  Copyright © 2019 Yuying Li. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSAuthUI
import AWSCore
import AWSDynamoDB
import AWSS3
import AWSUserPoolsSignIn

class OtherQuestionTableViewController: UITableViewController {

    //When the user logs in and goes into this tableview controller directly, this function will check if there is a information pool for this user, if not, it will create one for him/her
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
      
        loadUser(Key: KeyForUser)
        print("other \(otherPool.count)")
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
     var myArray: [UIImage] = []
    override func viewDidAppear(_ animated: Bool) {
    
      //This function query all questions and show them by the table view
       queryOtherQues(generalKey: generalKey)
       testArray = otherPool
        otherPool.removeAll()
       tableView.reloadData()
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return testArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "othersCell", for: indexPath)
       
     
        cell.textLabel?.text = testArray[indexPath.row]._title
        cell.detailTextLabel?.text = "\(testArray[indexPath.row]._otherDescription!)\n\(testArray[indexPath.row]._askedBy!)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        otherSpecificQuestion = testArray[indexPath.row]
        key = otherSpecificQuestion!._photoKey!
       
        tableView.reloadData()
    }
    @IBAction func unwindToOtherPool(for unwindSegue: UIStoryboardSegue) {
       testArray.removeAll()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }
   
}
