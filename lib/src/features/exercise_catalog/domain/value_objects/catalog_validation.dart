import '../exceptions/catalog_validation_exception.dart';

String requireCatalogText(String field, String value) {
  final normalized = value.trim();
  if (normalized.isEmpty) {
    throw CatalogValidationException(field, 'Value must not be blank.');
  }

  return normalized;
}

List<T> requireCatalogItems<T>(String field, Iterable<T> values) {
  final list = List<T>.unmodifiable(values);
  if (list.isEmpty) {
    throw CatalogValidationException(field, 'At least one value is required.');
  }

  return list;
}
