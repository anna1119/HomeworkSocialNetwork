//
//  MainMenuTableViewController.swift
//  Notes
//
//  Created by Yuying Li on 2018-12-31.
//  Copyright © 2018 Yuying Li. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSAuthUI
import AWSCore
import AWSDynamoDB
import AWSS3
import AWSUserPoolsSignIn
class MainMenuTableViewController: UITableViewController {

    @IBOutlet weak var logOutButton: UIButton!
    
    
    
    //If you use google sign in or facebook sign in, you will not have a user name,
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
     //This line of code will get the username and the initial state for the existence of user is false, the state will be changed when the user move to another view
   /*  userName = (AWSCognitoUserPoolsSignInProvider.sharedInstance().getUserPool().currentUser()?.username)!*/
      exist = false
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
        //This will check whether the user is logged in when the view is shown
        checkForLogin()
        print("userName: \(userName)")
        
        //test is an empty array. When the user choose specific question pool, test array will have specific values. When the view is shown, this array need to be kept empty.
        test.removeAll()
        
        //This variable determines which question pool will be loaded/query. When the user lunch the app, this is nil. When the user chooses a specific question pool, it will have specific value
        specificSub = ""
        
        //This variable refters to which question in the question pool is chosen, so that when the user goes to the answer pool, specific pool of answers will be loaded/queried.
        selectedQuestion = Question()
        
