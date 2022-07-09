# Shopping Sample App

## Frontend designs

- As a file in [this repository](https://github.com/predatorx7/FHN_Project/blob/main/Shopping_Frontend-Designs.excalidraw)
- [Online at Excalidraw](https://excalidraw.com/#json=yB2yXpJ67S1UMRB8R7pN1,WVj4XE32RvnW6xB0AuaymQ)

## Flutter application

- The main flutter code resides at [`/flutter`.](https://github.com/predatorx7/FHN_Project/tree/main/flutter).
- App has 3 flavors for android, and iOS: production, staging, and development.
- yarn can be used with `flutter/package.json` for managing the project, for ex., `yarn dev` runs the development flavor of the app in debug mode.
- Riverpod is used in the application for DI, and state management.
- Retrofit is used for generating HTTP REST Api client services code.

#### Structure

```
.
├── gen
│   └── assets.gen.dart
├── l10n
│   ├── arb
│   │   ├── app_ar.arb
│   │   ├── app_en.arb
│   │   └── app_hi.arb
│   └── l10n.dart
├── main.dart
├── main_devel.dart
├── main_stag.dart
└── src
    ├── commons
    │   ├── dependencies.dart
    │   ├── settings.dart
    │   └── theme.dart
    ├── config
    │   ├── bootstrap.dart
    │   ├── build_options.dart
    │   ├── firebase
    │   │   ├── firebase_options.dart
    │   │   ├── firebase_options_dev.dart
    │   │   └── firebase_options_stg.dart
    │   └── under_construction.dart
    ├── data
    ├── di
    ├── modules
    ├── navigation
    │   └── router.dart
    ├── repo
    ├── services
    ├── storage
    ├── ui
    │   ├── components
    │   ├── main
    │   │   ├── app.dart
    │   │   └── launch.dart
    │   └── screens
    │       ├── browsing.dart
    │       ├── checkout.dart
    │       ├── home.dart
    │       └── my_stuff.dart
    └── utils
```

1. `gen/`

Contains generated code for assets

2. `l10n/`

Translation related arb files, and localization controller

3. main files

The main entry point files for development, staging & production.

4. `common`

Contains app dependencies, settings, themes, etc

5. `config`

App configurations for firebase, startup, etc

6. `data`

Collection of data classes for json serializable, forms, plain models, etc

7. `di` & `modules`

Commonly used providers, notifiers, di modules, controllers, etc

8. `navigation`

Contains routes, and router configurations

9. `repo` & `services`

Contains services, and repositories for http, local storage, etc.

10. `storage`

Code related to local data persistence, migrations, database, etc.

11. `ui`

Code related to the UI resides here.

12. `utils`

Contains commonly used utility classes, and functions.

#### Screenshots

![Home page](https://raw.githubusercontent.com/predatorx7/FHN_Project/main/screenshots/homepage.png "Home page")

![Home page where some items are in cart](https://raw.githubusercontent.com/predatorx7/FHN_Project/main/screenshots/homepage_alt.png "Home page")

![Checkout page](https://raw.githubusercontent.com/predatorx7/FHN_Project/main/screenshots/checkoutpage.png "Checkout page")

![Checkout page with items that have multiple quantities](https://raw.githubusercontent.com/predatorx7/FHN_Project/main/screenshots/homepage_alt.png "Checkout page")
