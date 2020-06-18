# Code organization

We must divide components of application based loosely on [Single responsibility principle](https://en.wikipedia.org/wiki/Single-responsibility_principle).
Source code in lib folder must follow the below directory architecture pattern:

```
src
├── commons
│   ├── assets.dart (Reference to Fonts, Images, Icons)
│   ├── routes.dart (Routes to use with named navigation)
│   ├── routing_constants.dart
│   ├── strings.dart
│   └── styles.dart
├── core
│   ├── api
│   ├── bloc
│   ├── services (May run in the background or provide some service)
│   └── utils
├── database
├── models
│   ├── plain_models (search for PODO OR POJO)
│   └── view_models
├── providers
└── ui
    ├── components (UI Widgets)
    └── screens
```

## Commons

Variables, Objects which are common whole app like app style, locale based strings, assets, routes (screens), routing_constants (route names).

1. Assets
   - All references to fonts, images, icons or other media.
1. Routes
   - Route generator of navigations to routes/screens.
1. Routing_constants
   - Screen/Route names for routing with route generator
1. Strings
   - Strings (maybe based on locale) for whole app.
1. Styles
   - Custom colors, widget decorations, text styles.

## Core

Stores business logic code, apis, services, utils

1. Api
   Web APIs and native interaction code will be here.
1. Blocs
   Holds business logic code which the respective provider in "providers" folder will provide.
1. Services
   Services like NavigationService, ConnectionService which will run in background or irrelative
   of BuildContext will be here.
1. Utils
   Utilities like Validation class will be here.

## Database

All database CRUD operations and classes will be here

## Models

1. Plain_models
   Plain old dart objects like POJOs will be here.
   Document Node Models should also be here.
2. View_models
   ChangeNotifiers for state management of respective screens will be here.

## Providers

Providers for bloc and state management should be here.

## UI

1. Screens
   - The "screens" folder holds many different folders or primary screen files, each of which corresponds to a different screen of the app. Each screen folder holds primary screen files.
1. Components
   - “components” folder which holds each component in its own separate file.
	- Any piece of a screen more complicated then a few widgets should be its own component.
	- Any widget used in more than one
   screen should be in component.
