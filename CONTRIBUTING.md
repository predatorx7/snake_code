# Contributing to Snake

:+1::tada: First off, thanks for taking the time to contribute! :tada::+1:

The following is a set of guidelines for contributing to Snake and its packages, which are hosted in the [snake_code repository](https://github.com/predatorx7/snake_code) on GitHub. These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

#### Table Of Contents

[Code of Conduct](#code-of-conduct)

[What should I know before I get started?](#what-should-i-know-before-i-get-started)
- [Snake Code and Packages](#Snake's-application-and-Packages)
- [Structure](#structure)

[How Can I Contribute?](#how-can-i-contribute)

- [Reporting Bugs](#reporting-bugs)
- [Suggesting Enhancements](#suggesting-enhancements)
- [Contributing](#contributing)
- [Your First Code Contribution](#your-first-code-contribution) <!-- - [Style guide](#style-guide) -->
- [Reference articles](#reference-articles)

## Code of Conduct

This project and everyone participating in it is governed by the [Snake's Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to [smushaheed@outlook.com](mailto:smushaheed@outlook.com).

> **You don't want to read this whole thing and just have a question??!!!**<br>Please don't file an issue to ask a question. You'll get faster results by using the resources below. If your doubt is still unresolved then send me a mail about it at [smushaheed@outlook.com](mailto:smushaheed@outlook.com)

## What should I know before I get started?

### Snake's application and Packages

Snake is not a large open source project &mdash; But still when you initially consider contributing to this project, you might be unsure about where to start from. This section should help you with that.

I try to keep code in this repository modular.

Fundamental things like editor UI, tabs, etc lives in the main flutter application folder.

The widgets, components which I think could be used in other projects are separated in the package folder (might be published on pub.dev).

Any flutter/dart code which is not part of UI and core logic code must be separately kept in packages.

Here's a list of current packages:

- creamy_field

### Structure

The code of application based loosely on [Single responsibility principle](https://en.wikipedia.org/wiki/Single-responsibility_principle).
Source code in flutter application's lib folder must follow the below directory architecture pattern:

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

#### Commons

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

#### Core

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

#### Database

All database CRUD operations and classes will be here

#### Models

1. Plain_models
   Plain old dart objects like POJOs will be here.
   Document Node Models should also be here.
2. View_models
   ChangeNotifiers for state management of respective screens will be here.

#### Providers

Providers for bloc and state management should be here.

#### UI

1. Screens
   - The "screens" folder holds many different folders or primary screen files, each of which corresponds to a different screen of the app. Each screen folder holds primary screen files.
1. Components
   - “components” folder which holds each component in its own separate file.
	- Any piece of a screen more complicated then a few widgets should be its own component.
	- Any widget used in more than one
   screen should be in component.

## How Can I Contribute?

### Reporting Bugs

This section guides you through submitting a bug report for Snake. Following these guidelines helps maintainers and the community understand your report :pencil:, reproduce the behavior :computer: :computer:, and find related reports :mag_right:.

Before creating bug reports, please check [this list](#before-submitting-a-bug-report) as you might find out that you don't need to create one. When you are creating a bug report, please [include as many details as possible](#how-do-i-submit-a-good-bug-report).

<!-- Fill out [the required template](https://github.com/atom/.github/blob/master/.github/ISSUE_TEMPLATE/bug_report.md), the information it asks for helps us resolve issues faster. -->

> **Note:** If you find a **Closed** issue that seems like it is the same thing that you're experiencing, open a new issue and include a link to the original issue in the body of your new one.

#### Before Submitting A Bug Report

- **Check the [debugging guide](https://flutter.dev/docs/testing/debugging).** You might be able to find the cause of the problem and fix things yourself. Most importantly, check if you can reproduce the problem in the latest version of Snake, and if you can get the desired behavior by changing Snake's or packages' config settings.
- It's recommended to use Dart Devtools for this purpose.
- **Determine which component or package the problem should be reported in**.
- **Perform a [cursory search](https://github.com/search?q=is%3Aissue+repo%3Apredatorx7%2Fsnake_code)** to see if the problem has already been reported. If it has **and the issue is still open**, add a comment to the existing issue instead of opening a new one.

#### How Do I Submit A (Good) Bug Report?

Bugs are tracked as [GitHub issues](https://guides.github.com/features/issues/). After you've determined which component or package your bug is related to, create an issue on that repository and provide the following information by filling in [the template](https://github.com/predatorx7/snake_code/blob/master/.github/ISSUE_TEMPLATE/bug_report.md).

Explain the problem and include additional details to help maintainers reproduce the problem:

- **Use a clear and descriptive title** for the issue to identify the problem.
- **Describe the exact steps which reproduce the problem** in as many details as possible. For example, start by explaining how you started/built Snake, e.g. which command exactly you used in the terminal, or how you build Snake otherwise. When listing steps, **don't just say what you did, but explain how you did it**.
- **Provide specific examples to demonstrate the steps**. Include links to files or GitHub projects, or copy/pasteable snippets, which you use in those examples. If you're providing snippets in the issue, use [Markdown code blocks](https://help.github.com/articles/markdown-basics/#multiple-lines).
- **Describe the behavior you observed after following the steps** and point out what exactly is the problem with that behavior.
- **Explain which behavior you expected to see instead and why.**
- **Include screenshots and animated GIFs** which show you following the described steps and clearly demonstrate the problem. If you use the keyboard while following the steps, **record the GIF**. You can use [this tool](https://www.cockos.com/licecap/) to record GIFs on macOS and Windows, and [this tool](https://github.com/colinkeenan/silentcast) or [this tool](https://github.com/GNOME/byzanz) on Linux.
<!-- - **If you're reporting that Snake crashed**, include a crash report with a stack trace from the operating system. On macOS, the crash report will be available in `Console.app` under "Diagnostic and usage information" > "User diagnostic reports". Include the crash report in the issue in a [code block](https://help.github.com/articles/markdown-basics/#multiple-lines), a [file attachment](https://help.github.com/articles/file-attachments-on-issues-and-pull-requests/), or put it in a [gist](https://gist.github.com/) and provide link to that gist. -->
- **If the problem is related to performance or memory**, include screenshots from the [Dart Devtools](https://flutter.dev/docs/development/tools/devtools) with your report.
- **If the problem wasn't triggered by a specific action**, describe what you were doing before the problem happened and share more information using the guidelines below.

Provide more context by answering these questions:

- **Can you reproduce the problem in release, profile or debug mode?**
- **Did the problem start happening recently** (e.g. after updating to a new version of Snake) or was this always a problem?
- If the problem started happening recently, **can you reproduce the problem in an older version of Snake if possible?** What's the most recent version in which the problem doesn't happen? You can download older versions of Snake from [the releases page](https://github.com/predatorx7/snake_code/releases).
- **Can you reliably reproduce the issue?** If not, provide details about how often the problem happens and under which conditions it normally happens.
- If the problem is related to working with files (e.g. opening and editing files), **does the problem happen for all files and projects or only some?** Does the problem happen only when working with local , with files of a specific type (e.g. only JavaScript or Python files), with large files or files with very long lines, or with files in a specific encoding? Is there anything else special about the files you are using?

Include details about your configuration and environment:

- **Which version of Snake are you using?**
<!-- You can get the exact version by running `atom -v` in your terminal, or by starting Atom and running the `Application: About` command from the [Command Palette](https://github.com/atom/command-palette). -->
- **What's the name and version of the OS you're using**?
- **What's the model name and brand of the device you're using**?

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion for Snake, including completely new features and minor improvements to existing functionality. Following these guidelines helps maintainers and the community understand your suggestion :pencil: and find related suggestions :mag_right:.

Before creating enhancement suggestions, please check [this list](#before-submitting-an-enhancement-suggestion) as you might find out that you don't need to create one. When you are creating an enhancement suggestion, please [include as many details as possible](#how-do-i-submit-a-good-enhancement-suggestion). Fill in [the template](https://github.com/predatorx7/snake_code/blob/master/.github/ISSUE_TEMPLATE/feature_request.md), including the steps that you imagine you would take if the feature you're requesting existed.

#### Before Submitting An Enhancement Suggestion

* **Check the issues page.** you might discover that the enhancement is already available. Most importantly, check if you're using the latest version of Snake and if you can get the desired behavior by changing Snake's or packages' config settings.
* **Check if there's already a component or package which provides that enhancement.**
* **Determine which repository the enhancement should be suggested in**
* **Perform a [cursory search](https://github.com/search?q=is%3Aissue+repo%3Apredatorx7%2Fsnake_code)** to see if the enhancement has already been suggested. If it has, add a comment to the existing issue instead of opening a new one.

#### How Do I Submit A (Good) Enhancement Suggestion?

Enhancement suggestions are tracked as [GitHub issues](https://guides.github.com/features/issues/). After you've determined which component/package your enhancement suggestion is related to, create an issue on that repository and provide the following information:

* **Use a clear and descriptive title** for the issue to identify the suggestion.
* **Provide a step-by-step description of the suggested enhancement** in as many details as possible.
* **Provide specific examples to demonstrate the steps**. Include copy/pasteable snippets which you use in those examples, as [Markdown code blocks](https://help.github.com/articles/markdown-basics/#multiple-lines).
* **Describe the current behavior** and **explain which behavior you expected to see instead** and why.
* **Include screenshots and animated GIFs** which help you demonstrate the steps or point out the part of Snake which the suggestion is related to. You can use [this tool](https://www.cockos.com/licecap/) to record GIFs on macOS and Windows, and [this tool](https://github.com/colinkeenan/silentcast) or [this tool](https://github.com/GNOME/byzanz) on Linux.
* **Explain why this enhancement would be useful** to most users.
* **List some other text editors or applications where this enhancement exists.**
* **Specify which version of Snake you're using.** 
* **Specify the name and version of the OS you're using.**

### Contributing

You can traverse the issues and check if there's something you can solve. Create a pull request mentioning the issue in the commit messages of your pull requests. 

#### When making a commit:

1. Collaborators, please follow [Effective Dart](https://dart.dev/guides/language/effective-dart)'s guidelines when coding in dart.
1. As explained above, **Make or Solve** [issues here](https://github.com/predatorx7/source-code-editor/issues) to find what to contribute, request features or report problems.
1. Start commit with `close, closes, closed, fix, fixes, fixed, resolve, resolve, or resolved` followed by issue number, for example as `close #2`, when you've fixed an issue. This will close the respective issue when the branch is merged with branch `master`
1. Try keeping `master` branch most stable

#### Your First Code Contribution

Unsure where to begin contributing to Snake? You can start by looking through these `good-first-issue` issues:

* [good-first-issue][beginner] - issues which should only require a few lines of code, and a test or two. Good for beginners.

<!-- ### Style guide
 -->

### Reference articles

https://medium.com/flutter-community/flutter-architecture-provider-implementation-guide-d33133a9a4e8
https://medium.com/@jgrandchavin/flutter-provider-changenotifier-architecture-guide-47ad05aa608e

https://martinfowler.com/articles/injection.html
https://medium.com/@jelenaaa.lecic/what-are-sync-async-yield-and-yield-in-dart-defe57d06381

#### The packages we may use (from pub.dev)

https://pub.dev/packages/get_it (imp)
https://pub.dev/packages/provider (most imp)
https://pub.dev/packages/hive (documentation) (imp)
https://pub.dev/packages/android_intent
https://pub.dev/packages/sqflite (imp)
https://pub.dev/packages/share
https://pub.dev/packages/shared_preferences