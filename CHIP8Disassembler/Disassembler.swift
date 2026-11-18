import Foundation

enum DisassemblerError: Error, LocalizedError {
    case incompleteInstruction

    var errorDescription: String? {
        "Input contains an incomplete CHIP-8 instruction"
    }
}

struct Disassembler {

    static let startAddress = 0x200

    static func disassemble(
        _ bytes: [UInt8]
    ) throws -> String {

        guard bytes.count.isMultiple(of: 2) else {
            throw DisassemblerError.incompleteInstruction
        }

        var lines: [String] = []

        for index in stride(
            from: 0,
            to: bytes.count,
            by: 2
        ) {
            let highByte = UInt16(bytes[index])
            let lowByte = UInt16(bytes[index + 1])

            let opcode = (highByte << 8) | lowByte
            let address = startAddress + index

            let instruction = InstructionDecoder.decode(opcode)

            let line = String(
                format: "%04X: %04X    %@",
                address,
                opcode,
                instruction
            )

            lines.append(line)
        }

        return lines.joined(separator: "\n")
    }
}

//добавим D1 и D2
import Dispatch

enum RuntimeFaults {

    // D1: Out-of-bounds array access
    static func triggerBoundsError() {
        let bytes: [UInt8] = [0x00, 0xE0]

        let invalidIndex = bytes.count
        print(bytes[invalidIndex])
    }

    // D2: Shared mutable state without synchronization
    final class UnsafeCounter: @unchecked Sendable {
        var value = 0
    }

    static func triggerDataRace() {
        let counter = UnsafeCounter()

        DispatchQueue.concurrentPerform(iterations: 100_000) { _ in
            counter.value += 1
        }

        print("Counter: \(counter.value)")
    }
}
