//
//  BytesConstructibleNumber.swift
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

/// A protocol to which number should conform to be initialized from array of bytes and some
/// endianness. The `Instruments` library makes all integer types to conform this protocol.
public protocol BytesConstructibleNumber {
   /// Creates and returns a new instance of a number with a given parameters.
   ///
   /// If number of bytes exceeds type size, it truncates bytes in the beginning or end depending
   /// on endianness. In case of BE it takes last `MemoryLayout<Self>.size` bytes, and in case of
   /// LE it takes first `MemoryLayout<Self>.size` bytes.
   ///
   /// If number of bytes is less that `MemoryLayout<Self>.size`, it adds zero bytes in the
   /// beginning or end depending on endianness. In case of BE it adds bytes in the beginning, and
   /// in case of LE it adds bytes in the end.
   ///
   /// - Parameters:
   ///   - data: An instance of `Data` that will be used to initialize a number.
   ///   - endianness: An endianness to be used to initialize a number. Defaults to `.big`.
   init(data: Data, endianness: Endianness)

   /// Creates a number from its big-endian representation, changing the byte order if
   /// necessary.
   ///
   /// - Parameters:
   ///   - bigEndian: A value to use as the big-endian representation of the new number.
   init(bigEndian: Self)

   /// Creates a number from its little-endian representation, changing the byte order if
   /// necessary.
   ///
   /// - Parameters:
   ///   - littleEndian: A value to use as the little-endian representation of the new number.
   init(littleEndian: Self)
}

extension BytesConstructibleNumber {
   public init(data: Data, endianness: Endianness = .big) {
      var data = data
      endianness.prepareBytes(in: &data, with: MemoryLayout<Self>.size)
      let value = data.withUnsafeBytes { pointer in
         pointer.load(as: Self.self)
      }
      switch endianness {
         case .big:
            self.init(bigEndian: value)
         case .little:
            self.init(littleEndian: value)
      }
   }

   /// Creates and returns a new instance of a number with a given parameters.
   ///
   /// If number of bytes exceeds type size, it truncates bytes in the beginning or end depending
   /// on endianness. In case of BE it takes last `MemoryLayout<Self>.size` bytes, and in case of LE
   /// it takes first `MemoryLayout<Self>.size` bytes.
   ///
   /// If number of bytes is less that `MemoryLayout<Self>.size`, it adds zero bytes in the
   /// beginning or end depending on endianness. In case of BE it adds bytes in the beginning, and
   /// in case of LE it adds bytes in the end.
   /// 
   /// - Parameters:
   ///   - data: An array of bytes that will be used to initialize a number.
   ///   - endianness: An endianness to be used to initialize a number. Defaults to `.big`.
   public init(bytes: [UInt8], endianness: Endianness = .big) {
      self.init(data: Data(bytes), endianness: endianness)
   }
}
