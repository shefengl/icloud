import Flutter
import UIKit

enum MethodName:String {
    case getPlatformVersion
    case getTextNumbber
    case upLoadFile

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
        do {
            try  startBackup()
        } catch {
            print("ddd")
        }

        result(nil)
    default:
        result("null")
    }
    
  }
    
    func startBackup() throws {
        print("start")
//        guard let fileURL = Bundle.main.url(forResource: "sample", withExtension: "txt") else { return }
        
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let testurl = URL(fileURLWithPath: "myFile", relativeTo: directoryURL).appendingPathExtension("txt")
        
        let myString = "saving data"
        guard let data = myString.data(using: .utf8) else {
           print("Unable")
            return
        }
        do {
            try data.write(to: testurl)
        } catch {
            print(error.localizedDescription)
        }
        do {
         let data = try Data(contentsOf: testurl)
            if let string = String(data: data, encoding: .utf8) {
                print(string)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        print(testurl)
        let containerURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)!.appendingPathComponent("Documents").appendingPathComponent("test", isDirectory: true)
    
        if !FileManager.default.fileExists(atPath: containerURL.path, isDirectory: nil) {
            try FileManager.default.createDirectory(at: containerURL, withIntermediateDirectories: true, attributes: nil)
        }
        let backupFileURL = containerURL
            
            .appendingPathComponent("myFile")
            .appendingPathExtension("txt")
        print(backupFileURL)
        
        
        if FileManager.default.fileExists(atPath: backupFileURL.path) {
            try FileManager.default.removeItem(at: backupFileURL)
            try FileManager.default.copyItem(at: testurl, to: backupFileURL)
        } else {
            try FileManager.default.copyItem(at: testurl, to: backupFileURL)
           
        }
        
        do {
         let data = try Data(contentsOf: backupFileURL)
            if let string = String(data: data, encoding: .utf8) {
                print(string)
            }
        } catch {
            print("lll")
        }
        
    }

}
