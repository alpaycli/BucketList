//
//  FileManager-DocumentsDirectory.swift
//  BucketListApp
//
//  Created by Alpay Calalli on 20.09.22.
//

import Foundation

extension FileManager{
    static var documentsDirectory: URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
