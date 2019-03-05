//
//  CommentFunc.swift
//  Notes
//
//  Created by Yuying Li on 2019-01-22.
//  Copyright © 2019 Yuying Li. All rights reserved.
//

import Foundation
import UIKit
import AWSAuthCore
import AWSAuthUI
import AWSCore
import AWSDynamoDB
import AWSS3


//These functions will be accessed when the user want to comment on something.

func createComment(commentKeyInput: String, useName: String, inputContext: String) {
    guard let comment = CommentModel() else {return}
    comment._commentDate = Date().timeIntervalSince1970 as NSNumber
    comment._commentedBy = userName
    comment._commentKey = commentKeyInput
    comment._context = inputContext
    saveComment(comment: comment)
}

func saveComment(comment: CommentModel){
  let dbObjMapper = AWSDynamoDBObjectMapper.default()
    dbObjMapper.save(comment) { (error) in
        print(error?.localizedDescription ?? "no error")
    }
}

func queryComment(commentKey: String){

    let qExp = AWSDynamoDBQueryExpression()
    
    qExp.keyConditionExpression = "#uId = :commentKey"
    
    qExp.expressionAttributeNames = ["#uId":"commentKey"]
    qExp.expressionAttributeValues = [":commentKey":commentKey]
    
    let objMapper = AWSDynamoDBObjectMapper.default()
    objMapper.query(CommentModel.self, expression: qExp) { (output, error) in
        if let comment = output?.items as? [CommentModel] {
            comment.forEach({ (com) in
               comments.append(com)
              
            })
        }
    }
}

//This array is used to store comments for specific functions.
var comments:[CommentModel] = []
