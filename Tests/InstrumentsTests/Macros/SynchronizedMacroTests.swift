//
//  SynchronizedMacroTests.swift
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
   "Synchronized": SynchronizedMacro.self
]

// MARK: -

@MainActor
@Suite("Synchronized macro")
struct SynchronizedMacroTests {
   @Test(
      "Is expanded successfully with body",
      .disabled("Testing macro expansion always succeed, at least in Xcode 26.3")
   )
   func expandSuccessfully() async throws {
      assertMacroExpansion(
         """
         @Synchronized
         func bar() {
             doAction()
             doAnotherAction()
         }
         """,
         expandedSource: """
         func bar() {
             var __objc_sync_res = objc_sync_enter(self)
             assert(__objc_sync_res == OBJC_SYNC_SUCCESS, "Couldn't acquire lock on <\\(type(of: self)): \\(Unmanaged.passUnretained(self).toOpaque())>")
             defer {
             __objc_sync_res = objc_sync_exit(self)
             assert(__objc_sync_res == OBJC_SYNC_SUCCESS, "Couldn't free lock on <\\(type(of: self)): \\(Unmanaged.passUnretained(self).toOpaque())>")
             }
             doAction()
             doAnotherAction()
         }
         """,
         macros: testMacros
      )
   }

   @Test(
      "Does nothing when body is empty",
      .disabled("Testing macro expansion always succeed, at least in Xcode 26.3")
   )
   func emptyBody() {
      assertMacroExpansion(
         """
         @Synchronized
         func bar() {
         }
         """,
         expandedSource: """
         func bar() {
         }
         """,
         macros: testMacros
      )
   }
}

#endif
