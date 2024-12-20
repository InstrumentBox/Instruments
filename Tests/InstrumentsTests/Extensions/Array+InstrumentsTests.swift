//
//  Array+InstrumentsTests.swift
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
import Testing

@Suite("Array + Instruments")
struct ArrayInstrumentsTests {
   @Test("Is batched if count is multiplied by batch size")
   func batchWithCountDivisibleByBatchSize() async throws {
      let array = [1, 2, 3, 4, 5, 6]
      let batched = array.batch(by: 3)
      let expected = [[1, 2, 3], [4, 5, 6]]
      #expect(batched == expected)
   }

   @Test("Is batched if count is not multiplied by batch size")
   func batchWithCountNotDivisibleByBatchSize() async throws {
      let array = [1, 2, 3, 4, 5]
      let batched = array.batch(by: 3)
      let expected = [[1, 2, 3], [4, 5]]
      #expect(batched == expected)
   }
}
