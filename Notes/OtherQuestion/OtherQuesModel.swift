//
//  OtherQuesModel.swift
//  MySampleApp
//
//
// Copyright 2019 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.21
//

import Foundation
import UIKit
import AWSDynamoDB

//This code is important. Because for AWS, it still does not have models that suit swift4. If we do not add this line, this model will not work.
@objcMembers

class OtherQuesModel: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _generalKey: String?
    var _askDate: NSNumber?
    var _title: String?
    var _askedBy: String?
    var _otherDescription: String?
    var _photoKey: String?
    
    class func dynamoDBTableName() -> String {

        return "notes-mobilehub-1131310125-OtherQuesModel"
    }
    
    class func hashKeyAttribute() -> String {

        return "_generalKey"
    }
    
    class func rangeKeyAttribute() -> String {

        return "_askDate"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
               "_generalKey" : "generalKey",
               "_askDate" : "askDate",
               "_title" : "Title",
               "_askedBy" : "askedBy",
               "_otherDescription" : "otherDescription",
               "_photoKey" : "photoKey",
        ]
    }
}