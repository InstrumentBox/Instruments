//
//  HexStringDataDecoderTestCase.swift
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

class HexStringDataDecoderTestCase: XCTestCase {
   func test_hexStringDataDecoder_decodesFromHexString() throws {
      let decoder = HexStringDataDecoder()
      let data = try decoder.decode("abcdef01")
      XCTAssertEqual(data, Data([0xAB, 0xCD, 0xEF, 0x01]))
   }

   func test_hexStringDataDecoder_throwsError_ifUnexpectedByte() {
      let decoder = HexStringDataDecoder()
      do {
         _ = try decoder.decode("abcdeu01")
         XCTFail("Unexpected data decoded")
      } catch let error as HexStringDataDecoderError {
         XCTAssertEqual(error, .unexpectedByte("eu", location: 2))
      } catch {
         XCTFail("Unexpected error thrown \(error)")
      }
   }
}
