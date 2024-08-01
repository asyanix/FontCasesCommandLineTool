//
//  CaseType.swift
//
//
//  Created by Асиет Чеуж on 01.08.2024.
//

import Foundation

public enum CaseType: String, Equatable, CaseIterable {

    /// **snake_case**
    ///
    /// Слова разделены символом подчеркивания, все буквы в нижнем регистре
    case snakeCase = "snake_case"

    /// **kebab-case**
    ///
    /// Слова разделены символом дефиса, все буквы в нижнем регистре
    case kebabCase = "kebab-case"

    /// **camelCase**
    ///
    /// Первое слово с маленькой буквы, а последующие слова начинаются с заглавной
    /// без пробелов или знаков пунктуации между словами
    case camelCase = "camelCase"

    /// **PascalCase**
    ///
    /// Все слова начинаются с заглавной буквы без пробелов или знаков пунктуации между словами
    case pascalCase = "PascalCase"

    /// **Train-Case**
    ///
    /// Слова разделены символом дефиса, все слова начинаются с заглавной буквы,
    /// только первая буква заглавная, остальные в нижнем регистре
    case trainCase = "Train-Case"

    /// **SCREAMING_SNAKE_CASE**
    ///
    /// Аналог **snake_case**, но все буквы в верхнем регистре
    case screamingSnakeCase = "SCREAMING_SNAKE_CASE"

    /// **dot.case**
    ///
    /// Все слова разделяются точками, все буквы в нижнем регистре
    case dotCase = "dot.case"

    /// **path/case**
    ///
    /// Слова разделяются символами слэша, как пути в файловой системе, все буквы в нижнем регистре
    case pathCase = "path/case"

    // MARK: - Properties

    public var separator: Character? {
        switch self {
        case .snakeCase, .screamingSnakeCase:
            "_"
        case .kebabCase, .trainCase:
            "-"
        case .dotCase:
            "."
        case .pathCase:
            "/"
        default:
            nil
        }
    }
}

/// Структура, описывающая характеристика всех case
public struct Properties: Equatable {
    var isSeparator: Character?
    var isUpperCase: Bool
    var isLowerCase: Bool
    var isFirstLetterCapitalized: Bool
    var isLetterSeparatorCapitalized: Bool
    
    init(_ isSeparator: Character? = nil, _ isUpperCase: Bool, _ isLowerCase: Bool, _ isFirstLetterCapitalized: Bool, _ isLetterSeparatorCapitalized: Bool) {
        self.isSeparator = isSeparator
        self.isUpperCase = isUpperCase
        self.isLowerCase = isLowerCase
        self.isFirstLetterCapitalized = isFirstLetterCapitalized
        self.isLetterSeparatorCapitalized = isLetterSeparatorCapitalized
    }
}

/// Характеристика каждого case
public let fontCasesProperties: [CaseType: Properties] = [
  .camelCase: Properties(nil, false, false, false, false),
  .pascalCase: Properties(nil, false, false, true, false),
  .snakeCase: Properties("_", false, true, false, false),
  .kebabCase: Properties("-", false, true, false, false),
  .screamingSnakeCase: Properties("_", true, false, true, true),
  .dotCase: Properties(".", false, true, false, false),
  .pathCase: Properties("/", false, true, false, false),
  .trainCase: Properties("-", false, false, true, true)
]
