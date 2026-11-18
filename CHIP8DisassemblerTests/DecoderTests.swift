import XCTest
@testable import CHIP8Disassembler

final class DecoderTests: XCTestCase {

    func testClearScreen() {
        XCTAssertEqual(
            InstructionDecoder.decode(0x00E0),
            "CLS"
        )
    }

    func testReturn() {
        XCTAssertEqual(
            InstructionDecoder.decode(0x00EE),
            "RET"
        )
    }

    func testJump() {
        XCTAssertEqual(
            InstructionDecoder.decode(0x1200),
            "JP 0x200"
        )
    }

    func testLoadRegister() {
        XCTAssertEqual(
            InstructionDecoder.decode(0x6105),
            "LD V1, 0x05"
        )
    }

    func testAddition() {
        XCTAssertEqual(
            InstructionDecoder.decode(0x8124),
            "ADD V1, V2"
        )
    }

    func testUnknownInstruction() {
        XCTAssertEqual(
            InstructionDecoder.decode(0xFFFF),
            "UNKNOWN"
        )
    }

    func testHexadecimalRegister() {
        XCTAssertEqual(
            InstructionDecoder.decode(0x6A10),
            "LD VA, 0x10"
        )
    }

    func testDisassembly() throws {
        let bytes: [UInt8] = [
            0x00, 0xE0,
            0x61, 0x05,
            0x12, 0x00
        ]

        let result = try Disassembler.disassemble(bytes)

        XCTAssertEqual(
            result,
            """
            0200: 00E0    CLS
            0202: 6105    LD V1, 0x05
            0204: 1200    JP 0x200
            """
        )
    }

    func testIncompleteInstruction() {
        let bytes: [UInt8] = [0x61, 0x05, 0x12]

        XCTAssertThrowsError(
            try Disassembler.disassemble(bytes)
        )
    }

    func testEmptyROM() throws {
        let result = try Disassembler.disassemble([])
        XCTAssertEqual(result, "")
    }
}
