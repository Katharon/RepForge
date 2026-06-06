import '../exceptions/catalog_validation_exception.dart';
import 'catalog_validation.dart';

enum CustomExerciseListSort { name, updatedAt }

final class CustomExerciseQuery {
  CustomExerciseQuery({
    required this.limit,
    required this.offset,
    String? searchText,
    this.includeArchived = false,
    this.sort = CustomExerciseListSort.name,
  }) : searchText = _normalizeSearchText(searchText) {
    if (limit <= 0 || limit > 100) {
      throw const CatalogValidationException(
        'customExerciseQuery.limit',
        'Limit must be between 1 and 100.',
      );
    }
    if (offset < 0) {
      throw const CatalogValidationException(
        'customExerciseQuery.offset',
        'Offset must not be negative.',
      );
    }
  }

  final int limit;
  final int offset;
  final String? searchText;
  final bool includeArchived;
  final CustomExerciseListSort sort;
}

String? _normalizeSearchText(String? value) {
  if (value == null) {
    return null;
  }
  final normalized = value.trim();
  return normalized.isEmpty ? null : requireCatalogText('searchText', value);
}
