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

import SwiftSyntax
import SwiftSyntaxMacros

public struct AtomicMacro: PeerMacro, AccessorMacro {
   public static func expansion(
      of node: AttributeSyntax,
      providingPeersOf declaration: some DeclSyntaxProtocol,
      in context: some MacroExpansionContext
   ) throws -> [DeclSyntax] {
      guard
         let b = declaration.as(VariableDeclSyntax.self)?.bindings.first,
         let varName = b.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
      else {
         return []
      }

      if let typeName = b.typeAnnotation?.type.as(IdentifierTypeSyntax.self)?.name.text {
         return [DeclSyntax("private var __\(raw: varName): \(raw: typeName)")]
      }

      if
         let optType = b.typeAnnotation?.type.as(OptionalTypeSyntax.self),
         let typeName = optType.wrappedType.as(IdentifierTypeSyntax.self)?.name.text
      {
         return [DeclSyntax("private var __\(raw: varName): \(raw: typeName)?")]
      }

      return []
   }

   public static func expansion(
      of node: AttributeSyntax,
      providingAccessorsOf declaration: some DeclSyntaxProtocol,
      in context: some MacroExpansionContext
   ) throws -> [AccessorDeclSyntax] {
      guard
         let b = declaration.as(VariableDeclSyntax.self)?.bindings.first,
         let varName = b.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
      else {
         return []
      }

      return [
         AccessorDeclSyntax(
         """
         @storageRestrictions(initializes: __\(raw: varName))
         init { __\(raw: varName) = newValue }
         """),
         AccessorDeclSyntax("""
         get {
            var __objc_sync_res = objc_sync_enter(self)
            assert(__objc_sync_res == OBJC_SYNC_SUCCESS, "Couldn't acquire lock on <\\(type(of: self)): \\(Unmanaged.passUnretained(self).toOpaque())>")
            let retVal = __\(raw: varName)
            __objc_sync_res = objc_sync_exit(self)
            assert(__objc_sync_res == OBJC_SYNC_SUCCESS, "Couldn't free lock on <\\(type(of: self)): \\(Unmanaged.passUnretained(self).toOpaque())>")
            return retVal
         }
         """),
         AccessorDeclSyntax("""
         set {
            var __objc_sync_res = objc_sync_enter(self)
            assert(__objc_sync_res == OBJC_SYNC_SUCCESS, "Couldn't acquire lock on <\\(type(of: self)): \\(Unmanaged.passUnretained(self).toOpaque())>")
            __\(raw: varName) = newValue
            __objc_sync_res = objc_sync_exit(self)
            assert(__objc_sync_res == OBJC_SYNC_SUCCESS, "Couldn't free lock on <\\(type(of: self)): \\(Unmanaged.passUnretained(self).toOpaque())>")
         }
         """)
      ]
   }
}
