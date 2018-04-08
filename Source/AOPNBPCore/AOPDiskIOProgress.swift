//
// 
//  AOPMmapIOProgress.swift
//  source
//
//  Created by Noah_Shan on 2018/4/8.
//  Copyright © 2018年 Inspur. All rights reserved.
//
// 
import Foundation

/*
 DISK-progress center
 TODO:
 1.use mmap save the memory event infos
 2.read event info from file : if success then deleate the file ,
   if deleate file success return the fileStrinfo else return nil.
   user should not invoking the deleate function manual.
 3.basic file/dir progress [file create | file deleate | file read | file write(use mmap)]
 */

class AOPDiskIOProgress {
    
    private init() {
        createTheDir()
    }
    
    static var shareInstance: AOPDiskIOProgress!
    
    private let realAOPDirFolder: String = "/AOPNBPUTFile"
    
    private let nouseFileName: String = "DS_Store"
    
    public static func getInstance()-> AOPDiskIOProgress {
        if shareInstance == nil {
            shareInstance = AOPDiskIOProgress()
        }
        return shareInstance
    }
    
    /// set
    func writeEventsToDisk(with info:[String : [GodfatherEvent]]) {
        for (eachKey,eachValue) in info {
            var eventStr = ""
            for eachItem in eachValue {
                eventStr += (eachItem.description)
            }
            AOPMmapOCUtility().writeData(eachKey, fileContent: eventStr)
        }
    }
    
    /// get all file-path
    func getAllSavedFilepath() -> [String] {
        let result = self.loopGetDocumentsFile()
        return result
    }
    
    /// get one file strInfo with file-name
    /// read over then deleate the file : if DELEATE success return fileInfo either return nil
    func getOneFileDataWithFilePath(with path: String)->String? {
        do{
            let resultStr = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            if self.deleateFile(with: path) {
                return resultStr
            }
            return nil
        }catch{
            // donothing[couldn't deleate file]
        }
        return nil
    }
    
    // MARK: - file manager
    
    /// create the [/AOPNBPUTFile] dir
    private func createTheDir() {
        let aopDir = self.getDocumentsPath() + realAOPDirFolder
        if !FileManager.default.fileExists(atPath: aopDir) {
            do {
                try FileManager.default.createDirectory(atPath: aopDir, withIntermediateDirectories: true, attributes: nil)
            }catch{}
        }
    }
    
    /// deleate file with path
    private func deleateFile(with filePath:String)->Bool{
        do {
            try FileManager.default.removeItem(atPath: filePath)
        }catch {
            return false
        }
        return true
    }
    
    /// get documents file path
    private func getDocumentsPath()->String {
        let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentPath = documentPaths[0]
        return documentPath
    }
    
    /// get [/AOPNBPUTFile] dirpath's files
    private func loopGetDocumentsFile()->[String] {
        let dirPath = self.getDocumentsPath() + realAOPDirFolder
        var filePaths = [String]()
        do {
            let array = try FileManager.default.contentsOfDirectory(atPath: dirPath)
            for fileName in array {
                if fileName.contains(nouseFileName) { continue }
                var isDir: ObjCBool = true
                let fullPath = "\(dirPath)/\(fileName)"
                if FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDir) {
                    if !isDir.boolValue {
                        filePaths.append(fullPath)
                    }
                }
            }
        } catch let error as NSError {
            DEBUGPrintLog("get file path error: \(error)")
        }
        return filePaths
    }
}
