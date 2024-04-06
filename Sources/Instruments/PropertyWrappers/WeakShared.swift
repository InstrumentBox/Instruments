//
//  WeakShared.swift
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

/// `WeakShared` is a property wrapper for references types that allow you to share the same
/// instance while reference exists. If there's no reference, the new object is created.
@propertyWrapper
public class WeakShared<Instance: AnyObject> {
   private weak var instance: Instance?
   private let instanceFactory: () -> Instance

   // MARK: - Init

   /// Creates and returns new instance of `WeakShared` property wrapper with a given instance
   /// factory.
   ///
   /// - Parameters:
   ///   - instanceFactory: A factory that is used to create new instance if there's no existing
   ///                      reference.
   public init(instanceFactory: @escaping () -> Instance) {
      self.instanceFactory = instanceFactory
   }

   /// Creates and returns new instance of `WeakShared` property wrapper with a given instance
   /// factory.
   ///
   /// - Parameters:
   ///   - instance: An auto closure that returns a newly created instance if there's no existing
   ///               reference.
   public convenience init(instance: @autoclosure @escaping () -> Instance) {
      self.init(instanceFactory: instance)
   }

   // MARK: - Property Wrapper

   /// Accessor that returns existing instance, or creates new one using instanceFactory passed to
   /// initializer.
   public var wrappedValue: Instance {
      if let instance = instance {
         return instance
      }

      let instance = instanceFactory()
      self.instance = instance
      return instance
   }
}
