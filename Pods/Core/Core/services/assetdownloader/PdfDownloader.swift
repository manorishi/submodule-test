//
//  PdfDownloader.swift
//  Core
//
//  Created by kunal singh on 27/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 PdfDownloader downloads pdf files and save files to disk.
 */

import Foundation

public class PdfDownloader {

    init() {
        if !checkifDirectoryExists(){
            createDirectory()
        }
    }
    
    /**
     Download pdf file from url.
     */
    public func downloadPdf(url: String, filename: String, completion:@escaping (_ status:Bool) -> ()) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        if let requestURL = NSURL.init(string: url){
            let request = URLRequest(url: requestURL as URL, cachePolicy: .returnCacheDataElseLoad)
            let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                if let tempLocalUrl = tempLocalUrl, error == nil {
                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                        if statusCode == 200 {
                            do {
                                self.deletePdfifAlreadyPresent(filename: filename)
                                try FileManager.default.copyItem(at: tempLocalUrl, to: self.filePath(filename: filename))
                                DispatchQueue.main.async {
                                    completion(true)
                                }
                            } catch let error as NSError {
                                logToConsole(printObject: "Error saving pdf: \(error.localizedDescription)")
                                DispatchQueue.main.async {
                                    completion(false)
                                }
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            }
            task.resume()
        }else{
            completion(false)
        }
    }
    
    public func retrievePdf(filename: String) -> URL?{
        return filePath(filename: filename)
    }
    
    /**
     Check pdf file exist on disk or not.
     */
    public func checkifFileExists(filename: String) -> Bool{
        var isDir : ObjCBool = false
        let directory = directoryPath().path
        if FileManager.default.fileExists(atPath: "\(directory)/\(filename)", isDirectory: &isDir){
            if !isDir.boolValue {
                return true
            }
        }
        return false
    }
    
    /**
     Check pdf files with name and if it exist then delete file.
     */
    func deletePdfifAlreadyPresent(filename: String){
        let fileManager = FileManager.default
        let directory = directoryPath().path
        do{
            try fileManager.removeItem(atPath:"\(directory)/\(filename)")
        }catch let error as NSError{
            logToConsole(printObject: error.localizedDescription)
        }
    }
    
    func listOfDownloadedPdfs() -> [String] {
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(atPath: directoryPath().path)
            return directoryContents as [String]
        } catch let error as NSError {
            logToConsole(printObject: error.localizedDescription)
        }
        return []
    }
    
    /**
     Delete older version pdf file.
     */
    func deleteOlderPdfs(downloadedPdfs: [String], alreadyPresentPdfs: [String]){
        let fileManager = FileManager.default
        let pdfsToBeDeleted = Array(Set(downloadedPdfs).subtracting(alreadyPresentPdfs))
        let directory = directoryPath().path
        do{
            for pdfUrl in pdfsToBeDeleted{
                try fileManager.removeItem(atPath:"\(directory)/\(pdfUrl)")
            }
        }catch let error as NSError{
            logToConsole(printObject: error.localizedDescription)
        }
    }
    
    private func filePath(filename: String) -> URL{
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("\(CoreConstants.CUSTOM_CACHE_PDF_FOLDER)/\(filename)")
    }
    
    private func directoryPath() -> URL{
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(CoreConstants.CUSTOM_CACHE_PDF_FOLDER)
    }
    
    private func checkifDirectoryExists() -> Bool{
        var isDir : ObjCBool = false
        if FileManager.default.fileExists(atPath: directoryPath().path, isDirectory: &isDir){
            if isDir.boolValue {
                return true
            }
        }
        return false
    }
    
    private func createDirectory(){
        do {
           try FileManager.default.createDirectory(atPath: directoryPath().path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            logToConsole(printObject: "Error creating directory: \(error.localizedDescription)")
        }
    }
    
}
