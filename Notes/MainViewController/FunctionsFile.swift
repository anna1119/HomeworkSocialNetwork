//
//  FunctionsFile.swift
//  Notes
//
//  Created by Yuying Li on 2018-12-31.
//  Copyright © 2018 Yuying Li. All rights reserved.
//

import Foundation
import UIKit
import AWSAuthCore
import AWSAuthUI
import AWSCore
import AWSDynamoDB
import AWSS3

var userName = String()

// All functions there are used when accessing user information pool. The user information pool is used to create leader board. The names of functions suggest what it is used to do

func createUserInformation(userId: String, userName: String) {
    guard let user = LeaderBoardModel() else {return}
    user._userId = userId
    user._userName = userName
    user._point = "0"
    user._submittedArray = ["submitAnswer"]
    user._key = KeyForUser
    saveUserInformation(user: user)
}

func saveUserInformation(user: LeaderBoardModel) {
    let dbObjMapper = AWSDynamoDBObjectMapper.default()
    dbObjMapper.save(user) { (error) in
        print(error?.localizedDescription ?? "no error")
        
    }
}


func loadUser(Key: String?) {
    let dbObjMapper = AWSDynamoDBObjectMapper.default()
    if let hashKey = Key {
        dbObjMapper.load(LeaderBoardModel.self, hashKey: hashKey, rangeKey: AWSIdentityManager.default().identityId){(model, error) in
            if let user  = model as? LeaderBoardModel {
             LoggedInUser = user
            }
        }
    }
  
}


func updataUserInformation(answerArray: Set<String>, newPoint: String, Key: String?) {
    let dbObjMapper = AWSDynamoDBObjectMapper.default()
    if let hashKey = Key {
        dbObjMapper.load(LeaderBoardModel.self, hashKey: hashKey, rangeKey: AWSIdentityManager.default().identityId){(model, error) in
            if let user  = model as? LeaderBoardModel {
               user._submittedArray = answerArray
               user._point = newPoint
               saveUserInformation(user: user)
            }
        }
    }
}


func queryUserInformation(userPollArray: inout [LeaderBoardModel]) {
    let qExp = AWSDynamoDBQueryExpression()
    
    qExp.keyConditionExpression = "#uId = :Key"
    
    qExp.expressionAttributeNames = ["#uId":"Key"]
    qExp.expressionAttributeValues = [":Key":KeyForUser]
    
    
    let objMapper = AWSDynamoDBObjectMapper.default()
    objMapper.query(LeaderBoardModel.self, expression: qExp) { (output, error) in
        if let userInformation = output?.items as? [LeaderBoardModel] {
            userInformation.forEach({ (user) in
                userPollArray.append(user)
            })
            
        }
        
    }
    
}

//This is used in the search question view controller. If the question the user is searching exists, then they will be able to see the answers. If the question does not exist, the alert box will show and the user is able to create a new questioin.
var presentAlert = false
func searchFunc(pageNum: Int, questionNum: Int) {
    var final: [Question] = []
    var showArray: [Question] = []
    if specificSub == "Grade9Math" {
        queryQuestion(subject: specificSub, specificPool: &grade9Math)
        final = grade9Math
        grade9Math.removeAll()
    }
    if specificSub == "Grade10Math" {
        queryQuestion(subject: specificSub, specificPool: &grade10Math)
        final = grade10Math
        grade10Math.removeAll()
    }
    if specificSub == "Grade11Functions" {
        queryQuestion(subject: specificSub, specificPool: &grade11Functions)
        final = grade11Functions
        grade11Functions.removeAll()
    }
    if specificSub == "Grade12AdFunc" {
        queryQuestion(subject: specificSub, specificPool: &grade12AdFunc)
        final = grade12AdFunc
        grade12AdFunc.removeAll()
    }
    if specificSub == "Grade12DM" {
        queryQuestion(subject: specificSub, specificPool: &grade12DM)
        final = grade12DM
        grade12DM.removeAll()
    }
    if specificSub == "Grade12Cal" {
        queryQuestion(subject: specificSub, specificPool: &grade12Cal)
        final = grade12Cal
        grade12Cal.removeAll()
    }
    if specificSub == "Grade11Phy" {
        queryQuestion(subject: specificSub, specificPool: &grade11Phy)
        final = grade11Phy
        grade11Phy.removeAll()
    }
    if specificSub == "Grade12Phy"{
        queryQuestion(subject: specificSub, specificPool: &grade12Phy)
        final = grade12Phy
        grade12Phy.removeAll()
    }
    if specificSub == "Grade11Che"{
        queryQuestion(subject: specificSub, specificPool: &grade11Che)
        final = grade11Che
        grade11Che.removeAll()
    }
    if specificSub == "Grade12Che"{
        queryQuestion(subject: specificSub, specificPool: &grade12Che)
        final = grade12Che
        grade12Che.removeAll()
    }
    if specificSub == "Grade11Bio" {
        queryQuestion(subject: specificSub, specificPool: &grade11Bio)
        final = grade11Bio
        grade11Bio.removeAll()
    }
    if specificSub == "Grade12Bio" {
        queryQuestion(subject: specificSub, specificPool: &grade12Bio)
        final = grade12Bio
        grade12Bio.removeAll()
    }
    
    
    for question in final {
        if question._questionNum as! Int == questionNum && question._pageNum as! Int == pageNum {
            showArray.append(question)
            selectedQuestion = question
        }
    }
    
    
    if showArray.isEmpty {
     presentAlert = true
    } else {
      test = showArray
    }
    
}

