// Copyright (c) 2020, Mushaheed Syed. All rights reserved.
//
// Use of this source code is governed by a BSD 3-Clause License that can be
// found in the LICENSE file.

/// This library provides rich text editing field, controllers, syntax highlighting classes, etc.
library creamy_field;

// -- text field ---
export './src/_creamy_field.dart';
export './src/rich_editable_code.dart';
export './src/creamy_editing_controller.dart';
// -- text field ---

// -- syntax highlighter ---
export './src/syntax_highlighter/syntax_highlighter.dart';
export './src/syntax_highlighter/language_type.dart';
export './src/syntax_highlighter/highlighted_theme_type.dart';
// -- syntax highlighter ---

// Don't keep in stable releases, ONLY FOR TEST PURPOSES
export './src/syntax_highlighter_base.dart';
export './src/syntax_highlighter/dummy_syntax_highlighter.dart';
