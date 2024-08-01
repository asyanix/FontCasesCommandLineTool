// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser

@main
struct FontCasesTool: ParsableCommand {
    @Argument(help: "The string that you want to process")
    private var input: String
    
    @Option(help: "The case that you want to convert the string to")
    private var fontCase: String?
    
    
    mutating func run() throws {
        print("The string that you want to process: \(input)")
        do
        {
            if fontCase == nil
            {
                let resultCaseType = try recognizeCase(input: input)
                print("The result: \(resultCaseType)")
            }
            else
            {
                if let selectedCase = CaseType(rawValue: fontCase!) {
                    let resultString = try convertCase(of: input, to: selectedCase)
                    print("The result: \(resultString)")
                }
                else
                {
                    print("FAIL: Unknown case type. Try again")
                }
            }
        }
        catch CaserError.unknownCaseType
        {
            print("FAIL: Unknown case type. Try again")
        }
        catch CaserError.extraSequencedSeparators(let separators)
        {
            print("FAIL: Extra sequenced separators: \(separators). Try again")
        }
        catch CaserError.multipleSeparators(let separators)
        {
            print("FAIL: Multiple separators: \(separators). Try again")
        }
        catch CaserError.uselessLeadingSeparator(let separatorError)
        {
            print("FAIL: Useless leading separator: \(separatorError). Try again")
        }
        catch CaserError.uselessTrailingSeparator(let separatorError)
        {
            print("FAIL: Useless trailing separator: \(separatorError). Try again")
        }
    }
    
    /// Функция, которая определяет тип кейса для входной строки
    public func recognizeCase(input: String) throws -> CaseType {
        let inputProperties = try identifyProperties(input)
        for (caseType, caseProperties) in fontCasesProperties {
            if caseProperties == inputProperties {
                return caseType
            }
        }
        throw CaserError.unknownCaseType
    }
    
    /// Функция, которая конвертирует строку в заданный кейс
    public func convertCase(of string: String, to targetCase: CaseType) throws -> String {
        let parseInputString = try parseString(string)
        var resultString = ""
        var capitalizedParseString: [String]
        switch targetCase {
        case .camelCase:
            capitalizedParseString = parseInputString.map { $0.capitalized }
            capitalizedParseString[0] = capitalizedParseString[0].lowercased()
        case .pascalCase, .trainCase:
            capitalizedParseString = parseInputString.map { $0.capitalized }
        case .screamingSnakeCase:
            capitalizedParseString = parseInputString.map { $0.uppercased() }
        default:
            capitalizedParseString = parseInputString.map { $0.lowercased() }
        }
        
        switch targetCase {
        case .camelCase, .pascalCase:
            resultString = capitalizedParseString.joined()
        default:
            if let separator = targetCase.separator {
                resultString = capitalizedParseString.joined(separator: String(separator))
            }
        }
        return resultString
    }
    
    /// Функция, которая определяет для входной строки свойства
    private func identifyProperties(_ input: String) throws -> Properties {
        guard !input.isEmpty && !input.contains(" ") else {
            throw CaserError.unknownCaseType
        }
        
        guard let firstCharacter = input.first, firstCharacter.isLetter else {
            throw CaserError.uselessLeadingSeparator(separator: input.first ?? " ")
        }
        
        guard let lastCharacter = input.last, lastCharacter.isLetter else {
            throw CaserError.uselessTrailingSeparator(separator: input.last ?? " ")
        }
        
        do {
            let separatorInput = try findSeparator(in: input)
            let isUpperCaseInput = input.uppercased() == input
            let isLowerCaseInput = input.lowercased() == input
            let isFirstLetterCapitalized = input.first?.isUppercase ?? false
            let isLetterSeparatorCapitalized = letterSeparator(separatorInput, input) // для train-case
            
            return Properties(separatorInput, isUpperCaseInput, isLowerCaseInput, isFirstLetterCapitalized, isLetterSeparatorCapitalized)
        }
    }
    
    /// Функция, которая определяет все ли буквы после разделителей заглавные
    private func letterSeparator(_ separator: Character?, _ input: String) -> Bool
    {
        guard separator != nil else {
            return false
        }
        for (ind, char) in input.enumerated() {
            if char == separator {
                let nextCharacterIndex = input.index(input.startIndex, offsetBy: ind + 1)
                guard input[nextCharacterIndex].isUppercase else {
                    return false
                }
            }
        }
        return true
    }

    /// Функция, которая находит разделитель для строки
    private func findSeparator(in input: String) throws -> Character? {
        var separatorCharacters: [Character] = []
        var extraSeparators: [String] = []
        var currentExtraString = ""

        for (ind, char) in input.enumerated() {
            if !char.isLetter {
                separatorCharacters.append(char)
                if input[input.index(input.startIndex, offsetBy: ind - 1)] == char {
                    currentExtraString += String(char)
                } else {
                    if currentExtraString.count > 1 {
                        extraSeparators.append(currentExtraString)
                    }
                    currentExtraString = String(char)
                }
            } else {
                if currentExtraString.count > 1 {
                    extraSeparators.append(currentExtraString)
                    currentExtraString = ""
                }
            }
        }

        if currentExtraString.count > 1 {
            extraSeparators.append(currentExtraString)
        }
        guard extraSeparators.isEmpty else {
            throw CaserError.extraSequencedSeparators(separators: extraSeparators)
        }
        guard Set(separatorCharacters).count < 2 else {
            throw CaserError.multipleSeparators(separators: separatorCharacters)
        }
        
        return separatorCharacters.first
    }

    /// Функция, которая разбивает строку на части
    private func parseString(_ string: String) throws -> [String] {
        let typeCase = try recognizeCase(input: string)
        var words = [String]()
        
        switch typeCase {
        case .camelCase, .pascalCase:
            var currentWord = ""
            for character in string {
                if character.isUppercase && !currentWord.isEmpty {
                    words.append(currentWord.lowercased())
                    currentWord = String(character)
                } else {
                    currentWord.append(character)
                }
            }
            if !currentWord.isEmpty {
                words.append(currentWord.lowercased())
            }
        default:
            if let separator = typeCase.separator {
                words = string.split(separator: separator).map { String($0).lowercased() }
            }
        }
        return words
    }
}
