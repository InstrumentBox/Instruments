//
//  BinaryConstructible.swift
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

public protocol BinaryConstructible {
   init(data: Data, endianness: Endianness)

   init(bigEndian: Self)

   init(littleEndian: Self)
}

extension BinaryConstructible {
   public init(data: Data, endianness: Endianness) {
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

   public init(data: Data) {
      self.init(data: data, endianness: .big)
   }

   public init(bytes: [UInt8], endianness: Endianness = .big) {
      self.init(data: Data(bytes), endianness: endianness)
   }
}
