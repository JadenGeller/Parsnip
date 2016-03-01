//
//  StreamState.swift
//  Parsnip
//
//  Created by Jaden Geller on 2/23/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import Spork

/// Provides backtracking capabilities by allowing a `ParseState` to be saved and restored.
public struct StreamState<Token> {
    private let backing: AnyForkableGenerator<Token>
    private let index: Int
}

extension InputStream {
    /// Save the current `ParseState` for later restoration.
    @warn_unused_result public func saveState() -> StreamState<Token> {
        return StreamState(backing: base.fork(), index: index)
    }
    
    /// Restore the `InputStream` to what is was when `checkpoint` was created.
    public func restore(state: StreamState<Token>) {
        base = state.backing
        index = state.index
    }
}