import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct FeatureFlagMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            throw MacroExpansionErrorMessage("FeatureFlagMacro can only be applied to enums")
        }

        let enumName = enumDecl.name.text

        let generatedCode = """
        private static let subject = PassthroughSubject<\(enumName), Never>()
        
        public static var publisher: AnyPublisher<\(enumName), Never> {
            subject.eraseToAnyPublisher()
        }
        
        public static func fetch() -> \(enumName) {
            let value = UserDefaults.standard.string(forKey: "\(enumName.camelCased)")
            return \(enumName)(rawValue: value ?? \(enumName).defaultValue.rawValue) ?? .defaultValue
        }
        
        public static func set(_ value: \(enumName)) {
            UserDefaults.standard.set(value.rawValue, forKey: "\(enumName.camelCased)")
            subject.send(value)
        }
        
        """

        return [DeclSyntax(stringLiteral: generatedCode)]
    }
}

@main
struct FeatureFlagPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        FeatureFlagMacro.self,
    ]
}
