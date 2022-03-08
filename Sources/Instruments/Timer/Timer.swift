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

public final class Timer {
   private var timer: DispatchSourceTimer?

   private var state: State = .notRunning

   private let interval: TimeInterval
   private let repeats: Bool
   private let queue: DispatchQueue?
   private let action: () -> Void

   // MARK: - Init

   public init(
      interval: TimeInterval,
      repeats: Bool,
      queue: DispatchQueue? = nil,
      action: @escaping () -> Void
   ) {
      self.interval = interval
      self.repeats = repeats
      self.queue = queue
      self.action = action
   }

   deinit {
      // If the timer is suspended, calling cancel without resuming triggers a crash. This is
      // documented here https://forums.developer.apple.com/thread/15902
      timer?.setEventHandler { }
      resume()
      cancel()
   }

   // MARK: - Running

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

   public func suspend() {
      guard state == .running else {
         return
      }

      state = .notRunning
      timer?.suspend()
   }

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
