//
//  String+truncate.swift
//
//  Created by Unknown Person Online
//

import Foundation

// gist from gitgub
extension String {
    /// Truncates the string to length number of characters and
    /// doesn't truncate within a word.
    /// appends optional trailing string if longer
    func truncate(length: Int, wordSeparator: String = " ", trailing: String = "…") -> String {
        
        if self.characters.count > length {
            let words = self.componentsSeparatedByString(wordSeparator)
            var cumulativeCharacters = 0
            var wordsToInclude:[String] = []
            for word in words {
                cumulativeCharacters += word.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) + 1
                if cumulativeCharacters < length {
                    //puts("cumulativeCharacters: \(cumulativeCharacters), length: \(length)")
                    wordsToInclude.append(word)
                } else {
                    return wordsToInclude.joinWithSeparator(wordSeparator) + trailing
                }
                
            }
            return self.substringToIndex(self.startIndex.advancedBy(length)) + trailing
        } else {
            return self
        }
    }
}