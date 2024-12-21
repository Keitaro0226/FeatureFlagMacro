import Combine
import FeatureFlagMacro
import Foundation

@FeatureFlagMacro
@MainActor
public enum FeatureFlag: String, Codable {
    case enabled
    case disabled

    public static var defaultValue: Self { .disabled }
}


FeatureFlag.set(.disabled)
let currentFlag = FeatureFlag.fetch()

FeatureFlag.set(.enabled)
let updatedFlag = FeatureFlag.fetch()

@MainActor
public final class RootScreenViewModel: ObservableObject {
    @Published var featureFlag: FeatureFlag = .disabled

    private var cancellables = Set<AnyCancellable>()

    @available(macOS 11.0, *)
    public init() {
        bindFeatureAccessManager()
    }

    @available(macOS 11.0, *)
    @MainActor
    private func bindFeatureAccessManager() {
        FeatureFlag.publisher
            .assign(to: &$featureFlag)
    }

    @MainActor
    private func fetchFeatureFlags() {
        featureFlag = FeatureFlag.fetch()
    }
}
