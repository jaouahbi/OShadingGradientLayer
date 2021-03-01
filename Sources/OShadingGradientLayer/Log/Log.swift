//
//    Copyright 2017 - Jorge Ouahbi
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//

//
//  Log.swift
//
//  Created by Jorge Ouahbi on 25/9/16.
//  Copyright © 2016 Jorge Ouahbi. All rights reserved.
//
import Foundation
import os.log

struct LogConfiguration {
    public static let logFilename: String = "trace.log"
    public static var details: LogDetails = [.crash]
     // Set the minimum log level. By default set to .info which is the minimum. Everything will be loged.
    public static var minimumLogLevel: LogLevel = .warn
}

/**
 Enumeration of the log levels
 */
public enum LogLevel: Int {
    // Make sure all log events goes to the device log
    case productionLogAll = -1
    // Trace loging, lowest level
    case trace = 0
    // Informational loging
    case info = 1
    // Debug loging, default level
    case debug = 2
    // Warning loging, You should take notice
    case warn = 3
    // Error loging, Something went wrong, take action
    case error = 4
    // Fatal loging, Something went seriously wrong, can't recover from it.
    case fatal = 5
    // Set the minimumLogLevel to .none to stop everything from loging
    case none = 6
    //static var minimumLogLevel: LogLevel = .none
    /**
     Get the emoticon for the log level.
     */
    public func description() -> String {
        switch self {
        case .info:
            return "✔️"
        case .trace:
            return "❕"
        case .debug:
            return "✳️"
        case .warn:
            return "⚠️"
        case .error:
            return "📛"
        case .fatal:
            return "🆘"
        case .productionLogAll:
            return "🚧"
        case .none:
            return ""
        }
    }
}
//TODO: (jom) complete this shit
// LogProtocol
public protocol LogProtocol {
    //    associatedtype DumpType
    //    associatedtype PrintType
    static func redirect(_ fileName: String)
    static func readLogFile(_ fileName: String) -> String
    //    static func dump(_ value: DumpType)
    //    static func print(_ object: PrintType, level: LogLevel, filename: String,
    //                         line: Int, funcname: String, trace: [String])
    static var dateFormatter: DateFormatter {get}
}
// TODO: (jom)  debugPrint
struct LogDetails: OptionSet {
    let rawValue: Int
    static let date     = LogDetails(rawValue: 1 << 0)
    static let process  = LogDetails(rawValue: 1 << 1)
    static let file     = LogDetails(rawValue: 1 << 2)
    static let crash  = LogDetails(rawValue: 1 << 3)
    static let all: LogDetails = [.date, .process, .file, .crash]
}

public protocol LogCrashProtocol {
    func recordError(error: NSError)
}
/**
 Extending the Stuff object with print functionality
 */
public class Log: LogProtocol {
    static var crash: LogCrashProtocol?
    /// Redirect Stderr to document folder
    /// - Parameter fileName: Filename
    public static func redirect(_ fileName: String) {
        let allPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = allPaths.first!
        let pathStringComponent = "/" + fileName
        let pathForLog = (documentsDirectory as NSString).appending(pathStringComponent)
        freopen(pathForLog.cString(using: String.Encoding.ascii)!, "a+", stdout)
        Log.print("Redicted logs to \(pathForLog)", .info)
        
    }
    public static func readLogFile(_ fileName: String) -> String {
        do {
            // get the documents folder url
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                // create the destination url for the text file to be saved
                let fileURL = documentDirectory.appendingPathComponent(fileName)
                // any posterior code goes here
                // reading from disk
                return try String(contentsOf: fileURL)
            }
        } catch let error {
            Log.print("readLogFile \(error)", .error)
        }
        return ""
    }
    /// Date formater
    public static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss:SSS"
        return dateFormatter
    }()
    /// Dumps the given object’s contents using its mirror to standard output.
    /// - Parameter value: Value to dump
    static func dump<T>(_ value: T) {
        Swift.dump(value)
    }
    //
    //  Build a  log text for writing to the output
    //  - Parameters:
    //  - object: T
    //  - level: LogLevel
    //  - filename:  #file
    //  - line:  #line
    //  - funcname: #function
