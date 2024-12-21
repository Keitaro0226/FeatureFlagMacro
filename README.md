# FeatureFlagMacro

FeatureFlag is a Swift package that provides an easy and efficient way to manage feature flags in your application using **macros** introduced in Swift 5.9. This library allows developers to define feature flags as enums, persist their state with `UserDefaults`, and observe changes using Combine publishers.

## Features

- Declarative feature flag management using macros.
- Automatic integration with `UserDefaults` for state persistence.
- Combine-based `AnyPublisher` to observe feature flag changes.
- Swift 5.9 macro support for clean, boilerplate-free code generation.

## Requirements

- **Swift**: 5.9+
- **iOS**: 13.0+ / **macOS**: 10.15+ / **tvOS**: 13.0+ / **watchOS**: 6.0+
- **Xcode**: 15.0+

## Installation

### Swift Package Manager
Add the following to your `Package.swift`:

```swift
.package(url: "https://github.com/Keitaro0226/FeatureFlagMacro.git", from: "0.1.3")
```

Or add the repository URL directly to Xcode:

1. Go to **File > Add Packages**.
2. Enter `https://github.com/Keitaro0226/FeatureFlagMacro.git`.
3. Follow the prompts to add the package to your project.

## Usage

### 1. Import the Library

```swift
import Combine
import FeatureFlagMacro
```

### 2. Define a Feature Flag Enum

Annotate your enum with `@FeatureFlag` to automatically generate the necessary boilerplate for fetching, setting, and observing feature flags:

```swift
@FeatureFlag
@MainActor
public enum FeatureFlag: String, Codable {
    case enabled
    case disabled

    public static var defaultValue: Self { .disabled }
}
```

### 3. Set and Fetch Feature Flags

```swift
// Set the feature flag
FeatureFlag.set(.enabled)

// Fetch the current feature flag
let currentFlag = FeatureFlag.fetch()
print(currentFlag) // Output: enabled
```

### 4. Observe Feature Flag Changes

You can observe changes to the feature flag using Combine's `AnyPublisher`:

```swift
import Combine

@MainActor
final class RootScreenViewModel: ObservableObject {
    @Published var featureFlag: FeatureFlag = .disabled
    private var cancellables = Set<AnyCancellable>()

    public init() {
        bindFeatureFlagPublisher()
    }

    private func bindFeatureFlagPublisher() {
        FeatureFlag.publisher
            .assign(to: &$featureFlag)
    }
}
```

### 5. Use the Feature Flag in Your UI

You can now reactively update your UI based on the current feature flag:

```swift
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RootScreenViewModel()

    var body: some View {
        VStack {
            Text("Feature is \(viewModel.featureFlag.rawValue)")
        }
    }
}
```

## How It Works

When you annotate an enum with `@FeatureFlagMacro`, the following code is automatically generated:

- `fetch()` to retrieve the current feature flag value from `UserDefaults`.
- `set(_:)` to update the feature flag value and publish updates.
- A Combine publisher `publisher` to observe feature flag changes in real-time.

Example of generated code:

```swift
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
```

## Testing

FeatureFlag comes with unit tests for macro expansion and helper extensions.

Run the tests using Xcode or Swift Package Manager:

```bash
swift test
```

### Example Test for Macro Expansion

```swift
assertMacroExpansion(
    """
    @FeatureFlag
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
```

## Contributing

Contributions are welcome! If you'd like to improve **FeatureFlag**, please:

1. Fork the repository.
2. Create a new branch.
3. Make your changes.
4. Open a pull request.

Please include tests for any new functionality.

## License

FeatureFlag is available under the MIT License. See the [LICENSE](https://github.com/Keitaro0226/FeatureFlagMacro/blob/main/LICENSE.md) file for more details.

## Acknowledgments

This library leverages the power of Swift 5.9 macros to simplify feature flag management in Swift applications.
