//
//  EnumMacroTestCase.swift
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

#if canImport(InstrumentsMacros)

import InstrumentsMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

let testMacros: [String: any Macro.Type] = [
   "Enum": EnumMacro.self
]

// MARK: -

class EnumMacroTestCase: XCTestCase {
   func test_enumMacro_isExpandedSuccessfully() {
      assertMacroExpansion(
         """
         @Enum<String>
         struct Some {
         }
         """,
         expandedSource: """
         struct Some {

             let rawValue: RawValue

             init(_ rawValue: RawValue) {
                 self.rawValue = rawValue
             }
         }

         extension Some : Codable {
             init(from decoder: Decoder) throws {
                 let container = try decoder.singleValueContainer()
                 rawValue = try container.decode(String.self)
             }
             func encode(to encoder: Encoder) throws {
                 var container = encoder.singleValueContainer()
                 try container.encode(rawValue)
             }
         }

         extension Some : Equatable {
             static func == (lhs: Self, rhs: Self) -> Bool {
                 return lhs.rawValue == rhs.rawValue
             }
         }

         extension Some : RawRepresentable {
             typealias RawValue = String
             init?(rawValue: RawValue) {
                 self.rawValue = rawValue
             }
         }
         """,
         macros: testMacros
      )
   }

   func test_enumMacro_appliesPublicKeyword_ifStructIsPublic() {
      assertMacroExpansion(
         """
         @Enum<String>
         public struct Some {
         }
         """,
         expandedSource: """
         public struct Some {

             public let rawValue: RawValue

             public init(_ rawValue: RawValue) {
                 self.rawValue = rawValue
             }
         }

         extension Some : Codable {
             public init(from decoder: Decoder) throws {
                 let container = try decoder.singleValueContainer()
                 rawValue = try container.decode(String.self)
             }
             public func encode(to encoder: Encoder) throws {
                 var container = encoder.singleValueContainer()
                 try container.encode(rawValue)
             }
         }

         extension Some : Equatable {
             public static func == (lhs: Self, rhs: Self) -> Bool {
                 return lhs.rawValue == rhs.rawValue
             }
         }

         extension Some : RawRepresentable {
             public typealias RawValue = String
             public init?(rawValue: RawValue) {
                 self.rawValue = rawValue
             }
         }
         """,
         macros: testMacros
      )
   }

   func test_enumMacro_throwsError_ifAppliedToNotStruct() {
      assertMacroExpansion(
         """
         @Enum<String>
         class Some {
         }
         """,
         expandedSource: """
         class Some {
         }
         """,
         diagnostics: [
            DiagnosticSpec(message: "Enum macro is applicable only to structs", line: 1, column: 1),
            DiagnosticSpec(message: "Enum macro is applicable only to structs", line: 1, column: 1)
         ],
         macros: testMacros
      )
   }
}

#endif
