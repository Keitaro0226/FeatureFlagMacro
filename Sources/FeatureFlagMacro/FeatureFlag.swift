@attached(member, names: arbitrary)
public macro FeatureFlag() = #externalMacro(module: "FeatureFlagMacroPlugin", type: "FeatureFlagMacro")
