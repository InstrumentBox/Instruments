//
//  Timer.swift
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

extension Timer {
   enum State {
      case notRunning
      case running
   }
}

/// A timer that fires after a certain time interval has elapsed, invoking a specified action. Built
/// on top of `DispatchSourceTimer`.
public class Timer {
   private var timer: DispatchSourceTimer?

   private var state: State = .notRunning

   // MARK: -

   private let interval: TimeInterval
   private let repeats: Bool
   private let queue: DispatchQueue?
   private let action: () -> Void

   // MARK: - Init

   /// Initializes a timer object with the specified time interval and block.
   ///
   /// - Parameters:
   ///   - interval: The number of seconds between firings of the timer. If interval is less than or
   ///               equal to 0.0, this method chooses the nonnegative value of 0.0001 seconds
   ///               instead.
   ///   - repeats: If `true`, the timer will repeatedly reschedule itself until invalidated. If
   ///              `false`, the timer will be invalidated after it fires.
   ///   - queue: The `DispatchQueue` to which to execute action handler.
   ///   - action: An action to be executed when the timer fires. The action has neither parameters
   ///             nor return value.
   public init(
      interval: TimeInterval,
      repeats: Bool,
      queue: DispatchQueue? = nil,
      action: @escaping () -> Void
   ) {
      self.interval = max(interval, 0.0001)
      self.repeats = repeats
      self.queue = queue
      self.action = action
   }

   deinit {
      if timer == nil {
         return
      }

      // If the timer is suspended, calling cancel without resuming triggers a crash. This is
      // documented here https://forums.developer.apple.com/thread/15902
      timer?.setEventHandler { }
      resume()
      cancel()
   }

   // MARK: - Running

   /// Resumes the timer.
   public func resume() {
      guard state == .notRunning else {
         return
      }

      state = .running

      if timer == nil {
         timer = makeTimer()
      }

      timer?.resume()
   }

   /// Suspends the timer.
   public func suspend() {
      guard state == .running else {
         return
      }

      state = .notRunning
      timer?.suspend()
   }

   /// Asynchronously cancels the timer, preventing any further invocation of its action handler.
   public func cancel() {
      guard state == .running else {
         return
      }

      state = .notRunning
      timer?.cancel()
      timer = nil
   }

   // MARK: - Factory

   private func makeTimer() -> DispatchSourceTimer {
      let timer = DispatchSource.makeTimerSource(queue: queue)
      timer.setEventHandler { [weak self] in
         guard let self = self else {
            return
         }

         self.action()
         if !self.repeats {
            self.cancel()
         }
      }
      timer.schedule(
         deadline: .now() + interval,
         repeating: repeats ? .milliseconds(Int(interval * 1000.0)) : .never
      )
      return timer
   }
}
