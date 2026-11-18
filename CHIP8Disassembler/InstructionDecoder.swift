import Foundation

struct InstructionDecoder {

    static func decode(_ opcode: UInt16) -> String {
        let nnn = opcode & 0x0FFF
        let n = opcode & 0x000F
        let x = (opcode & 0x0F00) >> 8
        let y = (opcode & 0x00F0) >> 4
        let kk = opcode & 0x00FF

        func reg(_ value: UInt16) -> String {
            "V" + String(value, radix: 16).uppercased()
        }

        switch opcode & 0xF000 {

        case 0x0000:
            switch opcode {
            case 0x00E0:
                return "CLS"
            case 0x00EE:
                return "RET"
            default:
                return "SYS \(hex(nnn, 3))"
            }

        case 0x1000:
            return "JP \(hex(nnn, 3))"

        case 0x2000:
            return "CALL \(hex(nnn, 3))"

        case 0x3000:
            return "SE \(reg(x)), \(hex(kk, 2))"

        case 0x4000:
            return "SNE \(reg(x)), \(hex(kk, 2))"

        case 0x5000:
            return n == 0
                ? "SE \(reg(x)), \(reg(y))"
                : "UNKNOWN"

        case 0x6000:
            return "LD \(reg(x)), \(hex(kk, 2))"

        case 0x7000:
            return "ADD \(reg(x)), \(hex(kk, 2))"

        case 0x8000:
            switch n {
            case 0x0: return "LD \(reg(x)), \(reg(y))"
            case 0x1: return "OR \(reg(x)), \(reg(y))"
            case 0x2: return "AND \(reg(x)), \(reg(y))"
            case 0x3: return "XOR \(reg(x)), \(reg(y))"
            case 0x4: return "ADD \(reg(x)), \(reg(y))"
            case 0x5: return "SUB \(reg(x)), \(reg(y))"
            case 0x6: return "SHR \(reg(x))"
            case 0x7: return "SUBN \(reg(x)), \(reg(y))"
            case 0xE: return "SHL \(reg(x))"
            default: return "UNKNOWN"
            }

        case 0x9000:
            return n == 0
                ? "SNE \(reg(x)), \(reg(y))"
                : "UNKNOWN"

        case 0xA000:
            return "LD I, \(hex(nnn, 3))"

        case 0xB000:
            return "JP V0, \(hex(nnn, 3))"

        case 0xC000:
            return "RND \(reg(x)), \(hex(kk, 2))"

        case 0xD000:
            return "DRW \(reg(x)), \(reg(y)), \(n)"

        case 0xE000:
            switch kk {
            case 0x9E:
                return "SKP \(reg(x))"
            case 0xA1:
                return "SKNP \(reg(x))"
            default:
                return "UNKNOWN"
            }

        case 0xF000:
            switch kk {
            case 0x07: return "LD \(reg(x)), DT"
            case 0x0A: return "LD \(reg(x)), K"
            case 0x15: return "LD DT, \(reg(x))"
            case 0x18: return "LD ST, \(reg(x))"
            case 0x1E: return "ADD I, \(reg(x))"
            case 0x29: return "LD F, \(reg(x))"
            case 0x33: return "LD B, \(reg(x))"
            case 0x55: return "LD [I], \(reg(x))"
            case 0x65: return "LD \(reg(x)), [I]"
            default: return "UNKNOWN"
            }

        default:
            return "UNKNOWN"
        }
    }

    private static func hex(
        _ value: UInt16,
        _ width: Int
    ) -> String {
        let number = String(value, radix: 16).uppercased()
        let padding = String(
            repeating: "0",
            count: max(0, width - number.count)
        )

        return "0x" + padding + number
    }
}
