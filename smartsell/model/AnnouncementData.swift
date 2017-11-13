//
//  AnnouncementData.swift
//  smartsell
//
//  Created by Apple on 18/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core

class AnnouncementData: NSObject,NSCoding {

    ///These variable contains property of AnnouncementData.
    var id:Int?
    var title:String?
    var message:String?
    var actionTarget:AnnouncementTarget?
    var actionText:String?
    var extraData:String?
    var showAgain:Bool?
    var frequency:Int?
    var startDate:Date?
    var endDate:Date?
    var lastShownDate:Date?
    
    ///These are the key used for saving data in Keychain.
    private let idKey = "id"
    private let titleKey = "title"
    private let messageKey = "message"
    private let actionTargetKey = "actionTarget"
    private let actionTextKey = "actionText"
    private let extraDataKey = "extraDataExtra"
    private let showAgainKey = "showAgain"
    private let frequencyKey = "frequency"
    private let startDateKey = "startDate"
    private let endDateKey = "endDate"
    private let lastShownDateKey = "lastShownDate"
    
    override init() {
        
    }
    
    init(announcementData:[String:AnyObject]) {
        super.init()
        if let id = announcementData["id"] as? Int {
            self.id = id
        }
        if let title = announcementData["title"] as? String{
            self.title = title
        }
        if let message = announcementData["message"] as? String{
            self.message = message
        }
        if let actionTarget = AnnouncementTarget.announcementTargetEnumFromString(string:(announcementData["action_target"] as? String) ?? "") {
            self.actionTarget = actionTarget
        }
        if let actionText = announcementData["action_text"] as? String{
            self.actionText = actionText
        }
        else {
            self.actionText = "Ok"
        }
        if let extraData = announcementData["extra_data"] as? String {
            self.extraData = extraData
        }
        if let showAgain = announcementData["show_again"] as? Bool{
            self.showAgain = showAgain
        }
        if let frequency = announcementData["frequency"] as? Int{
            self.frequency = frequency
        }
        if let startDate = self.dateFromString(announcementData["start_date"] as? String){
            self.startDate = startDate
        }
        if let endDate = self.dateFromString(announcementData["end_date"] as? String){
            self.endDate = endDate
        }
    }
    
    func dateFromString(_ string:String?) -> Date? {
        let dateformatter = DateFormatter()
        dateformatter.calendar = Calendar(identifier: .iso8601)
        dateformatter.locale = Locale.current
        dateformatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        dateformatter.dateFormat = "yyyy-MM-dd"
        return dateformatter.date(from:string ?? "")
    }
    
    required init(coder aDecoder: NSCoder) {
        
        if let id = aDecoder.decodeObject(forKey: idKey) as? NSNumber {
            self.id = id.intValue
        }
        
        if let title = aDecoder.decodeObject(forKey: titleKey) as? String {
            self.title = title
        }
        
        if let message = aDecoder.decodeObject(forKey: messageKey) as? String {
            self.message = message
        }
        
        if let actionTarget = AnnouncementTarget.announcementTargetEnumFromString(string: aDecoder.decodeObject(forKey: actionTargetKey) as? String ?? "") {
            self.actionTarget = actionTarget
        }
        
        if let actionText = aDecoder.decodeObject(forKey: actionTextKey) as? String {
            self.actionText = actionText
        }
        
        if let extraData = aDecoder.decodeObject(forKey: extraDataKey) as? String{
            self.extraData = extraData
        }
        self.showAgain = aDecoder.decodeBool(forKey: showAgainKey)
        
        if let frequency = aDecoder.decodeObject(forKey: frequencyKey) as? NSNumber{
            self.frequency = frequency.intValue
        }
        
        if let date = aDecoder.decodeObject(forKey: startDateKey) as? Date {
            self.startDate = date
        }
        
        if let date = aDecoder.decodeObject(forKey: endDateKey) as? Date {
            self.endDate = date
        }
        
        if let date = aDecoder.decodeObject(forKey: lastShownDateKey) as? Date {
            self.lastShownDate = date
        }
    }
    
    func encode(with aCoder: NSCoder) {
        if let id = self.id {
            aCoder.encode(NSNumber(value: id), forKey: idKey)
        }
        if let title = self.title {
            aCoder.encode(title, forKey: titleKey)
        }
        if let message = self.message {
            aCoder.encode(message, forKey: messageKey)
        }
        if let actionTarget = self.actionTarget?.rawValue {
            aCoder.encode(actionTarget, forKey: actionTargetKey)
        }
        if let actionText = self.actionText {
            aCoder.encode(actionText, forKey: actionTextKey)
        }
        if let extraData = self.extraData {
            aCoder.encode(extraData, forKey: extraDataKey)
        }
        if let showAgain = self.showAgain {
            aCoder.encode(showAgain, forKey: showAgainKey)
        }
        if let frequency = self.frequency {
            aCoder.encode(NSNumber(value: frequency), forKey: frequencyKey)
        }
        if let date = self.startDate {
            aCoder.encode(date, forKey: startDateKey)
        }
        if let date = self.endDate {
            aCoder.encode(date, forKey: endDateKey)
        }
        if let date = self.lastShownDate {
            aCoder.encode(date, forKey: lastShownDateKey)
        }
    }
}