        //These codes query the question pools first so that when the app query again, there are values.
        //The first time you call the query function, no value will be queried.
        queryQuestion(subject: "Grade9Math", specificPool: &grade9Math)
        grade9Math.removeAll()
        queryQuestion(subject: "Grade10Math", specificPool: &grade10Math)
        grade10Math.removeAll()
        queryQuestion(subject: "Grade11Functions", specificPool: &grade11Functions)
        grade11Functions.removeAll()
        queryQuestion(subject: "Grade12AdFunc", specificPool: &grade12AdFunc)
        grade12AdFunc.removeAll()
        queryQuestion(subject: "Grade12DM", specificPool: &grade12DM)
        grade12DM.removeAll()
        queryQuestion(subject: "Grade12Cal", specificPool: &grade12Cal)
        grade12Cal.removeAll()
        queryQuestion(subject: "Grade11Phy", specificPool: &grade11Phy)
        grade11Phy.removeAll()
        queryQuestion(subject: "Grade12Phy", specificPool: &grade12Phy)
        grade12Phy.removeAll()
        queryQuestion(subject: "Grade11Che", specificPool: &grade11Che)
        grade11Che.removeAll()
        queryQuestion(subject: "Grade12Che", specificPool: &grade12Che)
        grade12Che.removeAll()
        queryQuestion(subject: "Grade11Bio", specificPool: &grade11Bio)
        grade11Bio.removeAll()
        queryQuestion(subject: "Grade12Bio", specificPool: &grade12Bio)
        grade12Bio.removeAll()
        queryOtherQues(generalKey: generalKey)
        otherPool.removeAll()
       
    }

    
    @IBAction func logOutButton(_ sender: Any) {
        //When the user click the log out button, the log in controller will be shown and the state of existence will be changed to false
        //The state of existence determines whether to create a new group information for this user
        AWSSignInManager.sharedInstance().logout { (value, error) in
            self.checkForLogin()
            exist = false
            LoggedInUser = LeaderBoardModel()
           
        }
    }
    
    //This function will check if the user has logged in.
    func checkForLogin() {
        if !AWSSignInManager.sharedInstance().isLoggedIn{
            AWSAuthUIViewController.presentViewController(with: self.navigationController!, configuration: nil) { (provider, error) in
                if error == nil {
                    print("success")
                   //If the user sign in by google/facebook, his/her name will be "Unknown"
                    if let userName2 = AWSCognitoUserPoolsSignInProvider.sharedInstance().getUserPool().currentUser()?.username {
                        userName = userName2
                    } else {
                        userName = "Unknown"
                    }
      
        
                   
                } else {
                    print(error?.localizedDescription ?? "no value")
                }
            }
           
        } else {
            //If the user sign in by google/facebook, his/her name will be "Unknown"
            if let userName2 = AWSCognitoUserPoolsSignInProvider.sharedInstance().getUserPool().currentUser()?.username
            {
                userName = userName2
            } else {
                userName = "Unknown"
            }
            //query the user information for the first time. Prepare for the second time.
            queryUserInformation(userPollArray: &userInformationPool)
            userInformationPool.removeAll()
            //initialize all the vairiables
            specificSub = ""
            selectedQuestion = Question()
            print("test \(exist)")
            

        }
    }
    
    //When the user chooses a specific question pool, this question pool will be queried.
    //"specificSub" is used when the user wants to create a new question, this variable will add the answer to the question pool it belongs to.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                
                queryQuestion(subject: "Grade9Math", specificPool: &grade9Math)
               
               test = grade9Math
                
               grade9Math.removeAll()
                specificSub = "Grade9Math"
            }
            if indexPath.row == 1{
                 queryQuestion(subject: "Grade10Math", specificPool: &grade10Math)
                test = grade10Math
                grade10Math.removeAll()
                specificSub = "Grade10Math"
        }
        
           if indexPath.row == 2 {
               queryQuestion(subject: "Grade11Functions", specificPool: &grade11Functions)
               test = grade11Functions
               grade11Functions.removeAll()
               specificSub = "Grade11Functions"
               
            }
           if indexPath.row == 3 {
               queryQuestion(subject: "Grade12AdFunc", specificPool: &grade12AdFunc)
                test = grade12AdFunc
               grade12AdFunc.removeAll()
               specificSub = "Grade12AdFunc"
            }
        
            if indexPath.row == 4 {
                queryQuestion(subject: "Grade12DM", specificPool: &grade12DM)
                test = grade12DM
                grade12DM.removeAll()
                specificSub = "Grade12DM"
              
            }
            if indexPath.row == 5 {
                queryQuestion(subject: "Grade12Cal", specificPool: &grade12Cal)
                test = grade12Cal
                print("test grade 12 cal \(test.count)")
                grade12Cal.removeAll()
                specificSub = "Grade12Cal"
            }
             performSegue(withIdentifier: "ToQuestion", sender: nil)
        }
        
        if indexPath.section == 1 {
            if indexPath.row == 0{
               queryQuestion(subject: "Grade11Phy", specificPool: &grade11Phy)
                test = grade11Phy
                grade11Phy.removeAll()
                specificSub = "Grade11Phy"
            }
            if indexPath.row == 1 {
                queryQuestion(subject: "Grade12Phy", specificPool: &grade12Phy)
                test = grade12Phy
                grade12Phy.removeAll()
                specificSub = "Grade12Phy"
                
            }
             performSegue(withIdentifier: "ToQuestion", sender: nil)
        }
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                queryQuestion(subject: "Grade11Che", specificPool: &grade11Che)
                test = grade11Che
                grade11Che.removeAll()
                specificSub = "Grade11Che"
            }
            if indexPath.row == 1 {
                queryQuestion(subject: "Grade12Che", specificPool: &grade12Che)
                test = grade12Che
                grade12Che.removeAll()
                specificSub = "Grade12Che"
            }
             performSegue(withIdentifier: "ToQuestion", sender: nil)
        }
        if indexPath.section == 3 {
            if indexPath.row == 0 {
                queryQuestion(subject: "Grade11Bio", specificPool: &grade11Bio)
                test = grade11Bio
                grade11Bio.removeAll()
                specificSub = "Grade11Bio"
                
            }
            if indexPath.row == 1 {
                queryQuestion(subject: "Grade12Bio", specificPool: &grade12Bio)
                test = grade12Bio
                grade12Bio.removeAll()
                specificSub = "Grade12Bio"
            }
             performSegue(withIdentifier: "ToQuestion", sender: nil)
        }
        if indexPath.section == 4 {
            if indexPath.row == 0 {
                queryOtherQues(generalKey: "OtherQuestion")
                testArray = otherPool
                otherPool.removeAll()
            }
        }
        
       
      
    }
    
   

}
