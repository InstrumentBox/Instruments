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

/// Defines a struct with a given raw value that is intended to be used as an enum with unknown
/// number of cases. Generates conformances to Codable, Equatable, and RawRepresentable protocols.
/// Requieres `RawValue` to conform to `Equatable` and `Codable`.
///
/// This enum is intended to be used when you don't know what cases you may receive from server and
/// you don't want your parser to return error, or if you need to know only about some specific
/// cases.
///
/// Let's say you have following API error structure:
/// ```json
/// {
///    "domain_code": Int
/// }
/// ```
/// so you can declare enum:
/// ```swift
/// @Enum<Int>
/// struct ErrorDomainCode {
///    static let someSpecificCodeYouNeed = ErrorDomainCode(-42)
///    static let anotherSpecificCodeYouNeed = ErrorDomainCode(-43)
/// }
/// ```
/// and error structure:
/// ```swift
/// struct MyAPIError: Error, Codable {
///    let domainCode: ErrorDomainCode
/// }
/// ```
/// and later somewhere in code:
/// ```swift
/// if error.domainCode == .someSpecificCodeYouNeed {
///    react(to: error)
/// }
/// ```
///
/// Now in cases when backend developers add new domain codes your parser won't return with error
/// and you can process error without magic numbers.
@attached(
   extension,
   conformances: Codable, Equatable, RawRepresentable,
   names:
      named(==),
      named(init(from:)),
      named(encode(to:)),
      named(RawValue),
      named(init(rawValue:))
)
@attached(member, names: named(rawValue), named(init(_:)))
public macro Enum<RawValue: Equatable & Codable>() = #externalMacro(module: "InstrumentsMacros", type: "EnumMacro")
