//
//  ExceptionCatchingTests.swift
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

@Suite("Exception catching")
struct ExceptionCatchingTests {
   @Test("Executes submitted block")
   func noException() async throws {
      var value: Int?
      try withCatchingException {
         value = 42
      }
      #expect(value == 42)
   }

   @Test("Catches exception if thrown")
   func catchException() async throws {
      let exReason = "Not 42"
      let ex = NSException(name: .genericException, reason: exReason)
      var value: Int?
      let error = #expect(throws: ExceptionError.self) {
         try withCatchingException {
            ex.raise()
            value = 43
         }
      }

      #expect(value == nil)
      #expect(error?.exception.name == .genericException)
      #expect(error?.exception.reason == exReason)
   }
}
