//
//  EndiannessTests.swift
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

@testable
import Instruments

import Foundation
import Testing

@Suite("Endianness")
struct EndiannessTests {
   static let size = 4

   @Suite("Big")
   struct BigEndiannessTests {
      let endianness: Endianness = .big

      @Test("Doesn't append bytes")
      func doNotAddBytes() async throws {
         var data = Data([0x00, 0x01, 0x02, 0x03])
         endianness.prepareBytes(in: &data, with: size)
         #expect(data == Data([0x00, 0x01, 0x02, 0x03]))
      }

      @Test("Adds bytes in the beginning if less than size")
      func lessThanSize() async throws {
         var data = Data([0x01, 0x02, 0x03])
         endianness.prepareBytes(in: &data, with: size)
         #expect(data == Data([0x00, 0x01, 0x02, 0x03]))
      }

      @Test("Removes bytes in the beginning if greater than size")
      func greaterThanSize() async throws {
         var data = Data([0x00, 0x01, 0x02, 0x03, 0x04])
         endianness.prepareBytes(in: &data, with: size)
         #expect(data == Data([0x01, 0x02, 0x03, 0x04]))
      }
   }

   @Suite("Little")
   struct LittleEndiannessTests {
      let endianness: Endianness = .little

      @Test("Doesn't append bytes")
      func doNotAddBytes() async throws {
         var data = Data([0x00, 0x01, 0x02, 0x03])
         endianness.prepareBytes(in: &data, with: size)
         #expect(data == Data([0x00, 0x01, 0x02, 0x03]))
      }

      @Test("Adds bytes in the end if less than size")
      func lessThanSize() async throws {
         var data = Data([0x01, 0x02, 0x03])
         endianness.prepareBytes(in: &data, with: size)
         #expect(data == Data([0x01, 0x02, 0x03, 0x00]))
      }

      @Test("Removes bytes in the end if greater than size")
      func greaterThanSize() async throws {
         var data = Data([0x00, 0x01, 0x02, 0x03, 0x04])
         endianness.prepareBytes(in: &data, with: size)
         #expect(data == Data([0x00, 0x01, 0x02, 0x03]))
      }
   }
}
