//
//  ParseExpectation.swift
//  Parsnip
//
//  Created by Jaden Geller on 3/1/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public enum ParseExpectation<Token> {
    case NamedParser(String)
    case Tokens([Token])
}

extension ParseExpectation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .NamedParser(let name): return name
        case .Tokens(let tokens):
            if Token.self is Character.Type {
                return "\"" + String(tokens.lazy.map{ $0 as! Character }) + "\""
            } else {
                return "\(tokens)"
            }
        }
    }
}