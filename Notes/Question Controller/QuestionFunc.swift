//
//  QuestionFunc.swift
//  Notes
//
//  Created by Yuying Li on 2019-01-23.
//  Copyright © 2019 Yuying Li. All rights reserved.
//

import Foundation
import UIKit
import AWSAuthCore
import AWSAuthUI
import AWSCore
import AWSDynamoDB
import AWSS3


//These functions will be called when the user access to the question. The names of these functions suggest what this function will do.
func queryQuestion(subject: String, specificPool: inout [Question]){
    let qExp = AWSDynamoDBQueryExpression()
    
    qExp.keyConditionExpression = "#uId = :subject"
    
    qExp.expressionAttributeNames = ["#uId":"subject"]
    qExp.expressionAttributeValues = [":subject":subject]
    
    
    let objMapper = AWSDynamoDBObjectMapper.default()
    objMapper.query(Question.self, expression: qExp) { (output, error) in
        if let questions = output?.items as? [Question] {
            questions.forEach({ (question) in
                specificPool.append(question)
            })
        }
    }
}



func loadQuestion(subject: String?, creation: NSNumber?) {
    let dbObjMapper = AWSDynamoDBObjectMapper.default()
    
    if let hashKey = subject, let date = creation {
        dbObjMapper.load(Question.self, hashKey: hashKey, rangeKey: date){(model, error) in
            if let question  = model as? Question {
                selectedQuestion = question
            }
        }
    }
}

func createQuestion(subject: String, pageNumber: Int, questionNumber: Int, descrip: String, asked: String) {
    guard let question = Question() else {return}
    question._subject = subject
    question._pageNum = pageNumber as NSNumber
    question._questionNum = questionNumber as NSNumber
    question._description = descrip
    question._askedBy = asked
    question._creationDate = Date().timeIntervalSince1970 as NSNumber
    question._imageKey = ["imageKey"]
    question._answeredByArray = ["answeredBy"]
    saveQuestion(question: question)
}

func saveQuestion(question: Question) {
    let dbObjMapper = AWSDynamoDBObjectMapper.default()
    dbObjMapper.save(question) { (error) in
        print(error?.localizedDescription ?? "no error")
    }
}

func updateQuestion(imageKeySet: Set<String>, userNameSet: Set<String>) {
    let dbObjMapper = AWSDynamoDBObjectMapper.default()
    if let hashKey = selectedQuestion?._subject {
        dbObjMapper.load(Question.self, hashKey: hashKey, rangeKey: selectedQuestion?._creationDate){(model, error) in
            if let question  = model as? Question {
                question._imageKey = imageKeySet
                question._answeredByArray = userNameSet
                saveQuestion(question: question)
            }
        }
        
    }
}

func querySpecificQuestionPool(specificSub: String, specificPool: inout [Question]) {
    
    //queryQuestion(subject: specificSub)
    print("in function question array\(questionArray.count)")
    specificPool = questionArray
    questionArray.removeAll()
    //test = specificPool
    // print(" grade 9 \(specificPool.count)")
    // specificPool.removeAll()
}

func uploadFile(imageView: UIImageView) {
    var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
    completionHandler = { (task, error) in
        print(task.response?.statusCode ?? "0")
        print(error?.localizedDescription ?? "no error")
    }
    let exp = AWSS3TransferUtilityUploadExpression()
    exp.progressBlock = {(task, progress) in
        DispatchQueue.main.async {
            
            print(progress.fractionCompleted)
        }
    }
    
    let storedKey = "\(selectedQuestion!._creationDate!)\(userName)\(selectedQuestion!._subject!)"
    let data = imageView.image!.jpegData(compressionQuality: 0.5)
    let imageKey = "public/\(storedKey).jpg"
    
    
    selectedQuestion!._answeredByArray!.insert(userName)
    selectedQuestion!._imageKey!.insert(imageKey)
    let imageKeyArray = selectedQuestion!._imageKey!
    let answerArray = selectedQuestion!._answeredByArray!
    
    updateQuestion(imageKeySet: imageKeyArray, userNameSet: answerArray)
    let tUtil = AWSS3TransferUtility.default()
    tUtil.uploadData(data!, key: imageKey, contentType: "image/jpg", expression: exp, completionHandler: completionHandler)
}


func downloadData(iv: UIImageView, imageKey: String) {
    var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
    completionHandler = {(task, URL, data, error) in
        DispatchQueue.main.async {
            iv.contentMode = .scaleAspectFit
            iv.image = UIImage.init(data: data!)
            print(data)
          
        }
    }
    
    let tUtil = AWSS3TransferUtility.default()
    tUtil.downloadData(forKey: "public/\(imageKey).jpg", expression: nil, completionHandler: completionHandler)
    print("finish")
    
}
