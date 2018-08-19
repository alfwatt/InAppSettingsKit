import Foundation
import KitBridge

#if os(macOS)
NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
#elseif os(iOS)
let args = UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc))
UIApplicationMain(CommandLine.argc, args, nil, "SwiftSettingsDelegate")
#endif
