final class FormulaIdentity {
  const FormulaIdentity({required this.name, required this.version})
    : assert(name.length > 0, 'Formula name must not be empty.'),
      assert(version > 0, 'Formula version must be positive.');

  final String name;
  final int version;

  @override
  bool operator ==(Object other) {
    return other is FormulaIdentity &&
        other.name == name &&
        other.version == version;
  }

  @override
  int get hashCode => Object.hash(name, version);

  @override
  String toString() => '$name/v$version';
}
