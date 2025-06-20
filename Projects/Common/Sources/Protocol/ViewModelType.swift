//
//  ViewModelType.swift
//  Siggi
//
//  Created by 전소영 on 2024/08/31.
//

import Foundation

public protocol ViewModelType {
    associatedtype Action
    associatedtype State
  
    var state: State { get }
  
    func transform(type: Action)
}
