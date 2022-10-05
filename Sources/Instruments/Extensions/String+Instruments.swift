//
//  String+Instruments.swift
//
//  Copyright © 2022 Aleksei Zaikin.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

extension String {
   /// Encodes a string to its base64 representation.
   ///
   /// - Parameters:
   ///   - options: The options to use for the encoding. Default value is `[]`.
   /// - Returns: The Base-64 encoded string.
   public func base64Encoded(options: Data.Base64EncodingOptions = []) -> String? {
      data(using: .utf8)?.base64EncodedString(options: options)
   }

   /// Decodes a string from its base64 representation.
   ///
   /// - Parameters:
   ///   - options: The options to use for the decoding. Default value is `[]`.
   /// - Returns: The Base-64 decoded string.
   public func base64Decoded(options: Data.Base64DecodingOptions = []) -> String? {
      guard let data = Data(base64Encoded: self, options: options) else {
         return nil
      }

      return String(data: data, encoding: .utf8)
   }

   /// Returns new string by removing all characters from a given character set.
   ///
   /// - Parameters:
   ///   -  set: A `CharacterSet` characters of which is removed from a string.
   /// - Returns: A string without characters from a given `set`.
   public func removingCharacters(in set: CharacterSet) -> String {
      let filtered = unicodeScalars.filter { !set.contains($0) }
      return String(String.UnicodeScalarView(filtered))
   }

   /// Removes all characters from string a given character set contains.
   ///
   /// - Parameters:
   ///   -  set: A `CharacterSet` characters of which will is removed from a string.
   public mutating func removeCharacters(in set: CharacterSet) {
      self = removingCharacters(in: set)
   }

   /// Returns new string by removing given prefix.
   ///
   /// - Parameters:
   ///   - prefix: A prefix to be removed from string.
   /// - Returns: A string without given prefix.
   public func removingPrefix(_ prefix: String) -> String {
      guard hasPrefix(prefix) else {
         return self
      }

      return String(dropFirst(prefix.count))
   }

   /// Removes given prefix from string.
   ///
   /// - Parameters:
   ///   - prefix: A prefix to be removed from string.
   public mutating func removePrefix(_ prefix: String) {
      self = removingPrefix(prefix)
   }
}
