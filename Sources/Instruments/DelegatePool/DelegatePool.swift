//
//  DelegatePool.swift
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

import Foundation

/// An object that stores delegates in an array by using weak references to delegate. Each time you
/// iterate through delegates, it removes `nil` references from the array. Class is designed to be
/// thread safe.
///
/// To iterate through delegates you can use `for-in` or `forEach` syntax. In case of *DelegatePool
/// requires that any <MyDelegate> be a class type* error you may go following way:
/// ```swift
/// let delegates: DelegatePool<AnyObject> = []
/// for case let delegate as any <MyDelegate> in delegates {
///    delegate.myClassDidCompleteSomething(self)
/// }
/// ```
public class DelegatePool<Ref: AnyObject>: @unchecked Sendable, ExpressibleByArrayLiteral, Sequence {
   let lock = UnfairLock()
   var delegates: [Delegate]

   // MARK: - Init
   
   /// Creates and returns a new instance of `DelegatePool` with an empty array of delegates.
   public init() {
      delegates = []
   }

   /// Creates an instance initialized with the given elements.
   public required init(arrayLiteral elements: Ref...) {
      delegates = elements.map(Delegate.init)
   }

   // MARK: - Content
   
   /// Adds new reference to the array of delegates.
   ///
   /// - Parameters:
   ///   - delegate: A reference to store in the array.
   public func append(_ delegate: Ref) {
      lock.withLock {
         delegates.append(Delegate(ref: delegate))
      }
   }
   
   /// Removes a reference from an array of delegates if presented.
   ///
   /// - Parameters:
   ///   - delegate: A reference to remove from the array of delegates.
   public func remove(_ delegate: Ref) {
      lock.withLock {
         if let index = delegates.firstIndex(where: { $0.ref === delegate }) {
            delegates.remove(at: index)
         }
      }
   }

   // MARK: - Iteration

   /// Returns an iterator over the elements of this sequence.
   public func makeIterator() -> Iterator {
      Iterator(delegatePool: self)
   }
}
