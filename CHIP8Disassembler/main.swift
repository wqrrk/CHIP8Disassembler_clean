import Foundation

func printUsage() {
    print("""
    CHIP-8 Disassembler

    Usage:
      CHIP8Disassembler <rom_file>
      CHIP8Disassembler <rom_file> --output <file>
      CHIP8Disassembler --help
    """)
}

let arguments = Array(CommandLine.arguments.dropFirst())

// Runtime fault experiments
if arguments.count == 2 && arguments[0] == "--fault" {

    switch arguments[1] {

    case "bounds":
        RuntimeFaults.triggerBoundsError()

    case "race":
        RuntimeFaults.triggerDataRace()

    case "nil":
        ROMLoader.triggerNilError()

    default:
        print("Unknown fault scenario")
        exit(EXIT_FAILURE)
    }

    exit(EXIT_SUCCESS)
}

if arguments == ["--help"] {
    printUsage()
    exit(EXIT_SUCCESS)
}

guard arguments.count == 1 ||
      (arguments.count == 3 && arguments[1] == "--output") else {
    printUsage()
    exit(EXIT_FAILURE)
}

let romPath = arguments[0]

do {
    let bytes = try ROMLoader.load(from: romPath)

    let result = try Disassembler.disassemble(bytes)

    if arguments.count == 3 {
        let outputPath = arguments[2]

        try result.write(
            toFile: outputPath,
            atomically: true,
            encoding: .utf8
        )

        print("Disassembly saved to: \(outputPath)")
    } else {
        print(result)
    }

} catch {
    fputs(
        "Error: \(error.localizedDescription)\n",
        stderr
    )
    exit(EXIT_FAILURE)
}
