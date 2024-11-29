//
//  Task+InstrumentsTests.swift
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

@Suite("Task + Instruments")
struct TaskInstrumentsTests {
   @Test("Retries operation until success")
   func retryUntilSuccess() async throws {
      let service = Service(throwsError: false)
      let task = Task.retrying {
         try await service.operation()
      }
      let int = try await task.value
      #expect(int == 42)
   }

   @Test("Throws error if retries count exceeded")
   func exceedRetiresCount() async throws {
      let service = Service(throwsError: true)
      let task = Task.retrying {
         try await service.operation()
      }
      await #expect(throws: ServiceError.thrown) {
         try await task.value
      }
   }

   @Test("Throws cancelled error if cancelled")
   func cancelTask() async throws {
      let service = Service(throwsError: true)
      let task = Task.retrying(retryDelay: 1.0) {
         try await service.operation()
      }

      Task.detached {
         try await Task.sleep(nanoseconds: 500_000_000)
         task.cancel()
      }

      await #expect(throws: CancellationError.self) {
         try await task.value
      }
   }
}

// MARK: -

private enum ServiceError: Error {
   case thrown
}

private class Service: @unchecked Sendable {
   private var isErrorThrown = false
   private let throwsError: Bool

   init(throwsError: Bool) {
      self.throwsError = throwsError
   }

   func operation() async throws -> Int {
      if throwsError {
         throw ServiceError.thrown
      }

      if isErrorThrown {
         return 42
      }

      isErrorThrown = true
      throw ServiceError.thrown
   }
}
