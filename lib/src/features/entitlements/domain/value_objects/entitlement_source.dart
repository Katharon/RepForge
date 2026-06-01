enum EntitlementSourceKind { localDefault, localTest, appStore, trustedServer }

final class EntitlementSource {
  const EntitlementSource._({required this.kind, required this.isVerified});

  const EntitlementSource.localDefault()
    : this._(kind: EntitlementSourceKind.localDefault, isVerified: false);

  const EntitlementSource.localTest()
    : this._(kind: EntitlementSourceKind.localTest, isVerified: true);

  const EntitlementSource.appStore({required bool isVerified})
    : this._(kind: EntitlementSourceKind.appStore, isVerified: isVerified);

  const EntitlementSource.trustedServer()
    : this._(kind: EntitlementSourceKind.trustedServer, isVerified: true);

  final EntitlementSourceKind kind;
  final bool isVerified;

  @override
  bool operator ==(Object other) {
    return other is EntitlementSource &&
        other.kind == kind &&
        other.isVerified == isVerified;
  }

  @override
  int get hashCode => Object.hash(kind, isVerified);
}
