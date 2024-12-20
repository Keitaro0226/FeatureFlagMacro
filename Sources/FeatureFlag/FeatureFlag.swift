@attached(member, names: arbitrary)
public macro FeatureFlagMacro() = #externalMacro(module: "FeatureFlagMacros", type: "FeatureFlagMacro")
