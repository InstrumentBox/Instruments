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

public enum DebounceFunctionConfiguration {
   public static var debounceInterval: TimeInterval = 0.5
}

@dynamicCallable
public final class DebounceFunction<Argument> {
   private var timer: Timer?

   private let debounceInterval: TimeInterval
   private let action: (Argument) -> Void

   // MARK: - Init

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

   public func cancel() {
      timer?.cancel()
      timer = nil
   }

   // MARK: - Calling

   public func call(with argument: Argument) {
      cancel()

      timer = Timer(interval: debounceInterval, repeats: false) { [weak self] in
         self?.action(argument)
      }
      timer?.resume()
   }

   public func call() where Argument == Void {
      call(with: ())
   }

   // MARK: - Firing

   public func fire(with parameter: Argument) {
      cancel()
      action(parameter)
   }

   public func fire() where Argument == Void {
      fire(with: ())
   }

   // MARK: - Dynamic Callable

   public func dynamicallyCall(withArguments args: [Argument]) {
      if let arg = args.first {
         call(with: arg)
      }
   }
}
