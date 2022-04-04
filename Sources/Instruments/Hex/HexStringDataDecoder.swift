//
//  HexStringDataDecoder.swift
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

public enum HexStringDataDecoderError: Error, Equatable {
   case unexpectedByte(String, location: Int)

   // MARK: - Equatable

   public static func ==(lhs: HexStringDataDecoderError, rhs: HexStringDataDecoderError) -> Bool {
      switch (lhs, rhs) {
         case let (.unexpectedByte(lhsByte, lhsLocation), .unexpectedByte(rhsByte, rhsLocation)):
            return lhsByte == rhsByte && lhsLocation == rhsLocation
      }
   }
}

public struct HexStringDataDecoder {
   // MARK: - Init

   public init() { }

   // MARK: - Decoding

   public func decode(_ hexString: String) throws -> Data {
      var data = Data()

      let step = 2
      for offset in stride(from: 0, through: hexString.count - step, by: step) {
         let startIndex = hexString.index(hexString.startIndex, offsetBy: offset)
         let endIndex = hexString.index(
            hexString.startIndex,
            offsetBy: offset + step - 1,
            limitedBy: hexString.endIndex
         ) ?? hexString.endIndex
         let byteString = String(hexString[startIndex...endIndex])
         if let byte = UInt8(byteString, radix: 16) {
            data.append(byte)
         } else {
            throw HexStringDataDecoderError.unexpectedByte(byteString, location: offset / 2)
         }
      }

      return data
   }
}
