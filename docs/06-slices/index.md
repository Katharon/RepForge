# Slice Index

Each slice is an incremental Codex task. Codex should implement exactly one slice per prompt unless the user explicitly says otherwise.

- [00 — Repository governance and docs baseline](slice_00_repository_governance_and_docs_baseline.md) — done
- [01 — Flutter project bootstrap](slice_01_flutter_project_bootstrap.md) — done
- [02 — Analysis options, formatting, test gates](slice_02_analysis_options_formatting_test_gates.md) — done
- [03 — Architecture skeleton and composition root](slice_03_architecture_skeleton_and_composition_root.md) — done
- [04 — Design tokens and app theme](slice_04_design_tokens_and_app_theme.md) — done
- [05 — Navigation shell and route map](slice_05_navigation_shell_and_route_map.md)
- [06 — Domain foundation for training log](slice_06_domain_foundation_for_training_log.md)
- [07 — Analytics formula domain tests](slice_07_analytics_formula_domain_tests.md)
- [08 — Drift local database foundation](slice_08_drift_local_database_foundation.md)
- [09 — Repository implementations and mappers](slice_09_repository_implementations_and_mappers.md)
- [10 — Dependency injection wiring](slice_10_dependency_injection_wiring.md)
- [11 — Exercise catalog feature](slice_11_exercise_catalog_feature.md)
- [12 — Workout groups and exercise assignment foundation](slice_12_workout_program_list_and_edit_foundation.md)
- [13 — Exercise detail set timeline](slice_13_exercise_detail_set_timeline.md)
- [14 — Add/edit workout set form](slice_14_add_edit_workout_set_form.md)
- [15 — Set labels and comments](slice_15_set_labels_and_comments.md)
- [16 — Rest timer domain and state](slice_16_rest_timer_domain_and_state.md)
- [17 — Local notifications for rest timer](slice_17_local_notifications_for_rest_timer.md)
- [18 — Exercise analytics use cases](slice_18_exercise_analytics_use_cases.md)
- [19 — Analytics charts and range selector UI](slice_19_analytics_charts_and_range_selector_ui.md)
- [20 — Estimated 1RM feature](slice_20_estimated_1rm_feature.md)
- [21 — Today dashboard](slice_21_today_dashboard.md)
- [22 — Settings and user profile foundation](slice_22_settings_foundation.md)
- [23 — Onboarding, initial groups, and bundled sample data](slice_23_onboarding_and_sample_data.md)
- [24 — Import/export local backup](slice_24_import_export_local_backup.md)
- [25 — Database migrations and data integrity hardening](slice_25_database_migrations_and_data_integrity_hardening.md)
- [26 — Search, filter, sort, and archive flows](slice_26_search_filter_sort_and_archive_flows.md)
- [27 — Accessibility and responsive layout pass](slice_27_accessibility_and_responsive_layout_pass.md)
- [28 — Golden tests and visual regression baseline](slice_28_golden_tests_and_visual_regression_baseline.md)
- [29 — Integration/E2E workout logging flow](slice_29_integration_e2e_workout_logging_flow.md)
- [30 — Security and privacy hardening](slice_30_security_and_privacy_hardening.md)
- [31 — Performance and large-history optimization](slice_31_performance_and_large_history_optimization.md)
- [32 — Entitlement domain and premium gates](slice_32_entitlement_domain_and_premium_gates.md)
- [33 — App-store purchase integration](slice_33_app_store_purchase_integration.md)
- [34 — Purchase verification strategy](slice_34_purchase_verification_strategy.md)
- [35 — Authentication abstraction](slice_35_authentication_abstraction.md)
- [36 — Firebase optional integration boundary](slice_36_firebase_optional_integration_boundary.md)
- [37 — Optional sync design spike and metadata](slice_37_cloud_sync_design_spike_and_metadata.md)
- [38 — Remote push notification boundary](slice_38_remote_push_notification_boundary.md)
- [39 — CI/CD release pipeline](slice_39_ci_cd_release_pipeline.md)
- [40 — App icon, splash, and store metadata](slice_40_app_icon_splash_and_store_metadata.md)
- [41 — Beta release candidate hardening](slice_41_beta_release_candidate_hardening.md)
- [42 — Production release checklist](slice_42_production_release_checklist.md)
- [43 — Official exercise catalog assets and importer](slice_43_official_catalog_assets_and_importer.md)
- [44 — User profile, focus, and equipment domain model](slice_44_user_profile_focus_equipment_model.md)
- [45 — Muscle activation model](slice_45_muscle_activation_model.md)
- [46 — Muscle balance detection](slice_46_muscle_balance_detection.md)
- [47 — Recovery and readiness check-ins](slice_47_recovery_readiness_checkins.md)
- [48 — Recommendation engine MVP](slice_48_recommendation_engine_mvp.md)
- [49 — Quick session mode](slice_49_quick_session_mode.md)
- [50 — Adaptive set suggestions and backoff logic](slice_50_adaptive_set_suggestions.md)
- [51 — Muscle load and balance dashboard](slice_51_muscle_load_dashboard.md)
- [52 — Catalog patch workflow and validation tooling](slice_52_catalog_patch_workflow.md)
- [53 — Wearable and calorie estimation design spike](slice_53_wearable_calorie_estimation_spike.md)
- [54 — Friends and social activity design](slice_54_social_friends_activity_design.md)

