//
//  String+Extension.swift
//  NetworkLayer
//
//  Created by Mirzhan Gumarov on 6/24/20.
//  Copyright © 2020 Mirzhan Gumarov. All rights reserved.
//

import Foundation

extension String {
    func concatenating(path: String) -> String {
        let bothHasSlash: Bool = self.hasSuffix("/") && path.hasPrefix("/")
        let oneOfThemHasSlash: Bool = self.hasSuffix("/") || path.hasPrefix("/")
        
        if bothHasSlash {
            return self + path.removingCharacter(at: 0)
        } else if oneOfThemHasSlash {
            return self + path
        } else {
            return self + "/" + path
        }
    }
    
    private func removingCharacter(at index: Int) -> String {
        var resultString: String = self
        let targetIndex = String.Index(utf16Offset: index, in: resultString)
        resultString.remove(at: targetIndex)
        return resultString
    }
}
