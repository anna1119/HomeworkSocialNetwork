//
//  CommentTableViewController.swift
//  Notes
//
//  Created by Yuying Li on 2019-01-22.
//  Copyright © 2019 Yuying Li. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSAuthUI
import AWSCore
import AWSDynamoDB
import AWSS3

class CommentTableViewController: UITableViewController {

    @IBOutlet weak var addComment: UIBarButtonItem!
    
    @IBOutlet weak var refresh: UIBarButtonItem!
    
    //When the user chooses to add a comment, an alert box will be shown with an textfield.
    let alert = UIAlertController(title: "Add Comment", message: "Please enter your comments below", preferredStyle: .alert)

  
    override func viewWillAppear(_ animated: Bool) {
        queryComment(commentKey: key)
        comments.removeAll()
    }
    
    //When the view is loaded, the app will query all comments for this answer.
    //After the user finishing writing their comments, when they click done button, createComment functions will be called.
    override func viewDidAppear(_ animated: Bool) {
        queryComment(commentKey: key)
        print(comments.count)
        tableView.reloadData()
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: {
            textField in
            if let finalComment = self.alert.textFields?.first?.text {
                print(key)
                createComment(commentKeyInput: key, useName: userName, inputContext: finalComment)
                if determineWhichSegue == "OtherPool"{
                    self.performSegue(withIdentifier: "otherPool", sender: nil)
                }else if determineWhichSegue == "fromShownAnswer" {
                    self.performSegue(withIdentifier: "back", sender: nil)
                }
            }
        }))
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     
         alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
       
        alert.addTextField(configurationHandler: {
            textField in textField.placeholder = "Write your comment here"
        })
     
    }

   
    
    @IBAction func addComment(_ sender: Any) {
        present(alert, animated: true)
        queryComment(commentKey: key)
        print(comments.count)
        comments.removeAll()
    }
   
    override func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)

        cell.textLabel?.text = comments[indexPath.row]._context
        cell.detailTextLabel?.text = comments[indexPath.row]._commentedBy

        return cell
    }
    
}
