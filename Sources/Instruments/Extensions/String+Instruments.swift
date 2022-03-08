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
   public func base64Encoded(options: Data.Base64EncodingOptions = []) -> String? {
      data(using: .utf8)?.base64EncodedString(options: options)
   }

   public func base64Decoded(options: Data.Base64DecodingOptions = []) -> String? {
      guard let data = Data(base64Encoded: self, options: options) else {
         return nil
      }

      return String(data: data, encoding: .utf8)
   }

   public func removingCharacters(in set: CharacterSet) -> String {
      let filtered = unicodeScalars.filter { !set.contains($0) }
      return String(String.UnicodeScalarView(filtered))
   }

   public mutating func removeCharacters(in set: CharacterSet) {
      self = removingCharacters(in: set)
   }
}
