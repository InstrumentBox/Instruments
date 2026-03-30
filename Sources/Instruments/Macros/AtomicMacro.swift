//
//  AtomicMacro.swift
//
//  Copyright © 2026 Aleksei Zaikin.
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

/// Options that allow to modify storage variable of `@Atomic` property.
public struct AtomicOptions: OptionSet, Sendable {
   /// Raw value of an option.
   public var rawValue: Int

   // MARK: - Init
   
   /// Returns newly created object that describes an option.
   ///
   /// - Parameters:
   ///   - rawValue: Raw value of option
   public init(rawValue: Int) {
      self.rawValue = rawValue
   }

   // MARK: - Options
   
   /// Storage variable will use `weak` modifier. Applicable only with reference types.
   public static let `weak` = AtomicOptions(rawValue: 1 << 0)
}


/// Generates private variable and getter and setter that use `objc_sync_enter` and `objc_sync_exit`
/// to make read and write operations atomic.
///
/// Applicable to only variable declarations in classes, and doesn't make sense
/// if applied to constants, or variables in actors. Also it doesn't work in structs.
/// - Parameters:
///   - options: Options to modify variable storage. See ``AtomicOptions`` for more information.
@attached(peer, names: prefixed(__))
@attached(accessor, names: named(init), named(get), named(set))
public macro Atomic(_ options: AtomicOptions = []) = #externalMacro(module: "InstrumentsMacros", type: "AtomicMacro")
