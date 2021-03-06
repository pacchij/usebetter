//
//  S3FileManager.swift
//  usebetter
//
//  Created by Prashanth Jaligama on 5/28/22.
//

import Foundation
import Combine

import Amplify
import AWSS3

class S3FileManager {
    private var bag = Set<AnyCancellable>()
    
    func downloadRemote(key: String, localURL: URL, completion: @escaping (Bool)->Void) {
        let storageOpertion = Amplify.Storage.downloadFile(key: key, local: localURL)
        let _ = storageOpertion.progressPublisher.sink { progress in
            print("S3FileManager: readRemote: Progress: \(progress)")
        }
        .store(in: &bag)
        
        let _ = storageOpertion.resultPublisher.sink {
            if case let .failure(storageError) = $0 {
                print("S3FileManager: readRemote: Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
                completion(false)
            }
        }
        receiveValue: { data in
            print("S3FileManager: readRemote: Completed: \(data)")
            completion(true)
        }
        .store(in: &bag)
    }
    
    func updateRemote(key: String, localURL: URL, completion: @escaping (Bool)->Void) {
        let storageOperation = Amplify.Storage.uploadFile(key:key, local: localURL)
        let _ = storageOperation.progressPublisher.sink { progress in
            print("S3FileManager: updateRemote: Progress: \(progress)")
        }
        .store(in: &bag)
        
        let _ = storageOperation.resultPublisher.sink {
            if case let .failure(storageError) = $0 {
                print("S3FileManager: updateRemote: Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
                completion(false)
            }
        }
        receiveValue: { data in
            print("S3FileManager: updateRemote: Upload Completed: \(data)")
            completion(true)
        }
        .store(in: &bag)
    }
    
    func listUserFolders(completion: @escaping (StorageListResult)->Void) {
        let _ = Amplify.Storage.list()
            .resultPublisher
            .sink {
                if case let .failure(storageError) = $0 {
                    print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
                }
            }
            receiveValue: { listResult in
                print("Completed \(listResult)")
                completion(listResult)
            }
            .store(in: &bag)
    }
}
