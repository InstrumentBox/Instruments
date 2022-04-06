//
//  JSONDecoder.DataDecodingStrategy+HexString.swift
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

extension JSONDecoder.DataDecodingStrategy {
   /// A data decoding strategy that uses `HexStringDataDecoder`.
   ///
   /// The following JSON
   /// ```json
   /// {
   ///    "data": "abcdef"
   /// }
   /// ```
   /// can be decoded to
   ///
   /// ```swift
   /// struct SomeObject: Decodable {
   ///    let data: Data
   /// }
   /// ```
   /// using following `JSONDecoder`
   ///
   /// ```swift
   /// let decoder = JSONDecoder()
   /// decoder.dataDecodingStrategy = .hexString
   /// ```
   /// where `data` property will contain three bytes: `[0xAB, 0xCD, 0xEF]`.
   public static let hexString: JSONDecoder.DataDecodingStrategy = .custom { decoder in
      let container = try decoder.singleValueContainer()
      let hexString = try container.decode(String.self)

      do {
         let hexDecoder = HexStringDataDecoder()
         return try hexDecoder.decode(hexString)
      } catch let HexStringDataDecoderError.unexpectedByte(byte, location) {
         let debugDescription = "Incorrect byte \(byte) at location \(location)"
         throw DecodingError.dataCorruptedError(in: container, debugDescription: debugDescription)
      } catch {
         let debugDescription = "Unexpected error \(error)"
         throw DecodingError.dataCorruptedError(in: container, debugDescription: debugDescription)
      }
   }
}
