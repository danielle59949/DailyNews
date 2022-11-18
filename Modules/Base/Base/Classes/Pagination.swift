//
//  Page.swift
//  Base
//
//  Created by Daniel Le on 18/11/2022.
//

import Foundation

public class Pagination<T: Decodable> {
    public var data: [T] = []
    public var currentPage: Int = 1
    public var totalData: Int = 0
    
    public init() {}
    
    public init(data: [T], currentPage: Int, totalData: Int) {
        self.data = data
        self.currentPage = currentPage
        self.totalData = totalData
    }
    
    public var canLoadmore: Bool {
        return totalData > 0 && data.count < totalData
    }
    
    public var isEmpty: Bool {
        return data.isEmpty
    }
    
    public var count: Int {
        return data.count
    }
    
    public func append(_ pagination: Pagination<T>) {
        data.append(contentsOf: pagination.data)
        currentPage = pagination.currentPage
        totalData = pagination.totalData
    }
    
    public func removeAll() {
        data.removeAll()
        currentPage = 1
        totalData = 0
    }
}