## Release rhythm

Create tags only at meaningful stability points, not after every slice.

- `v0.1.0` after Slice 10 architecture foundation.
- `v0.2.0` after Slice 23 local logging + groups + onboarding MVP.
- `v0.3.0` after Slice 31 hardened analytics/local app.
- `v0.4.0` after Slice 51 training intelligence and muscle dashboard MVP.
- `v0.9.0` beta candidate after release hardening.
- `v1.0.0` production release after store checklist.

## Catalog policy reminder

No slice may introduce a paid cloud database for the official exercise catalog. Use bundled versioned assets and local import.

## v5 slice planning notes

- Localization must be included in the early foundation slices. English fallback and German support should exist before significant UI work accumulates.
- MVP release target is after local tracker + groups + analytics, not after coach features.
- Equipment inventory should be modeled before recommendation features, even if the MVP only uses it for filtering.
- Payment slices remain post-MVP and should implement freemium/Premium entitlements, not a hard app-wide trial lockout.
- Catalog slices must validate equipment constraints and localized exercise names.


## v6 slice planning notes

- Slice 01 must use `RepForge` as app name.
- Slice 01/02 must include English and German localization foundation.
- Slice 08/11 must implement catalog import as JSON assets -> Drift, not hardcoded-only DB seed data.
- Payment, ads, Firebase, sync, and wearables remain outside MVP unless a later slice explicitly introduces them.
- Marketing/ASO documentation should be kept updated when UI screenshots and app store metadata become available.

- [55 — Legal compliance and resilience baseline](slice_55_legal_compliance_resilience_baseline.md)
- [56 — Data versioning and backward compatibility hardening](slice_56_data_versioning_backward_compatibility_hardening.md)

## v8 slice planning notes

- Add Slice 55 before production release if the legal/about/delete/export/privacy-baseline is not already complete.
- Compliance documentation must not justify adding cloud services. The default solution remains local-first and zero recurring infrastructure cost.
- Any future remote diagnostics, analytics, ads, cloud sync, wearable import, or AI/ML coach requires a dedicated slice and privacy/compliance documentation update before implementation.


## v9 slice planning notes

- Any slice that changes catalog, Drift schema, backup/export format, analytics formula storage, or native/sync contracts must preserve existing user data.
- Prefer additive changes, stable IDs, deprecation, replacement suggestions, and migration tests over destructive edits.
- Logged set history is sacred: users must never lose sessions because an official exercise was renamed, corrected, deprecated, or replaced.
