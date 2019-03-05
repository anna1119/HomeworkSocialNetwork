//
//  otherFunc.swift
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

var date: String = ""

//This variable is used as partition key in AWS.
var generalKey = "OtherQuestion"


//These function are similar to other models.
func createOtherQues(userName: String, title: String, description: String, imageView: UIImageView) {
    guard let other = OtherQuesModel() else {return}
    other._askDate = Date().timeIntervalSince1970 as NSNumber
    other._askedBy = userName
    other._generalKey = "OtherQuestion"
    other._otherDescription = description
    other._title = title
    let generalDate = Date().timeIntervalSince1970 as NSNumber
    other._photoKey = "public/\(generalDate)\(title)\(userName)Other.jpg"
    uploadOtherPhoto(imageView: imageView, imageKey: "public/\(generalDate)\(title)\(userName)Other.jpg")
    saveOtherQues(other: other)
}

func saveOtherQues(other: OtherQuesModel){
    let dbObjMapper = AWSDynamoDBObjectMapper.default()
    dbObjMapper.save(other) { (error) in
        print(error?.localizedDescription ?? "no error save other questions")
    }
}

func loadOtherQues(generalKey: String?, askDate: String?){
    let dbObjMapper = AWSDynamoDBObjectMapper.default()
    
    if let hashKey = generalKey, let date = askDate {
        dbObjMapper.load(OtherQuesModel.self, hashKey: hashKey, rangeKey: date){(model, error) in
            if let other  = model as? OtherQuesModel {
                otherSpecificQuestion = other
            }
        }
    }
    
}
func queryOtherQues(generalKey: String){
    let qExp = AWSDynamoDBQueryExpression()
    
    qExp.keyConditionExpression = "#uId = :generalKey"
    
    qExp.expressionAttributeNames = ["#uId":"generalKey"]
    qExp.expressionAttributeValues = [":generalKey":generalKey]
    
    
    let objMapper = AWSDynamoDBObjectMapper.default()
    objMapper.query(OtherQuesModel.self, expression: qExp) { (output, error) in
        if let others = output?.items as? [OtherQuesModel] {
            others.forEach({ (other) in
               otherPool.append(other)
            })
        }
    }
    
}
func uploadOtherPhoto(imageView: UIImageView, imageKey: String){
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
    
    let data = imageView.image!.jpegData(compressionQuality: 0.5)
    let tUtil = AWSS3TransferUtility.default()
    tUtil.uploadData(data!, key: imageKey, contentType: "image/jpg", expression: exp, completionHandler: completionHandler)
}
var image = UIImage()
func downloadOtherPhoto(imageKey: String, iv: UIImageView){
    var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
    completionHandler = {(task, URL, data, error) in
        DispatchQueue.main.async {
            iv.contentMode = .scaleAspectFit
           iv.image = UIImage.init(data: data!)
           
        }
    }
    
    let tUtil = AWSS3TransferUtility.default()
    tUtil.downloadData(forKey: imageKey, expression: nil, completionHandler: completionHandler)
    print("finish")
}



var otherSpecificQuestion = OtherQuesModel()
var otherPool: [OtherQuesModel] = []
var testImageryArray: [UIImage] = []
var testArray: [OtherQuesModel] = []
var determineWhichSegue = ""