#if !TEST_COVERAGE
  static func buildMessage<T>(_ object: T,
                              _ level: LogLevel = (T.self is Error.Type ? .error : .debug),
                              filename: String = #file, line: Int = #line, funcname: String = #function) -> String {
      let process = ProcessInfo.processInfo
      let threadId = Thread.current.name ?? ""
      let file = URL(string: filename)?.lastPathComponent ?? ""
      var output = "\(object)"                                // Output trace
      if let object = object as? Error {                      // Get the symbols only when exist a error.
          output = "\(object.localizedDescription)"
        //"\(GCDebugManager.formatStackSymbols(GCDebugManager.callStackAppSymbols))"
      }
      var logText: String
        if LogConfiguration.details.contains([.date, .process, .file]) {         // Check the detail level
          logText = """
          \n\(level.description()) .\(level)
          ⏱ \(dateFormatter.string(from: Foundation.Date()))
          📱 \(process.processName) [\(process.processIdentifier):\(threadId)]
          📂 \(file)(\(line))
          ⚙️ \(funcname)
          ➡️\r\t\(output)
          """
      } else if LogConfiguration.details.contains([.date, .process]) {
          logText = """
          \n\(level.description()) .\(level)
          ⏱ \(dateFormatter.string(from: Foundation.Date()))
          📱 \(process.processName) [\(process.processIdentifier):\(threadId)]
          ⚙️ \(funcname)
          ➡️\r\t\(output)
          """
      } else if LogConfiguration.details.contains([.date]) {
          logText = """
          \n\(level.description()) .\(level)
          ⏱ \(dateFormatter.string(from: Foundation.Date()))
          ⚙️ \(funcname)
          ➡️\r\t\(output)
          """
      } else  if LogConfiguration.details.contains([.process, .file]) {
          logText = """
          \n\(level.description()) .\(level)
          📱 \(process.processName) [\(process.processIdentifier):\(threadId)]
          📂 \(file)(\(line))
          ⚙️ \(funcname)
          ➡️\r\t\(output)
          """
      } else {
          logText = """
          \n\(level.description()) .\(level)
          ⚙️ \(funcname)
          ➡️\r\t\(output)
          """
      }
      return logText
  }
#endif
    ///
    /// The print command for writing to the output window
    /// - Parameters:
    /// - object: T
    /// - level: LogLevel
    /// - filename:  #file
    /// - line:  #line
    /// - funcname: #function
    ///
// TODO: check if we are in test.
#if TEST_COVERAGE
  static func print<T>(_ object: T,  _ level: LogLevel = .debug, filename: String = #file, line: Int = #line, funcname: String = #function) {
      NSLog(object)
  }
#else
   static func print<T>(_ object: T,
                        _ level: LogLevel = (T.self is Error.Type ? .error : .debug),
                        filename: String = #file,
                        line: Int = #line,
                        funcname: String = #function) {
       if level.rawValue >= LogConfiguration.minimumLogLevel.rawValue {
           let logText = buildMessage(object, level, filename: filename, line: line, funcname: funcname)
           // Report to Crashlytics the error
           if LogConfiguration.details.contains(.crash) && object is Error {
               if let err = object as? NSError {
                   //Crashlytics.sharedInstance().recordError(err)
                    Log.crash?.recordError(error: err)
               }
           }
           if LogConfiguration.minimumLogLevel == .productionLogAll || level == .productionLogAll {
               if #available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3, *) {
                   let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "GCLog")
                   // Parameters can be logged in two ways depending on the privacy level of the log.
                   // Private data can be logged using %{PRIVATE}@ and public data with %{PUBLIC}@.
                   os_log("%{PUBLIC}@", log: log, logText)
               } else {
                   NSLog("{GCLog} \(logText)")
               }
           } else {
                Swift.print(logText)
           }
       }
   }
#endif
}
