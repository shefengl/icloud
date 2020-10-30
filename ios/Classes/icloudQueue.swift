//
//  icloudQueue.swift
//  icloud
//
//  Created by KevinLi on 10/30/20.
//

import Foundation


class Backup: NSObject {
    
    var query: NSMetadataQuery!

    override init() {
        super.init()
        
        initialiseQuery()
        addNotificationObservers()

    }
    
    func initialiseQuery() {
        
        query = NSMetadataQuery.init()
        query.operationQueue = .main
        query.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
        query.predicate = NSPredicate(format: "%K LIKE %@", NSMetadataItemFSNameKey, "privateKey.txt")
    }
    
    func addNotificationObservers() {
                        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSMetadataQueryDidFinishGathering, object: query, queue: query.operationQueue) { (notification) in
            print("finish")
            self.processCloudFiles()
        }
        }
    func startToquery() {
        query.operationQueue?.addOperation({ [weak self] in
                    _ = self?.query.start()
                    self?.query.enableUpdates()
                })
    }
    
    @objc func processCloudFiles() -> Bool {
            print("startCheck")
        print(query.results)
            if query.results.count == 0 { return false}
            var fileItem: NSMetadataItem?
            var fileURL: URL?
            
            for item in query.results {
                
                guard let item = item as? NSMetadataItem else { continue }
                guard let fileItemURL = item.value(forAttribute: NSMetadataItemURLKey) as? URL else { continue }
                if fileItemURL.lastPathComponent.contains("privateKey.txt") {
                    fileItem = item
                    fileURL = fileItemURL
                    print(fileURL?.absoluteURL)
                }
            }
            
            let fileValues = try? fileURL!.resourceValues(forKeys: [URLResourceKey.ubiquitousItemIsUploadedKey])
        print(fileValues?.ubiquitousItemIsUploaded)
            if let fileUploaded = fileItem?.value(forAttribute: NSMetadataUbiquitousItemIsUploadedKey) as? Bool, fileUploaded == true, fileValues?.ubiquitousItemIsUploading == false {
                print("backup upload complete")
                query.stop()
                return true

            } else if let error = fileValues?.ubiquitousItemUploadingError {
                print("upload error---", error.localizedDescription)
                
            } else {
                if let fileProgress = fileItem?.value(forAttribute: NSMetadataUbiquitousItemPercentUploadedKey) as? Double {
                    print("uploaded percent ---", fileProgress)
                }
            }
        return false
        }
    
    
}
