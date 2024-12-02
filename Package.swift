// swift-tools-version:6.0

//
//  Package.swift
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

import CompilerPluginSupport
import PackageDescription

let package = Package(
   name: "Instruments",
   platforms: [
      .iOS(.v13),
      .macOS(.v10_15),
      .macCatalyst(.v13),
      .tvOS(.v13),
      .watchOS(.v6)
   ],
   products: [
      .library(name: "Instruments", targets: ["Instruments"])
   ],
   dependencies: [
      .package(url: "https://github.com/apple/swift-syntax.git", from: "600.0.0")
   ],
   targets: [
      .target(name: "Instruments", dependencies: ["InstrumentsMacros"]),
      .macro(
         name: "InstrumentsMacros",
         dependencies: [
            .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
            .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
         ]
      ),
      .testTarget(
         name: "InstrumentsTests",
         dependencies: [
            "Instruments",
            "InstrumentsMacros",
            .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")
         ],
         resources: [
            .process("LineByLineReader/Data.txt")
         ]
      )
   ]
)
