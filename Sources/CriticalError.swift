//
//  CriticalError.swift
//  Parsnip
//
//  Created by Jaden Geller on 3/1/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

/// A critical error that will not be recovered from by the standard parsing combinators.
public struct Critical<Error: ErrorType>: ErrorType {
    /// The error.
    public let error: Error
    
    // Construct a critical error
    public init(_ error: Error) {
        self.error = error
    }
}