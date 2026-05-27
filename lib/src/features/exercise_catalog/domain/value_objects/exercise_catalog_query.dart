import '../exceptions/catalog_validation_exception.dart';
import 'catalog_tags.dart';
import 'catalog_validation.dart';

final class ExerciseCatalogQuery {
  ExerciseCatalogQuery({
    required this.limit,
    required this.offset,
    String? searchText,
    Iterable<EquipmentTag> equipment = const <EquipmentTag>[],
    Iterable<MuscleGroup> muscles = const <MuscleGroup>[],
  }) : searchText = _normalizeSearchText(searchText),
       equipment = List<EquipmentTag>.unmodifiable(equipment),
       muscles = List<MuscleGroup>.unmodifiable(muscles) {
    if (limit <= 0 || limit > 100) {
      throw const CatalogValidationException(
        'exerciseCatalogQuery.limit',
        'Limit must be between 1 and 100.',
      );
    }

    if (offset < 0) {
      throw const CatalogValidationException(
        'exerciseCatalogQuery.offset',
        'Offset must not be negative.',
      );
    }
  }

  final int limit;
  final int offset;
  final String? searchText;
  final List<EquipmentTag> equipment;
  final List<MuscleGroup> muscles;
}

String? _normalizeSearchText(String? value) {
  if (value == null) {
    return null;
  }

  final normalized = value.trim();
  return normalized.isEmpty ? null : requireCatalogText('searchText', value);
}
