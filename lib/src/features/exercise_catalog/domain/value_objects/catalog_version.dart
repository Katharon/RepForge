import 'catalog_validation.dart';

final class CatalogVersion {
  CatalogVersion(String value)
    : value = requireCatalogText('catalogVersion', value);

  final String value;

  @override
  bool operator ==(Object other) {
    return other is CatalogVersion && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
