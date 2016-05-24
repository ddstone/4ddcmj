//
//  Database.swift
//  TimeRecorder
//
//  Created by apple on 5/17/16.
//  Copyright © 2016 ddstone. All rights reserved.
//

import Foundation

class Database {
    private var data: NSMutableData!
    private var archiver: NSKeyedArchiver!
    
    func insert(fileName: String, obj: NSObject, key: String) {
        let data = NSMutableData()
        archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        let filePath = (getDocumentPath() as NSString).stringByAppendingPathComponent(fileName)
        archiver.encodeObject(obj, forKey: key)
        archiver.finishEncoding()
        data.writeToFile(filePath, atomically: true)
    }
    
    func read(fileName: String, key: String) -> AnyObject? {
        let filePath = (getDocumentPath() as NSString).stringByAppendingPathComponent(fileName)
        if let unarchiveData = NSData(contentsOfFile: filePath) {
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: unarchiveData)
            return unarchiver.decodeObjectForKey(key)
        }
        return nil
    }
    
    func delFile(fileName: String) {
        let filePath = (getDocumentPath() as NSString).stringByAppendingPathComponent(fileName)
        let fm = NSFileManager()
        if fm.fileExistsAtPath(filePath) {
            try! fm.removeItemAtPath(filePath)
        }
    }
    
    // MARK: - Internal functions
    private func getDocumentPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    }
}
