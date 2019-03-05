//
//  LeaderBoardTableViewController.swift
//  Notes
//
//  Created by Yuying Li on 2019-01-17.
//  Copyright © 2019 Yuying Li. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSAuthUI
import AWSCore
import AWSDynamoDB
import AWSS3
import AWSUserPoolsSignIn

class LeaderBoardTableViewController: UITableViewController {

   // When the user logs in and directly click the leader board, this function will first check if the user exists in the user information pool, if the user does not exist, the function will create a information pool for his/her.
    override func viewWillAppear(_ animated: Bool) {
        queryUserInformation(userPollArray: &userInformationPool)
       
        for user in userInformationPool {
            if user._userId == AWSIdentityManager.default().identityId {
                exist = true
            }
        }
        if exist == false {
            createUserInformation(userId: AWSIdentityManager.default().identityId!, userName: userName)
        }
       
        userInformationPool.removeAll()
        
    }
    
    //This function will show users from highest points to lowest points.
    //When the user submit an answer, he/she will get one point.
    //Everytime the user goes into the leaderboard, "checkgroup" will check if some users get points. If some one gets point, the cell.imageview.image will show an up arrow
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        queryUserInformation(userPollArray: &userInformationPool)
        print("view did appear \(userInformationPool.count)")
        for index in 1..<userInformationPool.count {
            for index2 in (1...index).reversed() {
                if Int(userInformationPool[index2]._point!)! > Int(userInformationPool[index2-1]._point!)! {
                    userInformationPool.swapAt(index2, index2-1)
                } else {
                    break
                }
            }
        }
        print("check check\(checkGroup.count)")
        for index in 0..<checkGroup.count{
            for index2 in 0..<userInformationPool.count{
                if checkGroup[index]._userId == userInformationPool[index2]._userId{
                    if Int(checkGroup[index]._point!)! < Int(userInformationPool[index2]._point!)! {
                        print("true true")
                        advanceGroup.append(userInformationPool[index2]._userId!)
                    }
                }
            }
        }
        tableView.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInformationPool.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderBoardCell", for: indexPath)
       
         var number = 100

        if indexPath.row == 0 {
         cell.imageView?.image = #imageLiteral(resourceName: "goldStar1")
        }
        if indexPath.row == 1 {
         cell.imageView?.image = #imageLiteral(resourceName: "goldStar2")
        }
        if indexPath.row == 2 {
            cell.imageView?.image = #imageLiteral(resourceName: "gold4")
        }
        if advanceGroup.contains(userInformationPool[indexPath.row]._userId!){
           
           number = indexPath.row
        }
        if indexPath.row == number {
            cell.imageView?.image = #imageLiteral(resourceName: "baseline_trending_up_black_18pt")
        }
        cell.textLabel?.text = "\(userInformationPool[indexPath.row]._userName!): \(userInformationPool[indexPath.row]._point!) Points"
         return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Update checkArray and advanceGroup
    override func viewWillDisappear(_ animated: Bool) {
        let middle = userInformationPool.count/2
        checkGroup = Array(userInformationPool[0..<middle])
        print(advanceGroup)
        advanceGroup.removeAll()
    }
   

}
