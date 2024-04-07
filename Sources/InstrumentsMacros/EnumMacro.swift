//
//  EnumMacro.swift
//
//  Copyright © 2024 Aleksei Zaikin.
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

public enum EnumMacroError: Error, CustomStringConvertible {
   case structOnly

   // MARK: - CustomStringConvertible

   public var description: String {
      switch self {
         case .structOnly:
            return "Enum macro is applicable only to structs"
      }
   }
}

public struct EnumMacro: MemberMacro, ExtensionMacro {
   // MARK: - ExtensionMacro

   public static func expansion(
      of node: AttributeSyntax,
      attachedTo declaration: some DeclGroupSyntax,
      providingExtensionsOf type: some TypeSyntaxProtocol,
      conformingTo protocols: [TypeSyntax],
      in context: some MacroExpansionContext
   ) throws -> [ExtensionDeclSyntax] {
      guard let structDecl = declaration.as(StructDeclSyntax.self) else {
         throw EnumMacroError.structOnly
      }

      let publicKeyword = publicKeyword(declaration)

      let codableExtSyntax = try ExtensionDeclSyntax("extension \(structDecl.name): Codable") {
         try InitializerDeclSyntax("\(raw: publicKeyword)init(from decoder: Decoder) throws") {
            try VariableDeclSyntax("let container = try decoder.singleValueContainer()")
            ExprSyntax("rawValue = try container.decode(\(rawValueTypeName(from: node)).self)")
         }

         try FunctionDeclSyntax("\(raw: publicKeyword)func encode(to encoder: Encoder) throws") {
            try VariableDeclSyntax("var container = encoder.singleValueContainer()")
            ExprSyntax("try container.encode(rawValue)")
         }
      }

      let equatableExtSyntax = try ExtensionDeclSyntax("extension \(structDecl.name): Equatable") {
         try FunctionDeclSyntax("\(raw: publicKeyword)static func ==(lhs: Self, rhs: Self) -> Bool") {
            StmtSyntax("return lhs.rawValue == rhs.rawValue")
         }
      }

      let rawRepresentableSyntax = try ExtensionDeclSyntax("extension \(structDecl.name): RawRepresentable") {
         try TypeAliasDeclSyntax("\(raw: publicKeyword)typealias RawValue = \(rawValueTypeName(from: node))")
         try InitializerDeclSyntax("\(raw: publicKeyword)init?(rawValue: RawValue)") {
            ExprSyntax("self.rawValue = rawValue")
         }
      }

      return [codableExtSyntax, equatableExtSyntax, rawRepresentableSyntax]
   }

   // MARK: - MemberMacro

   public static func expansion(
      of node: AttributeSyntax,
      providingMembersOf declaration: some DeclGroupSyntax,
      in context: some MacroExpansionContext
   ) throws -> [DeclSyntax] {
      guard declaration.is(StructDeclSyntax.self) else {
         throw EnumMacroError.structOnly
      }

      let publicKeyword = publicKeyword(declaration)

      let rawValueDeclSyntax = try VariableDeclSyntax("\(raw: publicKeyword)let rawValue: RawValue")
      let initDeclSyntax = try InitializerDeclSyntax("\(raw: publicKeyword)init(_ rawValue: RawValue)") {
         ExprSyntax("self.rawValue = rawValue")
      }

      return [DeclSyntax(rawValueDeclSyntax), DeclSyntax(initDeclSyntax)]
   }

   // MARK: -

   private static func rawValueTypeName(from node: AttributeSyntax) -> TokenSyntax {
      let arguments = node.attributeName.as(IdentifierTypeSyntax.self)!.genericArgumentClause!.arguments
      return arguments.first!.argument.as(IdentifierTypeSyntax.self)!.name
   }

   private static func publicKeyword(_ decl: DeclGroupSyntax) -> String {
      if decl.modifiers.contains(where: { syntax in
         syntax.name.text == "public"
      }) {
         "public "
      } else {
         ""
      }
   }
}
