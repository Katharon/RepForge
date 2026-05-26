# Folder Structure

Recommended Flutter structure after bootstrap:

```text
lib/
  main.dart
  app/
    app.dart
    composition/
      composition_root.dart
    navigation/
      app_router.dart
    theme/
      app_theme.dart
      design_tokens.dart
  features/
    exercise_catalog/
      domain/
        entities/
        value_objects/
        policies/
      application/
        ports/
        use_cases/
        read_models/
      data/
        drift/
        catalog_assets/
        mappers/
        repositories/
      presentation/
        cubit/
        screens/
        widgets/
    training_log/
      domain/
      application/
      data/
      presentation/
    analytics/
      domain/
      application/
      presentation/
    training_intelligence/
      domain/
      application/
      presentation/
    rest_timer/
      domain/
      application/
      data/
      presentation/
    settings/
      domain/
      application/
      data/
      presentation/
    entitlements/
    sync/
    wearables/
    social/
  shared/
    domain/
    application/
    data/
    presentation/

assets/
  catalog/
    catalog_manifest.json
    muscles_v1.json
    equipment_v1.json
    exercises_v2026_01.json
  icons/
  images/

test/
  features/
    exercise_catalog/
    training_log/
    analytics/
    training_intelligence/
  shared/

integration_test/
```

## Rule

Do not create empty folders for far-future features until a slice needs them. The structure above is the target shape, not a mandatory first commit.
