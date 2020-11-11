import Flutter
import UIKit
import CloudKit

enum MethodName:String {
    case getPlatformVersion
    case getTextNumbber
    case upLoadFile
    case downloadFile
    case isIcloudAvailable
    case readFile
    case checkIcloudUserStatus
    case checkIfUploaded
    case checkIfIsUploading
    case checkIfUploadingError
    case checkIfDownloaded

}

@available(iOS 9.0, *)
public class SwiftIcloudPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "icloud", binaryMessenger: registrar.messenger())
    let instance = SwiftIcloudPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case MethodName.getPlatformVersion.rawValue:
        result("iOS " + UIDevice.current.systemVersion)
    case MethodName.getTextNumbber.rawValue:
        result("5")
    case MethodName.upLoadFile.rawValue:
        if let arguments = call.arguments as? Array<Any>, let dir = arguments[0] as? String, let subDir = arguments[1] as? String, let fileName = arguments[2] as? String, let privateKey = arguments[3] as? String {
            
            do {
                try  startBackup(dir: dir, subDir: subDir, fileName: fileName, privateKey: privateKey)
                result(nil)
            } catch {
                result(false)
            }
        } else {
            result(false)
        }
      
    case MethodName.isIcloudAvailable.rawValue:
        let token = FileManager.default.ubiquityIdentityToken
        if token == nil {
            result(false)
        } else {
            result(true)
        }
    case MethodName.readFile.rawValue:
        if let arguments = call.arguments as? Array<Any>, let dir = arguments[0] as? String, let subDir = arguments[1] as? String, let fileName = arguments[2] as? String {
            let value = readFile(dir: dir, subDir: subDir, fileName: fileName)
            result(value)
            
        } else {
            result(nil)
        }
    case MethodName.checkIcloudUserStatus.rawValue:
        checkIcloudUserStatus()
        result(nil)
    case MethodName.checkIfUploaded.rawValue:
        if let arguments = call.arguments as? Array<Any>, let dir = arguments[0] as? String, let subDir = arguments[1] as? String, let fileName = arguments[2] as? String {
            let value = checkIfFilesUploaded(dir: dir, subDir: subDir, fileName: fileName)
            result(value)
            
        } else {
            result(false)
        }
        
    case MethodName.checkIfDownloaded.rawValue:
        if let arguments = call.arguments as? Array<Any>, let dir = arguments[0] as? String, let subDir = arguments[1] as? String, let fileName = arguments[2] as? String {
            let value = checkIfFilesDownloaded(dir: dir, subDir: subDir, fileName: fileName)
            result(value)
            
        } else {
            result(false)
        }
        
    case MethodName.downloadFile.rawValue:
        if let arguments = call.arguments as? Array<Any>, let dir = arguments[0] as? String, let subDir = arguments[1] as? String, let fileName = arguments[2] as? String {
            let value = downLoadFile(dir: dir, subDir: subDir, fileName: fileName)
            result(value)
            
        } else {
            result(false)
        }
    case MethodName.checkIfIsUploading.rawValue:
        if let arguments = call.arguments as? Array<Any>, let dir = arguments[0] as? String, let subDir = arguments[1] as? String, let fileName = arguments[2] as? String {
            let value = checkIfFilesUploaded(dir: dir, subDir: subDir, fileName: fileName)
            result(value)
            
        } else {
            result(false)
        }
    case MethodName.checkIfUploadingError.rawValue:
        if let arguments = call.arguments as? Array<Any>, let dir = arguments[0] as? String, let subDir = arguments[1] as? String, let fileName = arguments[2] as? String {
            let value = checkIfFilesUploaded(dir: dir, subDir: subDir, fileName: fileName)
            result(value)
            
        } else {
            result(false)
        }
    default:
        result("null")
    }
    
  }
    
    func startBackup(dir: String, subDir: String, fileName: String, privateKey: String) throws {
        print("start")
        
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let testurl = URL(fileURLWithPath: "myFile", relativeTo: directoryURL).appendingPathExtension("txt")
        guard let data = privateKey.data(using: .utf8) else {
           print("Unable")
            return
        }
        do {
            try data.write(to: testurl)
        } catch {
            print(error.localizedDescription)
        }
        
        print(testurl)
        let containerURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)!.appendingPathComponent("Documents").appendingPathComponent(dir, isDirectory: true).appendingPathComponent(subDir, isDirectory: true)
    
        if !FileManager.default.fileExists(atPath: containerURL.path, isDirectory: nil) {
            try FileManager.default.createDirectory(at: containerURL, withIntermediateDirectories: true, attributes: nil)
        }
        let backupFileURL = containerURL
            
            .appendingPathComponent(fileName)
            .appendingPathExtension("txt")
        print(backupFileURL)
        
        
        if FileManager.default.fileExists(atPath: backupFileURL.path) {
            try FileManager.default.removeItem(at: backupFileURL)
            try FileManager.default.copyItem(at: testurl, to: backupFileURL)
        } else {
            try FileManager.default.copyItem(at: testurl, to: backupFileURL)
           
        }
        
    }
    
    func readFile(dir: String, subDir: String, fileName: String) -> String? {
        let containerURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)!.appendingPathComponent("Documents").appendingPathComponent(dir, isDirectory: true).appendingPathComponent(subDir, isDirectory: true)
        if !FileManager.default.fileExists(atPath: containerURL.path, isDirectory: nil) {
            return nil
        }
        let backupFileURL = containerURL
            .appendingPathComponent(fileName)
            .appendingPathExtension("txt")
        
        do {
         let data = try Data(contentsOf: backupFileURL)
            if let string = String(data: data, encoding: .utf8) {
               return string
            }
        } catch {
           return nil
        }
        
        return nil

    }
    func checkIfFilesUploaded(dir: String, subDir: String, fileName: String) -> Bool {
        let containerURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)!.appendingPathComponent("Documents").appendingPathComponent(dir, isDirectory: true).appendingPathComponent(subDir, isDirectory: true)
        if !FileManager.default.fileExists(atPath: containerURL.path, isDirectory: nil) {
            return false
        }
        let backupFileURL = containerURL
            .appendingPathComponent(fileName)
            .appendingPathExtension("txt")
        let isloaded = try? backupFileURL.resourceValues(forKeys: [URLResourceKey.ubiquitousItemIsUploadedKey])
        return isloaded?.ubiquitousItemIsUploaded ?? false
    }
    
    func checkIfFilesDownloaded(dir: String, subDir: String, fileName: String) -> Bool {
        let containerURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)!.appendingPathComponent("Documents").appendingPathComponent(dir, isDirectory: true).appendingPathComponent(subDir, isDirectory: true)
        if !FileManager.default.fileExists(atPath: containerURL.path, isDirectory: nil) {
            return false
        }
        let backupFileURL = containerURL
            .appendingPathComponent(fileName)
            .appendingPathExtension("txt")
        let isloaded = try? backupFileURL.resourceValues(forKeys: [URLResourceKey.ubiquitousItemDownloadingStatusKey])
        return (isloaded?.ubiquitousItemDownloadingStatus == .current)
    }
    
    func downLoadFile(dir: String, subDir: String, fileName: String) -> Bool {
        let containerURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)!.appendingPathComponent("Documents").appendingPathComponent(dir, isDirectory: true).appendingPathComponent(subDir, isDirectory: true)
        if !FileManager.default.fileExists(atPath: containerURL.path, isDirectory: nil) {
            return false
        }
        let backupFileURL = containerURL
            .appendingPathComponent(fileName)
            .appendingPathExtension("txt")
        do {
            try FileManager.default.startDownloadingUbiquitousItem(at:backupFileURL)
            return true
        } catch {
            print("Unexpected error: \(error)")
            return false
        }
    }
    
    func checkIcloudUserStatus() {
        CKContainer.default().accountStatus { (accountStatus, error) in
            print("d")
            switch accountStatus {
            case .available:
                print("iCloud Available")
            case .noAccount:
                print("No iCloud account")
            case .restricted:
                print("iCloud restricted")
            case .couldNotDetermine:
                print("Unable to determine iCloud status")
            default:
                print("default")
            }
        }
    }
}
