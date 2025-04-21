//
//  DelegatePoolTests.swift
//
//  Copyright © 2025 Aleksei Zaikin.
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

@Suite("Delegate pool")
struct DelegatePoolTests {
   private let delegates: DelegatePool<any Delegate> = []

   // MARK: - Tests

   @Test("Stores delegate in an array")
   func append() async throws {
      #expect(delegates.delegates.count == 0)

      let delegate = SpyDelegate()
      delegates.append(delegate)

      #expect(delegates.delegates.count == 1)
   }

   @Test("Still stores delegate wrapper in an array if nil reference until iteration")
   func storeUntilIteration() async throws {
      #expect(delegates.delegates.count == 0)

      delegates.append(SpyDelegate())

      #expect(delegates.delegates.count == 1)
   }

   @Test("Removes delegate from an array")
   func remove() async throws {
      #expect(delegates.delegates.count == 0)

      let delegate = SpyDelegate()
      delegates.append(delegate)

      #expect(delegates.delegates.count == 1)

      delegates.remove(delegate)

      #expect(delegates.delegates.count == 0)
   }

   @Test("Removes delegate from an array if exists")
   func removeWhenExists() async throws {
      #expect(delegates.delegates.count == 0)

      let delegate = SpyDelegate()
      delegates.append(delegate)

      #expect(delegates.delegates.count == 1)

      delegates.remove(SpyDelegate())

      #expect(delegates.delegates.count == 1)
   }

   @Test("Iterates through delegates")
   func iteration() async throws {
      var is1Called = false
      var is2Called = false

      let delegate1 = SpyDelegate()
      delegate1.didCompleteSomethingStub = {
         is1Called = true
      }

      let delegate2 = SpyDelegate()
      delegate2.didCompleteSomethingStub = {
         is2Called = true
      }

      delegates.append(delegate1)
      delegates.append(delegate2)

      for delegate in delegates {
         delegate.didCompleteSomething()
      }

      #expect(is1Called)
      #expect(is2Called)
   }

   @Test("Removes wrappers if nil references during iteration")
   func removeDuringIteration() async throws {
      var is1Called = false
      var is2Called = false
      var is3Called = false
      var is4Called = false
      var is5Called = false

      var delegate1: SpyDelegate? = SpyDelegate()
      delegate1?.didCompleteSomethingStub = {
         is1Called = true
      }

      let delegate2: SpyDelegate? = SpyDelegate()
      delegate2?.didCompleteSomethingStub = {
         is2Called = true
      }

      var delegate3: SpyDelegate? = SpyDelegate()
      delegate3?.didCompleteSomethingStub = {
         is3Called = true
      }

      let delegate4: SpyDelegate? = SpyDelegate()
      delegate4?.didCompleteSomethingStub = {
         is4Called = true
      }

      var delegate5: SpyDelegate? = SpyDelegate()
      delegate5?.didCompleteSomethingStub = {
         is5Called = true
      }

      if let delegate1 {
         delegates.append(delegate1)
      }

      if let delegate2 {
         delegates.append(delegate2)
      }

      if let delegate3 {
         delegates.append(delegate3)
      }

      if let delegate4 {
         delegates.append(delegate4)
      }

      if let delegate5 {
         delegates.append(delegate5)
      }

      delegate1 = nil
      delegate3 = nil
      delegate5 = nil

      #expect(delegates.delegates.count == 5)

      for delegate in delegates {
         delegate.didCompleteSomething()
      }

      #expect(!is1Called)
      #expect(is2Called)
      #expect(!is3Called)
      #expect(is4Called)
      #expect(!is5Called)

      #expect(delegates.delegates.count == 2)
   }
}

// MARK: -

@objc
private protocol Delegate {
   func didCompleteSomething()
}

class SpyDelegate: Delegate {
   var didCompleteSomethingStub: (() -> Void)?
   func didCompleteSomething() {
      didCompleteSomethingStub?()
   }
}
