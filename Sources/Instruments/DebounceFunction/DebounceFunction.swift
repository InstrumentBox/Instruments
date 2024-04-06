//
//  DebounceFunction.swift
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

/// A global configuration of `DebounceFunction`.
public enum DebounceFunctionConfiguration {
   /// A global debounce interval which is used as default value every time you create an instance
   /// of `DebounceFunction`. Defaults to `0.5`.
   public static var debounceInterval: TimeInterval = 0.5
}

/// A function that allows you to debounce some work. It invokes action after a certain amount time
/// if there's no new calls during this time. Can be called dynamically due to `@dynamicCallable`.
@dynamicCallable
public class DebounceFunction<Argument> {
   private var timer: Timer?

   private let debounceInterval: TimeInterval
   private let action: (Argument) -> Void

   // MARK: - Init

   /// Creates and returns a new instance of `DebounceFunction` with a given parameters.
   ///
   /// - Parameters:
   ///   - debounceInterval: An interval after which action is invoked. Defaults
   ///                       to `DebounceFunctionConfiguration.debounceInterval`.
   ///   - action: An action to be invoked after `debounceInterval` has elapsed.
   public init(
      debounceInterval: TimeInterval = DebounceFunctionConfiguration.debounceInterval,
      action: @escaping (Argument) -> Void
   ) {
      self.debounceInterval = debounceInterval
      self.action = action
   }

   deinit {
      cancel()
   }

   // MARK: - Cancellation

   /// Cancels the scheduled invocation of an action.
   public func cancel() {
      timer?.cancel()
      timer = nil
   }

   // MARK: - Calling

   /// Cancels previous call if possible and schedules new invocation of action after debounce
   /// interval.
   ///
   /// - Parameters:
   ///   - argument: Argument to pass to an action.
   public func call(with argument: Argument) {
      cancel()

      timer = Timer(interval: debounceInterval, repeats: false) { [weak self] in
         self?.action(argument)
      }
      timer?.resume()
   }

   /// Cancels previous call if possible and schedules new invocation of an action after debounce
   /// interval.
   public func call() where Argument == Void {
      call(with: ())
   }

   // MARK: - Firing

   /// Cancels previous call if possible and invokes action immediately.
   ///
   /// - Parameters:
   ///   - argument: Argument to pass to an action.
   public func fire(with argument: Argument) {
      cancel()
      action(argument)
   }

   /// Cancels previous call if possible and invokes action immediately.
   public func fire() where Argument == Void {
      fire(with: ())
   }

   // MARK: - Dynamic Callable

   /// Invokes `call(with:)` with the first passed argument. Adoption of `@dynamicCallable`.
   ///
   /// - Parameters:
   ///   - args: An array of arguments where the first argument will be passed to an action.
   public func dynamicallyCall(withArguments args: [Argument]) {
      if let arg = args.first {
         call(with: arg)
      }
   }
}
