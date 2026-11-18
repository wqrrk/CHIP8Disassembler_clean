import Foundation

enum ROMError: Error, LocalizedError {
    case emptyFile
    case invalidSize
    case fileTooLarge

    var errorDescription: String? {
        switch self {
        case .emptyFile:
            return "ROM file is empty"
        case .invalidSize:
            return "ROM contains an incomplete instruction"
        case .fileTooLarge:
            return "ROM exceeds CHIP-8 memory limits"
        }
    }
}

struct ROMLoader {

    static let maxROMSize = 4096 - 0x200

    static func load(from path: String) throws -> [UInt8] {
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)

        guard !data.isEmpty else {
            throw ROMError.emptyFile
        }

        guard data.count <= maxROMSize else {
            throw ROMError.fileTooLarge
        }

        guard data.count.isMultiple(of: 2) else {
            throw ROMError.invalidSize
        }

        return Array(data)
    }
}


extension ROMLoader {

    // D3: Force unwrap of missing value
    static func triggerNilError() {
        let configuration = [
            "format": "CHIP-8"
        ]

        let missingValue = configuration["memorySize"]

        print(missingValue!)
    }
}
