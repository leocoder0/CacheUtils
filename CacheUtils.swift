//
//  CacheUtils.swift
//  CacheUtils
//
//  Created by Steven on 2018/7/7.
//  Copyright © 2018年 Steven. All rights reserved.
//

import UIKit

public enum CacheCleanFolderPathKey : String {
    
    case documents = "/Documents"
    
    case library = "/Library"
    
    case tmp = "/tmp"
    
    case all
}


class CacheUtils: NSObject {
    
    
    /// 获取缓存大小
    ///
    /// - Returns: 缓存大小
    static func cacheSize() -> String {
        return converSizeUnit(folderSize:folderSize(folderPath: NSHomeDirectory()))
    }
    
    
    /// 获取目录缓存大小 单位MB
    ///
    /// - Parameter folderPath: 目录路径
    /// - Returns: 目录缓存大小
    static func folderSize(folderPath : String) -> Double {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: folderPath) {
            return 0.0
        }
        let subPaths = fileManager.subpaths(atPath: folderPath)
        var folderSize : Double = 0.0
        for path in subPaths! {
            let absolutePath = folderPath + "/" + path
            folderSize += fileSize(filePath: absolutePath)
        }
        return folderSize
    }
    
    
    /// 获取单个文件大小
    ///
    /// - Parameter filePath: 文件路径
    /// - Returns: 文件大小
    static func fileSize(filePath : String) -> Double {
        let fileManager = FileManager.default
        var fileSize : Double = 0.0
        do {
            let attr = try fileManager.attributesOfItem(atPath: filePath)
            fileSize = attr[FileAttributeKey.size] as! Double
        } catch {
            print(error)
        }
        return fileSize
    }
    
    /// 清除缓存
    static func cleanCache(pathKey : CacheCleanFolderPathKey , completion : (_ cleanedSize : String)->Void) {
        
        var cleanedSize : Double = 0.0
        switch pathKey {
            case .documents:
                cleanedSize += doCleanAndReturnCleanedSize(pathKey: .documents)
                break
            case .library:
                cleanedSize += doCleanAndReturnCleanedSize(pathKey: .library)
                break
            case .tmp:
                cleanedSize += doCleanAndReturnCleanedSize(pathKey: .tmp)
                break
            case .all:
                cleanedSize += doCleanAndReturnCleanedSize(pathKey: .documents)
                cleanedSize += doCleanAndReturnCleanedSize(pathKey: .library)
                cleanedSize += doCleanAndReturnCleanedSize(pathKey: .tmp)
                break
        }
        completion(converSizeUnit(folderSize: cleanedSize))
    }
    
    static func doCleanAndReturnCleanedSize(pathKey : CacheCleanFolderPathKey) -> Double {
        let beforeSize = folderSize(folderPath: NSHomeDirectory() + pathKey.rawValue)
        deleteFolderCache(folderPath: NSHomeDirectory() + pathKey.rawValue)
        let endSize = folderSize(folderPath: NSHomeDirectory() + pathKey.rawValue)
        return beforeSize - endSize;
    }
    
    
    /// 清除目录缓存
    ///
    /// - Parameter folderPath: 目录路径
    static func deleteFolderCache(folderPath : String) {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: folderPath) {
            return
        }
        let subPaths = fileManager.subpaths(atPath: folderPath)
        for path in subPaths! {
            let absolutePath = folderPath + "/" + path
            deleteFile(filePath: absolutePath)
        }
    }
    
    
    /// 删除单个文件
    ///
    /// - Parameter filePath: 文件路径
    static func deleteFile(filePath : String) {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: filePath) {
            return
        }
        do {
            try fileManager.removeItem(atPath: filePath)
        }catch {
            print(error)
        }
    }
    
    
    
    /// 转换缓存大小单位
    ///
    /// - Parameter folderSize: 大小
    /// - Returns: 返回大小
    static func converSizeUnit(folderSize : Double) -> String {
        if folderSize > 1024 * 1024 * 1024 * 1024 {
            return String(format: "%.2fTB", folderSize/1024/1024/1024/1024)
        }
        if folderSize > 1024 * 1024 * 1024 {
            return String(format: "%.2fGB", folderSize/1024/1024/1024)
        }
        if folderSize > 1024 * 1024 {
            return String(format: "%.2fMB", folderSize/1024/1024)
        }
        if folderSize > 1024 {
            return String(format: "%.2fKB", folderSize/1024)
        }
        return String(format: "%.2fB", folderSize)
    }
    

}
