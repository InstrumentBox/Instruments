//
//  JSONDecoder+IgnoringErrorsTests.swift
//
//  Copyright © 2026 Aleksei Zaikin.
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

@Suite("JSON decoder + Ignoring errors")
struct JSONDecoderIgnoringErrorsTests {
   private let decoder = JSONDecoder()

   // MARK: - Tests

   @Test("Returns complete array")
   func returnCompleteArray() throws {
      let jsonData = try #require("[1, 2, 3]".data(using: .utf8))

      let entities = try decoder.decodeArrayIgnoringErrors(of: Int.self, from: jsonData)

      #expect(entities.count == 3)
      #expect(entities[0] == 1)
      #expect(entities[1] == 2)
      #expect(entities[2] == 3)
   }

   @Test("Return array skipping object if couldn't decode one")
   func returnBySkipping() throws {
      let jsonData = try #require("[1, \"2\", 3]".data(using: .utf8))

      let entities = try decoder.decodeArrayIgnoringErrors(of: Int.self, from: jsonData)

      #expect(entities.count == 2)
      #expect(entities[0] == 1)
      #expect(entities[1] == 3)
   }

   @Test("Throws error if data corrupted")
   func returnEmptyArray() throws {
      let jsonData = try #require("[1, 2 3]".data(using: .utf8))

      #expect(throws: DecodingError.self) {
         try decoder.decodeArrayIgnoringErrors(of: Int.self, from: jsonData)
      }
   }
}
