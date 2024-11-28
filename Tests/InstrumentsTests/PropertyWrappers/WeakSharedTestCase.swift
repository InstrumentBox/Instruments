//
//  WeakSharedTestCase.swift
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

class WeakSharedTestCase: XCTestCase {
   func test_weakShared_returnsTheSameObject_whenRefExists() {
      let provider = TestWeakSingletonProvider()
      let instance1 = provider.weakSingleton
      let instance2 = provider.weakSingleton
      XCTAssertTrue(instance1 === instance2)
   }

   func test_weakShared_returnsNewObject_whenRefNullified() throws {
      let provider = TestWeakSingletonProvider()
      var instance: TestWeakSingleton? = provider.weakSingleton
      instance?.value = 42

      XCTAssertEqual(instance?.value, 42)

      instance = nil
      instance = provider.weakSingleton

      XCTAssertNil(instance?.value)
   }
}

private class TestWeakSingletonProvider: @unchecked Sendable {
   @WeakShared(instance: TestWeakSingleton())
   var weakSingleton
}

private class TestWeakSingleton: @unchecked Sendable {
   var value: Int?
}
