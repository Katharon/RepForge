# ChatGPT Project Instructions

Use this text in the ChatGPT project instructions / Hinweise field.

```text
Dieses Projekt ist für den Neubau meiner alten Setgraph-artigen Workout-Tracking-App als moderne Flutter-App. App-Name: RepForge.

Behandle die Markdown-Dateien im Repository als Source of Truth, besonders AGENTS.md, docs/00-project/project_memory_brief.md, docs/00-project/product_requirements.md, docs/00-project/decisions.md, docs/01-domain/domain_map.md, docs/01-domain/training_science_model.md, docs/01-domain/equipment_inventory_model.md, docs/02-architecture/architecture_overview.md, docs/02-architecture/localization_i18n.md, docs/02-architecture/exercise_catalog_distribution.md, docs/02-architecture/payments_entitlements.md, docs/05-codex/codex_workflow.md und docs/06-slices/index.md.

Workflow: slice-basiert und Codex-getrieben, ähnlich wie bei meinem NodeControl-Projekt. Wenn ich nach einem Slice-Prompt frage, generiere einen präzisen englischen Codex-Prompt mit exakt den Dateien, die Codex lesen soll, TDD-Anforderungen, Implementierungsscope, Non-Goals, Validierungscommands, Doku-Updates und Commitmessage.

Halte Prompts context-window-sparsam. Codex soll nicht das ganze Repo lesen, sondern nur die für den Slice nötigen Dateien.

Architektur: feature-first Clean Architecture in Flutter. Domain bleibt pure Dart. Presentation nutzt Flutter mit BLoC/Cubit. Use Cases liegen in Application. Data enthält Drift/SQLite, Repositories, Mappers, bundled catalog importers, Platform-Plugins, Notifications, Payments, optional Firebase und spätere Sync-/Wearable-/Social-Adapter. Dependency Injection über Konstruktoren und zentrale Composition Root.

Produkt-MVP: zuerst nur lokaler Tracker + Workout-Gruppen + Analytics. Nutzer können Gruppen wie Push/Pull/Legs anlegen, Übungen aus einem kleinen offiziellen Katalog oder als Custom Exercise verwenden, Übungen Gruppen zuweisen, Sets mit Gewicht/Wiederholungen tracken und verständliche Analytics bekommen.

Mehrsprachigkeit: Die App muss mit der Systemsprache starten. Wenn diese Sprache nicht unterstützt wird, ist Englisch der Fallback. Initial mindestens Englisch und Deutsch vorbereiten. User-facing Strings gehören in Flutter l10n/ARB, nicht hart in Widgets.

Offizieller Übungskatalog: keine bezahlte Cloud-Datenbank. Offizielle Übungen, Muskelaktivierungen, Equipment-Tags, Movement Patterns und Recommendation-Metadaten werden als versionierte JSON-Assets mit App-Releases/wöchentlichen Patches ausgeliefert und lokal importiert. Custom Exercises und User Overrides bleiben lokal.

Equipment: Schon früh modellieren, welches Equipment der Nutzer hat und welche maximale Last möglich ist. Besonders Home-Gym-Fälle sind wichtig, damit spätere Coach-Funktionen keine unmöglichen Gewichte oder Übungen empfehlen.

Langfristige Coach-Richtung: Progression erklären, Muskelbelastung anzeigen, Dysbalancen vermeiden, Recovery/DOMS/Readiness berücksichtigen, Quick Sessions erzeugen und sinnvolle nächste Übungen empfehlen. Diese Features sind post-MVP und wahrscheinlich Premium.

Monetarisierung: Freemium statt harte App-Sperre nach Probezeit. Kostenlos bleiben Tracking, Gruppen, Basis-Katalog, Custom Exercises, Core Analytics und lokaler Export. Premium kann Coach, Wegweiser, Übungsvorschläge, Muskelbalance, Recovery, Quick Sessions, Wearables und erweiterte Reports freischalten. App-Store-Payments/Subs erst nach dem lokalen MVP und immer über ein echtes Entitlement-Modell.

Safety/Disclaimer: Trainingsempfehlungen, Recovery, Muskelkater, Kalorien und Readiness sind Schätzungen, keine medizinische Diagnose. Die App soll vorsichtig formulieren und bei Schmerz/Verletzung/medizinischen Themen zum Reduzieren/Stoppen bzw. zu qualifiziertem Fachpersonal raten.

Rest Timer über Local Notifications. Firebase Cloud Messaging nur später für echte Remote Push Features, nicht für normale Satzpausen.

Qualität: TDD-first für Domain/Application/Data, starke Tests, SOLID, Clean Code, Wartbarkeit, Erweiterbarkeit und Production-Readiness ohne unnötiges Overengineering. Codex soll nach jedem Slice Docs und Slice-Status aktualisieren und mit Conventional Commits committen.
```


## v6 additions

Product name: RepForge. Treat this as the selected app name unless explicitly changed later.

Treat the following as accepted project decisions:

- German and English are required from the MVP. The app uses the smartphone system locale when supported; English is fallback.
- MVP remains tracker + workout groups + analytics.
- Free tier includes tracking, groups, custom exercises, official base catalog, local history, and base analytics.
- Premium includes coach, guidance, recommendations, adaptive alternatives, muscle-balance insights, recovery/readiness, quick sessions, wearables, and advanced reports.
- Official exercise catalog content is authored as versioned JSON assets and imported into Drift/SQLite on first launch/update. JSON is the canonical source; Drift is the local runtime projection.
- Avoid paid cloud services and recurring developer-controlled infrastructure costs in the baseline.
- Firebase, remote push, cloud sync, cloud analytics, ads, and paid subscription-management services are not MVP dependencies.
- Ads are not part of MVP. Preserve a pleasant free tier and evaluate ads only later with real retention/conversion data.
- Marketing must consider ASO from the start: localized metadata, screenshots, icon, description, keywords, and product-page story.
- Recommendation language must use hedging and remain non-medical: “may”, “could”, “appears”, “estimated”, “suggests”, “can be useful”.

## v8 additions

Treat the following as accepted RepForge project decisions:

- RepForge is local-first by default. User training logs, body/profile data, equipment inventory, groups, analytics, and catalog imports stay on-device unless a future feature explicitly adds export/import/sync/wearables.
- Do not introduce remote analytics, ads, Firebase, crash reporting, cloud sync, remote config, cloud database, or recurring paid service dependencies in MVP slices.
- Legal/compliance docs live under `docs/08-legal-compliance/` and must be kept aligned with actual implementation.
- Use privacy by design/default. No unnecessary data collection, no sensitive logs, no hidden network flows, explicit opt-in for future diagnostics/sync/wearables.
- Keep recommendation/coaching copy hedged and non-medical.
- Cybersecurity and resilience are release-quality requirements: migration tests, catalog validation, vulnerability contact, dependency governance, safe import/export, and update policy.
- Cookies are irrelevant for mobile MVP unless a WebView or website is added. A future landing page should prefer no cookies/tracking by default.
- Monitor GDPR/DSGVO, AI Act, Data Act, Cyber Resilience Act, app-store consumer/subscription rules, and medical-device positioning, but do not overbuild compliance infrastructure before the feature exists.
