//
//  LLDB.swift
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

import Darwin

public enum LLDB {
   public static func preventFromAttaching() {
      let PT_DENY_ATTACH: CInt = 31

      let handle = dlopen("/usr/lib/libc.dylib", RTLD_GLOBAL | RTLD_NOW)

      typealias PtraceFunc = @convention(c) (CInt, pid_t, pid_t, CInt) -> CInt
      let ptrace = unsafeBitCast(dlsym(handle, "ptrace"), to: PtraceFunc.self)

      errno = 0
      let result = ptrace(PT_DENY_ATTACH, 0, 0, 0)
      guard result == 0 else {
         fatalError("Can't prevent LLDB from attaching: \(String(cString: strerror(errno)))")
      }

      dlclose(handle)
   }

   public static func isAttached() -> Bool {
      var info = kinfo_proc()

      var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
      var size = MemoryLayout.stride(ofValue: info)

      errno = 0
      let junk = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
      guard junk == 0 else {
         fatalError("Can't check if LLDB attached: \(String(cString: strerror(errno)))")
      }

      return (info.kp_proc.p_flag & P_TRACED) != 0
   }
}
