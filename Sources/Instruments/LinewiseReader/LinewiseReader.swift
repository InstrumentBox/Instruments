//
//  LinewiseReader.swift
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

/// A reader that reads file line by line by using given delimiter.
public final class LinewiseReader {
   /// A delimiter to use to break lines. Defaults to `\n`.
   public var lineDelimiter = "\n"

   /// A number of bytes to read from file at once. Defaults to 10.
   public var chunkSize = 10

   /// Encoding of content of file. Defaults to `.utf8`.
   public var encoding: String.Encoding = .utf8

   private lazy var buffer = Data(capacity: chunkSize)
   private var isAtEOF = false

   private let fileHandle: FileHandle

   // MARK: - Init

   /// Creates and returns new instance of LinewiseReader with given parameters.
   ///
   /// - Parameters:
   ///   - fileURL: A URL where file to read can be found.
   public init?(fileURL: URL) {
      guard let fileHandle = try? FileHandle(forReadingFrom: fileURL) else {
         return nil
      }

      self.fileHandle = fileHandle
   }

   deinit {
      try? fileHandle.close()
   }

   // MARK: - Reading

   private var delimiterData: Data {
      lineDelimiter.data(using: encoding)!
   }

   /// Reads and returns next line from file.
   ///
   /// - Returns: Bytes representing line, or `nil` in case of EOF.
   public func readLine() -> Data? {
      if isAtEOF {
         return nil
      }

      repeat {
         if let range = buffer.range(of: delimiterData) {
            let subData = buffer.subdata(in: buffer.startIndex..<range.lowerBound)
            buffer = buffer[range.upperBound..<buffer.endIndex]
            return subData
         } else {
            let tempData = fileHandle.readData(ofLength: chunkSize)
            if tempData.count == 0 {
               isAtEOF = true
               return (buffer.count > 0) ? buffer : nil
            }
            buffer.append(tempData)
         }
      } while true
   }

   /// Reads and returns next line from file by converting it to string.
   ///
   /// - Returns: A read string, or nil if EOF or couldn't create string from bytes.
   public func readLine() -> String? {
      readLine().flatMap { String(data: $0, encoding: encoding) }
   }
}
