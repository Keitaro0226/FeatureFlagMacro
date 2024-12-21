@attached(member, names: arbitrary)
public macro FeatureFlagMacro() = #externalMacro(module: "FeatureFlagMacroPlugin", type: "FeatureFlagMacro")
