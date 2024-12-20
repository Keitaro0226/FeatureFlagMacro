
public extension String {
    var camelCased: String {
        let components = self.components(separatedBy: CharacterSet.alphanumerics.inverted)
        guard let first = components.first?.lowercased() else { return self }
        let rest = components.dropFirst().map { $0.capitalized }
        return ([first] + rest).joined()
    }
}
