//
//  String+InstrumentsTestCase.swift
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

class StringInstrumentsTestCase: XCTestCase {
   func test_string_isEncodedIntoBase64() {
      let encoded = "hello world".base64Encoded()
      XCTAssertEqual(encoded, "aGVsbG8gd29ybGQ=")
   }

   func test_string_isDecodedFromBase64() {
      let decoded = "aGVsbG8gd29ybGQ=".base64Decoded()
      XCTAssertEqual(decoded, "hello world")
   }

   func test_string_removesCharactersContainingInCharacterSet() {
      var string = "0h1e2l3l4o 5w6o7r8l9d"
      string.removeCharacters(in: .decimalDigits)
      XCTAssertEqual(string, "hello world")
   }

   func test_string_removesPrefix() {
      var string = "foo_bar_baz"
      string.removePrefix("foo_")
      XCTAssertEqual(string, "bar_baz")
   }
}
