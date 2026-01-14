//
//  JSONDecoder+IgnoringErrors.swift
//
//  Copyright © 2026 Aleksei Zaikin.
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

extension JSONDecoder {
   /// Returns an array of values of the type you specify, decoded from a JSON object.
   ///
   /// If the data isn’t valid JSON, this method throws the DecodingError.dataCorrupted(_:) error.
   /// If a value within the JSON fails to decode, this method logs an error to the console, skips
   /// this value and continues to the next one.
   ///
   /// - Parameters:
   ///   - type: The type of the value to decode from the supplied JSON object.
   ///   - data: The JSON object to decode.
   /// - Returns: An array of values of the specified type. This array may have no values if decoder
   ///            couldn't decode anything from JSON array.
   /// - Throws: Decoding error if JSON data is corrupted.
   public func decodeArrayIgnoringErrors<Object: Decodable>(
      of type: Object.Type,
      from data: Data
   ) throws -> [Object] {
      try decode([DecodingErrorIgnoringWrapper<Object>].self, from: data).compactMap(\.wrapped)
   }
}
