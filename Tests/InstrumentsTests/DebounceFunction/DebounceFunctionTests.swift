//
//  DebounceFunctionTests.swift
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
import XCTest

@Suite("Debounce function")
struct DebounceFunctionTests {
   @Test("Invokes action after debounce interval")
   func invokeAfterDebounceInterval() async throws {
      let expectation = XCTestExpectation()
      let function = DebounceFunction<Void> {
         expectation.fulfill()
      }

      function(())

      await #expect(XCTWaiter.fulfillment(of: [expectation], timeout: 0.55) == .completed)
   }

   @Test("Doesn't invoke action if cancelled")
   func cancelFunction() async throws {
      let expectation = XCTestExpectation()
      let function = DebounceFunction<Void> {
         expectation.fulfill()
      }

      function(())
      function.cancel()

      await #expect(XCTWaiter.fulfillment(of: [expectation], timeout: 0.55) == .timedOut)
   }

   @Test("Doesn't invoke action earlier than debounce interval")
   func earlierThanInterval() async throws {
      let expectation = XCTestExpectation()
      let function = DebounceFunction<Void> {
         expectation.fulfill()
      }

      function(())

      await #expect(XCTWaiter.fulfillment(of: [expectation], timeout: 0.35) == .timedOut)
   }

   @Test("Invokes actions with latest argument")
   func invokeWithLatestArgument() async throws {
      let expectation = XCTestExpectation()
      var value: Int?
      let function = DebounceFunction<Int> {
         value = $0
         expectation.fulfill()
      }

      function(41)
      Task.detached {
         try await Task.sleep(nanoseconds: 300_000_000)
         function(42)
      }

      await #expect(XCTWaiter.fulfillment(of: [expectation], timeout: 0.85) == .completed)
      #expect(value == 42)
   }

   @Test("Fires action")
   func fireAction() async throws {
      var isInvoked = false
      let function = DebounceFunction<Void> {
         isInvoked = true
      }

      function.fire()

      #expect(isInvoked)
   }

   @Test("Files action even if already called")
   func callAndFireAction() async throws {
      var isInvoked = false
      let function = DebounceFunction<Void> {
         isInvoked = true
      }

      function(())
      function.fire()

      #expect(isInvoked)
   }

   @Test("Doesn't invoke action if deallocated")
   func deallocate() async throws {
      let expectation = XCTestExpectation()
      let keeper = FunctionKeeper(expectation: expectation)
      await keeper.function?(())

      Task.detached {
         try await Task.sleep(nanoseconds: 300_000_000)
         await keeper.cleanUp()
      }

      await #expect(XCTWaiter.fulfillment(of: [expectation], timeout: 0.55) == .timedOut)
   }
}

// MARK: -

actor FunctionKeeper {
   let expectation: XCTestExpectation

   init(expectation: XCTestExpectation) {
      self.expectation = expectation
   }

   lazy var function: DebounceFunction<Void>? = {
      DebounceFunction { [weak self] in
         self?.expectation.fulfill()
      }
   }()

   func cleanUp() {
      function = nil
   }
}
