import Combine
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(FeatureFlagMacros)
import FeatureFlagMacros

let testMacros: [String: Macro.Type] = [
    "FeatureFlagMacro": FeatureFlagMacro.self
]
#endif

final class FeatureFlagMacroTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []

    func test_CodeGenerationOfMacroIsAsExpected() throws {
#if canImport(FeatureFlagMacros)
        assertMacroExpansion(
        """
        @FeatureFlagMacro
        @MainActor
        enum FeatureFlag: String, Codable {
            case enabled
            case disabled
        
            public static var defaultValue: Self { .disabled }
        }
        """,
        expandedSource: """
        @MainActor
        enum FeatureFlag: String, Codable {
            case enabled
            case disabled
        
            public static var defaultValue: Self { .disabled }
        
            private static let subject = PassthroughSubject<FeatureFlag, Never>()
        
            public static var publisher: AnyPublisher<FeatureFlag, Never> {
                subject.eraseToAnyPublisher()
            }
        
            public static func fetch() -> FeatureFlag {
                let value = UserDefaults.standard.string(forKey: "featureflag")
                return FeatureFlag(rawValue: value ?? FeatureFlag.defaultValue.rawValue) ?? .defaultValue
            }
        
            public static func set(_ value: FeatureFlag) {
                UserDefaults.standard.set(value.rawValue, forKey: "featureflag")
                subject.send(value)
            }
        }
        """,
        macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
}
