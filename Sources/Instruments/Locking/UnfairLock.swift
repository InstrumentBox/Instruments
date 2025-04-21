//
//  UnfairLock.swift
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

/// Low-level lock that allows waiters to block efficiently on contention.
///
/// UnfairLock is an appropriate lock for cases where simple and lightweight mutual exclusion is
/// needed. It can be intrusively stored inline in a data structure without needing a separate
/// allocation, reducing memory consumption and cost of indirection. For situations where something
/// more sophisticated like condition waits or FIFO ordering is needed, use appropriate higher level
/// APIs such as those from the pthread or dispatch subsystems.
///
/// The values stored in the lock should be considered opaque and implementation defined, they
/// contain thread ownership information that the system may use to attempt to resolve priority
/// inversions.
///
/// This lock must be unlocked from the same thread that locked it, attempts to unlock from a
/// different thread will cause an assertion aborting the process.
///
/// This lock must not be accessed from multiple processes or threads via shared or multiply-mapped
/// memory, because the lock implementation relies on the address of the lock value and identity of
/// the owning process.
///
/// The name ‘unfair’ indicates that there is no attempt at enforcing acquisition fairness, e.g. an
/// unlocker can potentially immediately reacquire the lock before a woken up waiter gets an
/// opportunity to attempt to acquire the lock. This is often advantageous for performance reasons,
/// but also makes starvation of waiters a possibility.
///
/// This lock is suitable as a drop-in replacement for the deprecated OSSpinLock, providing much
/// better behavior under contention.
public final class UnfairLock: @unchecked Sendable, NSLocking {
   private var pLock: os_unfair_lock_t

   // MARK: - Init
   
   /// Creates and returns a new instance of `UnfairLock`.
   public init() {
      pLock = .allocate(capacity: 1)
      pLock.initialize(to: .init())
   }

   deinit {
      precondition(os_unfair_lock_trylock(pLock), "Unlock before destroying")
      os_unfair_lock_unlock(pLock)

      pLock.deinitialize(count: 1)
      pLock.deallocate()
   }

   // MARK: - Locking

   /// Locks an `UnfairLock`.
   public func lock() {
      os_unfair_lock_lock(pLock)
   }

   /// Unlocks an `UnfairLock`.
   public func unlock() {
      os_unfair_lock_unlock(pLock)
   }

   /// Locks an `UnfairLock` if it is not already locked.
   ///
   /// It is invalid to surround this function with a retry loop, if this function returns false,
   /// the program must be able to proceed without having acquired the lock, or it must call
   /// `lock()` directly (a retry loop around `try()` amounts to an inefficient implementation of `lock()`
   /// that hides the lock waiter from the system and prevents resolution of priority inversions).
   public func `try`() -> Bool {
      os_unfair_lock_trylock(pLock)
   }
   
   /// Executes given code by wrapping it with `lock()` and `unlock()` methods.
   ///
   /// - Parameters:
   ///   - body: A block with code to execute.
   /// - Returns: A result of executed code.
   public func withLock<Result>(_ body: () throws -> Result) rethrows -> Result {
      if !os_unfair_lock_trylock(pLock) {
         os_unfair_lock_lock(pLock)
      }

      defer {
         os_unfair_lock_unlock(pLock)
      }

      return try body()
   }
}
