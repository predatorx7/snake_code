# Snake Code (org.purplegraphite.code)

_Effortlessly programming_ on mobile

[![Flutter analysis](https://github.com/predatorx7/snake_code/workflows/Flutter%20analysis/badge.svg)](https://github.com/predatorx7/snake_code/actions?query=workflow%3A%22Flutter+analysis%22)

Snake Code is just a simple source code editor. This project's main target platform is Android.

The application is written in dart (uses Flutter UI Toolkit).

## Objective

- An easy to use source code editor
- Open directories/files as projects
- Syntax highlighting
- Basic editing tools for ex. Find & replace

---

## Structure

```tree
├── org.purplegraphite.code
└── packages
    └── creamy_field
```

### org.purplegraphite.code

The main flutter project code resides here.

### _packages_

All the internal and general purpose packages used in org.purplegraphite.code is here.

- creamy_field

  The package provides components & widgets with rich text, custom selection toolbar & syntax highlight support.

---

## A brief information about the project

### Problem this tries to solves

This project aims to help make programming on mobile devices easier.

It will focus on being flexible in functionality by providing various in-app settings for users and allowing support for extensions in future.
Extensions built by us or others can improve suggestions, performance, theming, etc.

It helps in modifying a source code of a project simple by allowing to edit multiple files at once in tabs and switching between them quicker in a nice interface.

It'll include a file directory explorer for faster exploration of files. Simple to use yet powerful search, replace, and other tools to aid in writing.

### Some functionalities

1. A project explorer to help browsing files a user needs faster and less messy. Existing similar applications show all files in a project as an expandable tile which makes the list too long & wide making it difficult to distinguish between files of one folder with another folder.
1. A search tool to globally search for files with names, or files with a text equal or similar to the searched query.
1. A tab switcher to change between current tabs on screen quickly similar to a web browser.
1. Flexibility in functionality with a lot of options in settings and support for extensions to change themes, syntax highlighting, way of debugging. The app will also be flexible in importing a project and exporting/sharing it in a portable but fast format.

### Users

The type of users which may use this app.

1. Users who don't have money to buy a computer for an indefinite amount of time but have a mobile device available.
1. Programmers who need to edit a project on a mobile device because they are commuting in a transport or due to temporary unavailability of a computer.
1. Users who just want to quickly run and share a small program with each other in groups.
1. Users who don’t want to waste money on buying a computer if the app is able to run projects on mobile.

Users (likely students) from an economically weak background wouldn’t be able to afford a full fledged computer but could have access to a mobile. These users can use this app and try to achieve relevant skills by learning and developing programs. My app will try to not let an unavailability of a computer for an indefinite amount of time be an obstacle for these users.

### Developer goals for this app's design

1. Build community for extension development for making this app more functionally flexible and vast.
1. Keep this app as an economically cheap alternative for program development for users.
1. A medium to quickly run code and share it with other users.
1. Fast in its functions to improve user’s productivity.
