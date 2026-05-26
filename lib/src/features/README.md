# Features

Feature modules should follow the feature-first Clean Architecture shape when
they are introduced:

```text
feature_name/
  domain/
  application/
  data/
  presentation/
```

Create feature folders only when a slice implements that feature boundary.
