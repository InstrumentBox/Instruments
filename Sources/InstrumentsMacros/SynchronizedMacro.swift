//
//  SynchronizedMacro.swift
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

import SwiftSyntax
import SwiftSyntaxMacros

public struct SynchronizedMacro: BodyMacro {
   public static func expansion(
      of node: AttributeSyntax,
      providingBodyFor declaration: some DeclSyntaxProtocol & WithOptionalCodeBlockSyntax,
      in context: some MacroExpansionContext
   ) throws -> [CodeBlockItemSyntax] {
      guard let body = declaration.body, body.statements.count > 0 else {
         return []
      }

      return [
         CodeBlockItemSyntax("var __objc_sync_res = objc_sync_enter(self)"),
         CodeBlockItemSyntax("assert(__objc_sync_res == OBJC_SYNC_SUCCESS, \"Couldn't acquire lock on <\\(type(of: self)): \\(Unmanaged.passUnretained(self).toOpaque())>\")"),
         CodeBlockItemSyntax("defer {"),
         CodeBlockItemSyntax("__objc_sync_res = objc_sync_exit(self)"),
         CodeBlockItemSyntax("assert(__objc_sync_res == OBJC_SYNC_SUCCESS, \"Couldn't free lock on <\\(type(of: self)): \\(Unmanaged.passUnretained(self).toOpaque())>\")"),
         CodeBlockItemSyntax("}")
      ] + body.statements
   }
}
