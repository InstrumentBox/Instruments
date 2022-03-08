//
//  DebounceFunctionTestCase.swift
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

final class DebounceFunctionTestCase: XCTestCase {
   func test_debounceFunction_invokesActionAfterDebounceInterval() {
      let expectation = XCTestExpectation()
      let function = DebounceFunction<Void> {
         expectation.fulfill()
      }

      function(())

      XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: 0.55), .completed)
   }

   func test_debounceFunction_doesNotInvokeAction_ifCancelled() {
      let expectation = XCTestExpectation()
      let function = DebounceFunction<Void> {
         expectation.fulfill()
      }

      function(())
      function.cancel()

      XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: 0.55), .timedOut)
   }

   func test_debounceFunction_doesNotInvokeActionEarlierThanDebounceInterval() {
      let expectation = XCTestExpectation()
      let function = DebounceFunction<Void> {
         expectation.fulfill()
      }

      function(())

      XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: 0.45), .timedOut)
   }

   func test_debounceFunction_invokesActionWithLatestArgument() {
      let expectation = XCTestExpectation()
      var value: Int?
      let function = DebounceFunction<Int> {
         value = $0
         expectation.fulfill()
      }

      function(41)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
         function(42)
      }

      XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: 0.85), .completed)
      XCTAssertEqual(value, 42)
   }

   func test_debounceFunction_firesActionImmediately() {
      var isInvoked = false
      let function = DebounceFunction<Void> {
         isInvoked = true
      }

      function.fire(with: ())

      XCTAssertTrue(isInvoked)
   }

   func test_debounceFunction_firesActionImmediately_ifAlreadyCalled() {
      var isInvoked = false
      let function = DebounceFunction<Void> {
         isInvoked = true
      }

      function(())
      function.fire(with: ())

      XCTAssertTrue(isInvoked)
   }

   func test_debounceFunction_doesNotInvokedAction_ifDeallocated() {
      let expectation = XCTestExpectation()
      var function: DebounceFunction<Void>? = DebounceFunction {
         expectation.fulfill()
      }

      function?(())
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
         function = nil
      }

      XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: 0.55), .timedOut)
   }
}
