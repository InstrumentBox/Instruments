//
//  Data+HexStringOptions.swift
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

extension Data {
   /// Options for converting `Data` to hexadecimal string.
   public struct HexStringOptions: OptionSet, Sendable {
      /// The corresponding value of the raw type.
      public var rawValue: Int

      // MARK: - Init

      /// Creates a set of hex string options from an integer that represents those options.
      ///
      /// - Parameters:
      ///   - rawValue: An option set of hex string options defined by this type.
      public init(rawValue: Int) {
         self.rawValue = rawValue
      }

      // MARK: - Predefined

      /// Specifies if the resulting string should be uppercased.
      public static let uppercased = HexStringOptions(rawValue: 1 << 0)
   }
}
