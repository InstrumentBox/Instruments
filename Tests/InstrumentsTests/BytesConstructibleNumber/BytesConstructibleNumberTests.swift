//
//  BytesConstructibleNumberTestCases.swift
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
import Instruments
import Testing

@Suite("Bytes constructible number")
struct BytesConstructibleNumberTests {
   @Suite("Int")
   struct IntTests {
      @Test("Is initialized from data with big endianness")
      func bigEndianness() async throws {
         let data = Data([0x00, 0x01])
         let value = Int(data: data, endianness: .big)
         #expect(value == 1)
      }

      @Test("Is initialized from data with little endianness")
      func littleEndianness() async throws {
         let data = Data([0x00, 0x01])
         let value = Int(data: data, endianness: .little)
         #expect(value == 256)
      }
   }

   @Suite("UInt")
   struct UIntTests {
      @Test("Is initialized from data with big endianness")
      func bigEndianness() async throws {
         let data = Data([0x00, 0x01])
         let value = UInt(data: data, endianness: .big)
         #expect(value == 1)
      }

      @Test("Is initialized from data with little endianness")
      func littleEndianness() async throws {
         let data = Data([0x00, 0x01])
         let value = UInt(data: data, endianness: .little)
         #expect(value == 256)
      }
   }
}
