//
//  BytesConstructibleNumberTestCase.swift
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

import Instruments
import XCTest

class BytesConstructibleNumberTestCase: XCTestCase {
   func test_int_isInitializedFromData_withBigEndianness() {
      let data = Data([0x00, 0x01])
      let value = Int(data: data, endianness: .big)
      XCTAssertEqual(value, 1)
   }

   func test_int_isInitializedFromData_withLittleEndianness() {
      let data = Data([0x00, 0x01])
      let value = Int(data: data, endianness: .little)
      XCTAssertEqual(value, 256)
   }

   func test_uint_isInitializedFromData_withBigEndianness() {
      let data = Data([0x00, 0x01])
      let value = UInt(data: data, endianness: .big)
      XCTAssertEqual(value, 1)
   }

   func test_uint_isInitializedFromData_withLittleEndianness() {
      let data = Data([0x00, 0x01])
      let value = UInt(data: data, endianness: .little)
      XCTAssertEqual(value, 256)
   }
}
