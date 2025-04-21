//
//  DelegatePool.Iterator.swift
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

extension DelegatePool {
   /// An iterator that allows you to iterate through an array of delegates. It removes `nil`
   /// references during iteration.
   public class Iterator: @unchecked Sendable, IteratorProtocol {
      private var index: Int
      private let delegatePool: DelegatePool

      // MARK: - Init

      init(delegatePool: DelegatePool) {
         self.delegatePool = delegatePool
         index = delegatePool.lock.withLock {
            delegatePool.delegates.count - 1
         }
      }

      // MARK: - Iteration

      public func next() -> Ref? {
         delegatePool.lock.withLock {
            guard index >= 0 else {
               return nil
            }

            repeat {
               guard let delegate = delegatePool.delegates[index].ref else {
                  delegatePool.delegates.remove(at: index)
                  index -= 1
                  continue
               }

               index -= 1
               return delegate
            } while index >= 0

            return nil
         }
      }
   }
}
