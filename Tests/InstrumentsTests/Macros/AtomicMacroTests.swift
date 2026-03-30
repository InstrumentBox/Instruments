//
//  AtomicMacroTests.swift
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

#if canImport(InstrumentsMacros)

import InstrumentsMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing

@MainActor
private let testMacros: [String: any Macro.Type] = [
   "Atomic": AtomicMacro.self
]

// MARK: -

@MainActor
@Suite("Atomic macro")
struct AtomicMacroTests {
   @Test(
      "Is expanded successfully",
      .disabled("Testing macro expansion always succeed, at least in Xcode 26.3")
   )
   func expandSuccessfully() async throws {
      assertMacroExpansion(
         """
         @Atomic
         var foo: Int
         """,
         expandedSource: """
         var foo: Int {
         {
             @storageRestrictions(initializes: __foo)
             init {
                 __foo = newValue
             }
             get {
                var __objc_sync_res = objc_sync_enter(self)
                assert(__objc_sync_res == OBJC_SYNC_SUCCESS, "Couldn't acquire lock on <\\(type(of: self)): \\(Unmanaged.passUnretained(self).toOpaque())>")
                let retVal = __foo
                __objc_sync_res = objc_sync_exit(self)
                assert(__objc_sync_res == OBJC_SYNC_SUCCESS, "Couldn't free lock on <\\(type(of: self)): \\(Unmanaged.passUnretained(self).toOpaque())>")
                return retVal
             }
             set {
                var __objc_sync_res = objc_sync_enter(self)
                assert(__objc_sync_res == OBJC_SYNC_SUCCESS, "Couldn't acquire lock on <\\(type(of: self)): \\(Unmanaged.passUnretained(self).toOpaque())>")
                __foo = newValue
                __objc_sync_res = objc_sync_exit(self)
                assert(__objc_sync_res == OBJC_SYNC_SUCCESS, "Couldn't free lock on <\\(type(of: self)): \\(Unmanaged.passUnretained(self).toOpaque())>")
             }
         }
         private var __foo: Int
         """,
         macros: testMacros
      )
   }

   @Test(
      "Is expanded successfully for optional type",
      .disabled("Testing macro expansion always succeed, at least in Xcode 26.3")
   )
   func expandForOptional() async throws {
      assertMacroExpansion(
         """
         @Atomic
         var foo: Int?
         """,
         expandedSource: """
         var foo: Int? {
         {
             @storageRestrictions(initializes: __foo)
             init {
                 __foo = newValue
             }
             get {
                var __objc_sync_res = objc_sync_enter(self)
                assert(__objc_sync_res == OBJC_SYNC_SUCCESS, "Couldn't acquire lock on <\\(type(of: self)): \\(Unmanaged.passUnretained(self).toOpaque())>")
                let retVal = __foo
                __objc_sync_res = objc_sync_exit(self)
                assert(__objc_sync_res == OBJC_SYNC_SUCCESS, "Couldn't free lock on <\\(type(of: self)): \\(Unmanaged.passUnretained(self).toOpaque())>")
                return retVal
             }
             set {
                var __objc_sync_res = objc_sync_enter(self)
                assert(__objc_sync_res == OBJC_SYNC_SUCCESS, "Couldn't acquire lock on <\\(type(of: self)): \\(Unmanaged.passUnretained(self).toOpaque())>")
                __foo = newValue
                __objc_sync_res = objc_sync_exit(self)
                assert(__objc_sync_res == OBJC_SYNC_SUCCESS, "Couldn't free lock on <\\(type(of: self)): \\(Unmanaged.passUnretained(self).toOpaque())>")
             }
         }
         private var __foo: Int?
         """,
         macros: testMacros
      )
   }

   @Test(
      "Is expanded successfully with weak option",
      .disabled("Testing macro expansion always succeed, at least in Xcode 26.3")
   )
   func expandWeak() async throws {
      assertMacroExpansion(
         """
         @Atomic(.weak)
         var foo: NSObject?
         """,
         expandedSource: """
         var foo: NSObject? {
         {
             @storageRestrictions(initializes: __foo)
             init {
                 __foo = newValue
             }
             get {
                var __objc_sync_res = objc_sync_enter(self)
                assert(__objc_sync_res == OBJC_SYNC_SUCCESS, "Couldn't acquire lock on <\\(type(of: self)): \\(Unmanaged.passUnretained(self).toOpaque())>")
                let retVal = __foo
                __objc_sync_res = objc_sync_exit(self)
                assert(__objc_sync_res == OBJC_SYNC_SUCCESS, "Couldn't free lock on <\\(type(of: self)): \\(Unmanaged.passUnretained(self).toOpaque())>")
                return retVal
             }
             set {
                var __objc_sync_res = objc_sync_enter(self)
                assert(__objc_sync_res == OBJC_SYNC_SUCCESS, "Couldn't acquire lock on <\\(type(of: self)): \\(Unmanaged.passUnretained(self).toOpaque())>")
                __foo = newValue
                __objc_sync_res = objc_sync_exit(self)
                assert(__objc_sync_res == OBJC_SYNC_SUCCESS, "Couldn't free lock on <\\(type(of: self)): \\(Unmanaged.passUnretained(self).toOpaque())>")
             }
         }
         private weak var __foo: NSObject?
         """,
         macros: testMacros
      )
   }

   @Test(
      "Is expanded successfully with initialized variable",
      .disabled("Testing macro expansion always succeed, at least in Xcode 26.3")
   )
   func expandWithInitialValue() async throws {
      assertMacroExpansion(
         """
         @Atomic
         var foo: Int = 42
         """,
         expandedSource: """
         var foo: Int = 42 {
         {
             @storageRestrictions(initializes: __foo)
             init {
                 __foo = newValue
             }
             get {
                var __objc_sync_res = objc_sync_enter(self)
                assert(__objc_sync_res == OBJC_SYNC_SUCCESS, "Couldn't acquire lock on <\\(type(of: self)): \\(Unmanaged.passUnretained(self).toOpaque())>")
                let retVal = __foo
                __objc_sync_res = objc_sync_exit(self)
                assert(__objc_sync_res == OBJC_SYNC_SUCCESS, "Couldn't free lock on <\\(type(of: self)): \\(Unmanaged.passUnretained(self).toOpaque())>")
                return retVal
             }
             set {
                var __objc_sync_res = objc_sync_enter(self)
                assert(__objc_sync_res == OBJC_SYNC_SUCCESS, "Couldn't acquire lock on <\\(type(of: self)): \\(Unmanaged.passUnretained(self).toOpaque())>")
                __foo = newValue
                __objc_sync_res = objc_sync_exit(self)
                assert(__objc_sync_res == OBJC_SYNC_SUCCESS, "Couldn't free lock on <\\(type(of: self)): \\(Unmanaged.passUnretained(self).toOpaque())>")
             }
         }
         private var __foo: Int
         """,
         macros: testMacros
      )
   }
}

#endif
