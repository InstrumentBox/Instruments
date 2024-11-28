//
//  Endianness.swift
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

/// An order of bytes which can be either `BE` or `LE`.
public enum Endianness: Sendable {
   /// An order of bytes from the most significant to the least significant one.
   case big

   /// An order of bytes from the least significant to the most significant one.
   case little

   // MARK: - Bytes Alignment

   func prepareBytes(in data: inout Data, with size: Int) {
      if data.count <= size {
         let bytesToInsert = Data(repeating: 0x00, count: size - data.count)
         switch self {
            case .big:
               data.insert(contentsOf: bytesToInsert, at: 0)
            case .little:
               data.append(contentsOf: bytesToInsert)
         }
      } else {
         let bytesCountToRemove = data.count - size
         switch self {
            case .big:
               data = data.dropFirst(bytesCountToRemove)
            case .little:
               data = data.dropLast(bytesCountToRemove)
         }
      }
   }
}
