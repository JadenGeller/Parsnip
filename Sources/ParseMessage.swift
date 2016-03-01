//
//  ParseMessage.swift
//  Parsnip
//
//  Created by Jaden Geller on 3/1/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public enum ParseMessage<Token>: ErrorType {
    case UnableToMatch([ParseExpectation<Token>])
    case Failure(String)
}

extension ParseMessage: CustomStringConvertible {
    public var description: String {
        switch self {
        case .UnableToMatch(let failures):
            var message = "expecting "
            for (i, failure) in failures.enumerate() {
                if i != 0 { message += ", " }
                if i.successor() == failures.endIndex { message += "or " }
                message += failure.description
            }
            return message
        case .Failure(let message):
            return message
        }
    }
}

extension ParseMessage {
    public init(combine messages: [ParseMessage]) {
        var expections: [ParseExpectation<Token>] = []
        var lastFailure: ParseMessage?
        for reason in messages {
            switch reason {
            case .UnableToMatch(let subExpections):
                expections += subExpections
            case .Failure:
                lastFailure = reason
            }
        }
        if expections.isEmpty, let lastFailure = lastFailure {
            self = lastFailure
        } else {
            self = .UnableToMatch(expections)
        }
    }
}
