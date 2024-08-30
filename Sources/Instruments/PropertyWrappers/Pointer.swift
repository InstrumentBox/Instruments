//
//  Pointer.swift
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

/// `Pointer` is a property wrapper that allows you to work with classes and struct as they would be
/// pointed in the Objective-C.
///
/// It's may be used when you need to create or update reference to a value in some other class.
/// Let's take a look at following example:
///
/// ```swift
/// class A {
///    @Pointer
///    private var b: B?
///
///    init(b: Pointer<B?>) {
///       _b = b
///    }
///
///    func update(_ b: Pointer<B?>) {
///       b = B()
///    }
/// }
///
/// class C {
///    @Pointer
///    private var b: B?
///
///    func use() {
///       let a = A(b: $b)
///       a.update()
///       // b now is B() created in class A.
///    }
/// }
/// ```
@propertyWrapper
public class Pointer<Pointee> {
   /// Existing instance of pointee.
   public var pointee: Pointee

   // MARK: - Init
   
   /// Creates and returns new instance of `Pointer` property wrapper with a given initial value.
   ///
   /// - Parameters:
   ///   - wrappedValue: Initial value of pointee.
   public init(wrappedValue: Pointee) {
      pointee = wrappedValue
   }

   // MARK: - Property Wrapper
   
   /// Accessor and mutator of property wrapper that allows you work with `pointee` directly without
   /// typing `.pointee` each time you need to access pointer's value.
   public var wrappedValue: Pointee {
      get {
         pointee
      }
      set {
         pointee = newValue
      }
   }

   /// Returns self to be used as pointer. It's something like taking address using ampersand in the
   /// Objective-C.
   public var projectedValue: Pointer<Pointee> { self }
}
