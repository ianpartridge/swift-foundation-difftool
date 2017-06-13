import CommandLineKit
import Darwin
import Foundation

let cli = CommandLineKit.CommandLine()

let clone = BoolOption(shortFlag: "c", longFlag: "clone", helpMessage: "Clone projects from GitHub")
let help = BoolOption(shortFlag: "h", longFlag: "help", helpMessage: "Prints a help message.")

cli.addOptions(clone, help)

do {
  try cli.parse()
} catch {
  cli.printUsage(error)
  exit(EX_USAGE)
}

if help.value {
  cli.printUsage()
  exit(EX_OK)
}

if clone.value {
  if shell("git", "clone", "--depth=1", "https://github.com/apple/swift") != 0 {
    print("Error cloning https://github.com/apple/swift")
    exit(EX_IOERR)
  }

  if shell("git", "clone", "--depth=1", "https://github.com/apple/swift-corelibs-foundation") != 0 {
    print("Error cloning https://github.com/apple/swift-corelibs-foundation")
    exit(EX_IOERR)
  }

  exit(EX_OK)
}

func directoriesExist(_ directories: [String]) -> Bool {
  let fileManager = FileManager.default

  for directory in directories {
    var isDirectory: ObjCBool = false
    let path = fileManager.currentDirectoryPath + "/" + directory
    if !fileManager.fileExists(atPath: path, isDirectory: &isDirectory) || !isDirectory.boolValue {
      print("Directory not found: " + path)
      return false
    }
  }
  return true
}

if !directoriesExist(["swift", "swift-corelibs-foundation"]) {
  exit(EX_IOERR)
}

