//
//  TodoItem.swift
//  Time Note
//
//  Created by Sanjay Goswami on 26/12/23.
//


struct TodoItem: Codable {
    var task: String
    var isActive = false
    var time = 0.0
}
