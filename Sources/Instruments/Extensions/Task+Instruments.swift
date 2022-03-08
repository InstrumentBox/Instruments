//
//  Task+Instruments.swift
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

import Foundation

extension Task where Failure == Error {
   @discardableResult
   public static func retrying(
      retriesCount: Int = 3,
      retryDelay: TimeInterval? = nil,
      priority: TaskPriority? = nil,
      operation: @Sendable @escaping () async throws -> Success
   ) -> Task {
      Task(priority: priority) {
         for _ in 0..<retriesCount {
            do {
               return try await operation()
            } catch {
               if let retryDelay = retryDelay {
                  let oneSecondInNanoseconds: TimeInterval = 1_000_000_000
                  let delay = UInt64(oneSecondInNanoseconds * retryDelay)
                  try await Task<Never, Never>.sleep(nanoseconds: delay)
               }
               try Task<Never, Never>.checkCancellation()
               continue
            }
         }

         try Task<Never, Never>.checkCancellation()
         return try await operation()
      }
   }
}
