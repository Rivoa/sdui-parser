# Comprehensive SDUI Parser Documentation

## Table of Contents

1. [Overview](#overview)
2. [Getting Started](#getting-started)
3. [Core Concepts](#core-concepts)
4. [Widget Reference](#widget-reference)
5. [Features](#features)
6. [Advanced Usage](#advanced-usage)
7. [Best Practices](#best-practices)
8. [API Reference](#api-reference)

---

## Overview

The Comprehensive SDUI (Server-Driven UI) Parser is a complete Flutter solution for building dynamic user interfaces from JSON configurations. This allows you to update your app's UI without deploying new code.

### Key Features

✅ **90+ Widget Types** - Complete Flutter widget coverage  
✅ **Data Binding** - Dynamic content with `{{variable}}` syntax  
✅ **Conditional Rendering** - Show/hide based on logic  
✅ **State Management** - Built-in reactive state  
✅ **Form Handling** - Complete form input support  
✅ **Dynamic Lists** - Data-driven ListView and GridView  
✅ **Gestures** - Tap, long press, swipe to dismiss  
✅ **Theming** - Full theme customization  
✅ **Platform Support** - Material & Cupertino widgets  
✅ **Error Handling** - Graceful error display  

---

## Getting Started

### Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
```

### Basic Setup

```dart
import 'package:flutter/material.dart';
import 'sdui_parser.dart';

void main() {
  // Setup action handler
  SduiParser.onAction = (name, args, context) {
    // Handle actions
  };
  
  // Setup data provider (optional)
  SduiParser.dataProvider = (path) {
    // Return data for path
    return myData[path];
  };
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final json = {
      "type": "scaffold",
      "args": {
        "body": {
          "type": "center",
          "args": {
            "child": {
              "type": "text",
              "args": {"text": "Hello SDUI!"}
            }
          }
        }
      }
    };
    
    return MaterialApp(
      home: SduiParser.render(json, context),
    );
  }
}
```

---

## Core Concepts

### 1. JSON Structure

Every widget is defined as a JSON object with:
- `type`: Widget type (e.g., "text", "button")
- `args`: Widget arguments/properties
- `condition`: Optional condition for rendering

```json
{
  "type": "text",
  "args": {
    "text": "Hello World",
    "style": {
      "fontSize": 24,
      "color": "#FF0000"
    }
  }
}
```

### 2. Data Binding

Use `{{path}}` syntax to bind data:

```json
{
  "type": "text",
  "args": {
    "text": "Welcome, {{user.name}}!"
  }
}
```

Setup data provider:

```dart
SduiParser.dataProvider = (path) {
  if (path == "user.name") return "John";
  return null;
};
```

### 3. Actions

Actions connect UI events to your code:

```json
{
  "type": "elevated_button",
  "args": {
    "onPressed": "navigate('/home')",
    "child": {"type": "text", "args": {"text": "Go Home"}}
  }
}
```

Handle actions:

```dart
SduiParser.onAction = (name, args, context) {
  if (name == 'navigate') {
    Navigator.pushNamed(context, args['_positional'][0]);
  }
};
```

### 4. State Management

Use `stateKey` to manage widget state:

```json
{
  "type": "switch",
  "args": {
    "stateKey": "darkMode",
    "value": false,
    "onChanged": "toggleDarkMode"
  }
}
```

Access state in code:

```dart
bool isDarkMode = SduiParser.instance.getState('darkMode');
SduiParser.instance.setState('darkMode', true);
```

### 5. Conditional Rendering

Show/hide widgets based on conditions:

```json
{
  "type": "conditional",
  "condition": "user.isLoggedIn",
  "args": {
    "then": {
      "type": "text",
      "args": {"text": "Welcome back!"}
    },
    "else": {
      "type": "text",
      "args": {"text": "Please log in"}
    }
  }
}
```

Complex conditions:

```json
{
  "condition": {
    "op": "and",
    "conditions": [
      {"op": "equals", "left": "user.role", "right": "admin"},
      {"op": "greaterThan", "left": "user.age", "right": 18}
    ]
  }
}
```

---

## Widget Reference

### Structure Widgets

#### scaffold
Complete screen structure.

```json
{
  "type": "scaffold",
  "args": {
    "appBar": {...},
    "body": {...},
    "backgroundColor": "#FFFFFF",
    "floatingActionButton": {...},
    "bottomNavigationBar": {...},
    "drawer": {...}
  }
}
```

#### app_bar
Application bar.

```json
{
  "type": "app_bar",
  "args": {
    "title": {...},
    "backgroundColor": "#2196F3",
    "centerTitle": true,
    "elevation": 4,
    "leading": {...},
    "actions": [...]
  }
}
```

#### safe_area
Respects device safe areas.

```json
{
  "type": "safe_area",
  "args": {
    "top": true,
    "bottom": true,
    "child": {...}
  }
}
```

### Layout Widgets

#### column
Vertical layout.

```json
{
  "type": "column",
  "args": {
    "mainAxisAlignment": "center",
    "crossAxisAlignment": "stretch",
    "mainAxisSize": "min",
    "children": [...]
  }
}
```

#### row
Horizontal layout.

```json
{
  "type": "row",
  "args": {
    "mainAxisAlignment": "spaceBetween",
    "crossAxisAlignment": "center",
    "children": [...]
  }
}
```

#### stack
Layered layout.

```json
{
  "type": "stack",
  "args": {
    "alignment": "center",
    "fit": "expand",
    "children": [...]
  }
}
```

#### container
Box with decoration.

```json
{
  "type": "container",
  "args": {
    "width": 200,
    "height": 100,
    "padding": 16,
    "margin": [10, 20, 10, 20],
    "color": "#E3F2FD",
    "borderRadius": 12,
    "borderColor": "#2196F3",
    "borderWidth": 2,
    "gradient": {
      "type": "linear",
      "colors": ["#FF6B6B", "#4ECDC4"],
      "begin": "topLeft",
      "end": "bottomRight"
    },
    "boxShadow": [
      {
        "color": "#000000",
        "offsetX": 0,
        "offsetY": 4,
        "blurRadius": 8,
        "spreadRadius": 0
      }
    ],
    "child": {...}
  }
}
```

#### expanded
Takes available space in flex layout.

```json
{
  "type": "expanded",
  "args": {
    "flex": 2,
    "child": {...}
  }
}
```

#### flexible
Flexible space in flex layout.

```json
{
  "type": "flexible",
  "args": {
    "flex": 1,
    "fit": "loose",
    "child": {...}
  }
}
```

#### wrap
Flowing layout.

```json
{
  "type": "wrap",
  "args": {
    "direction": "horizontal",
    "alignment": "start",
    "spacing": 8,
    "runSpacing": 8,
    "children": [...]
  }
}
```

#### padding
Add padding.

```json
{
  "type": "padding",
  "args": {
    "padding": 16,  // or [left, top, right, bottom]
    "child": {...}
  }
}
```

#### positioned
Absolute positioning in Stack.

```json
{
  "type": "positioned",
  "args": {
    "left": 10,
    "top": 20,
    "right": 10,
    "bottom": 20,
    "child": {...}
  }
}
```

### Scrolling Widgets

#### single_child_scroll_view
Scrollable single child.

```json
{
  "type": "single_child_scroll_view",
  "args": {
    "scrollDirection": "vertical",
    "reverse": false,
    "padding": 16,
    "physics": "bouncing",
    "child": {...}
  }
}
```

#### list_view
Static scrollable list.

```json
{
  "type": "list_view",
  "args": {
    "scrollDirection": "vertical",
    "shrinkWrap": false,
    "padding": 16,
    "children": [...]
  }
}
```

#### list_view_builder
Dynamic data-driven list.

```json
{
  "type": "list_view_builder",
  "args": {
    "data": "products",  // Path to list data
    "padding": 16,
    "itemTemplate": {
      "type": "card",
      "args": {
        "child": {
          "type": "text",
          "args": {"text": "{{item.name}}"}
        }
      }
    }
  }
}
```

Data provider provides:
- `item` - Current item
- `index` - Current index
- `item.property` - Item properties

#### grid_view
Static grid.

```json
{
  "type": "grid_view",
  "args": {
    "crossAxisCount": 2,
    "mainAxisSpacing": 8,
    "crossAxisSpacing": 8,
    "childAspectRatio": 1.0,
    "padding": 16,
    "children": [...]
  }
}
```

#### grid_view_builder
Dynamic data-driven grid.

```json
{
  "type": "grid_view_builder",
  "args": {
    "data": "products",
    "crossAxisCount": 3,
    "mainAxisSpacing": 8,
    "crossAxisSpacing": 8,
    "itemTemplate": {...}
  }
}
```

#### page_view
Swipeable pages.

```json
{
  "type": "page_view",
  "args": {
    "scrollDirection": "horizontal",
    "pageSnapping": true,
    "children": [...]
  }
}
```

#### refreshable
Pull to refresh.

```json
{
  "type": "refreshable",
  "args": {
    "onRefresh": "fetchData",
    "color": "#2196F3",
    "child": {...}
  }
}
```

### Content Widgets

#### text
Display text.

```json
{
  "type": "text",
  "args": {
    "text": "Hello World",
    "textAlign": "center",
    "maxLines": 2,
    "overflow": "ellipsis",
    "softWrap": true,
    "style": {
      "fontSize": 24,
      "fontWeight": "bold",
      "fontStyle": "italic",
      "color": "#000000",
      "backgroundColor": "#FFFF00",
      "letterSpacing": 1.2,
      "wordSpacing": 2.0,
      "height": 1.5,
      "decoration": "underline",
      "decorationColor": "#FF0000",
      "decorationStyle": "solid",
      "fontFamily": "Roboto"
    }
  }
}
```

#### rich_text
Styled text spans.

```json
{
  "type": "rich_text",
  "args": {
    "spans": [
      {
        "text": "Bold ",
        "style": {"fontWeight": "bold"}
      },
      {
        "text": "and italic ",
        "style": {"fontStyle": "italic"}
      },
      {
        "text": "text",
        "style": {"color": "#FF0000"}
      }
    ]
  }
}
```

#### icon
Material icon.

```json
{
  "type": "icon",
  "args": {
    "icon": "home",
    "size": 32,
    "color": "#2196F3"
  }
}
```

Available icons: home, menu, arrow_back, arrow_forward, add, remove, edit, delete, save, search, refresh, share, favorite, star, call, email, message, play_arrow, pause, camera, settings, person, shopping_cart, location_on, event, lock, help, and 60+ more.

#### image_network
Network image.

```json
{
  "type": "image_network",
  "args": {
    "url": "https://example.com/image.jpg",
    "width": 200,
    "height": 200,
    "fit": "cover",
    "alignment": "center",
    "showLoading": true,
    "color": "#FF0000",
    "colorBlendMode": "multiply"
  }
}
```

#### image_asset
Asset image.

```json
{
  "type": "image_asset",
  "args": {
    "path": "assets/logo.png",
    "width": 100,
    "height": 100,
    "fit": "contain"
  }
}
```

#### circular_progress_indicator
Loading spinner.

```json
{
  "type": "circular_progress_indicator",
  "args": {
    "value": 0.7,  // null for indeterminate
    "backgroundColor": "#E0E0E0",
    "color": "#2196F3",
    "strokeWidth": 4
  }
}
```

#### linear_progress_indicator
Linear progress bar.

```json
{
  "type": "linear_progress_indicator",
  "args": {
    "value": 0.5,
    "backgroundColor": "#E0E0E0",
    "color": "#4CAF50",
    "minHeight": 8
  }
}
```

### Material Components

#### card
Material card.

```json
{
  "type": "card",
  "args": {
    "color": "#FFFFFF",
    "elevation": 4,
    "shadowColor": "#000000",
    "margin": 16,
    "borderRadius": 12,
    "child": {...}
  }
}
```

#### list_tile
List item.

```json
{
  "type": "list_tile",
  "args": {
    "leading": {"type": "icon", "args": {"icon": "person"}},
    "title": {"type": "text", "args": {"text": "Title"}},
    "subtitle": {"type": "text", "args": {"text": "Subtitle"}},
    "trailing": {"type": "icon", "args": {"icon": "arrow_forward"}},
    "onTap": "itemTapped",
    "selected": false,
    "tileColor": "#F5F5F5"
  }
}
```

#### chip
Compact element.

```json
{
  "type": "chip",
  "args": {
    "label": {"type": "text", "args": {"text": "Tag"}},
    "avatar": {...},
    "deleteIcon": {...},
    "onDeleted": "removeTag",
    "backgroundColor": "#E0E0E0"
  }
}
```

#### badge
Notification badge.

```json
{
  "type": "badge",
  "args": {
    "label": {"type": "text", "args": {"text": "3"}},
    "backgroundColor": "#F44336",
    "textColor": "#FFFFFF",
    "child": {"type": "icon", "args": {"icon": "notifications"}}
  }
}
```

#### tooltip
Hover tooltip.

```json
{
  "type": "tooltip",
  "args": {
    "message": "Click to save",
    "waitDuration": 500,
    "child": {...}
  }
}
```

### Button Widgets

#### elevated_button
Material elevated button.

```json
{
  "type": "elevated_button",
  "args": {
    "onPressed": "handleSubmit",
    "onLongPress": "showOptions",
    "backgroundColor": "#4CAF50",
    "foregroundColor": "#FFFFFF",
    "elevation": 4,
    "padding": 16,
    "borderRadius": 8,
    "minimumSize": {"width": 200, "height": 48},
    "child": {"type": "text", "args": {"text": "Submit"}}
  }
}
```

#### text_button
Flat text button.

```json
{
  "type": "text_button",
  "args": {
    "onPressed": "cancel",
    "foregroundColor": "#2196F3",
    "child": {"type": "text", "args": {"text": "Cancel"}}
  }
}
```

#### outlined_button
Outlined button.

```json
{
  "type": "outlined_button",
  "args": {
    "onPressed": "showMore",
    "foregroundColor": "#2196F3",
    "borderColor": "#2196F3",
    "borderWidth": 2,
    "child": {"type": "text", "args": {"text": "Learn More"}}
  }
}
```

#### icon_button
Icon button.

```json
{
  "type": "icon_button",
  "args": {
    "onPressed": "settings",
    "icon": {"type": "icon", "args": {"icon": "settings"}},
    "iconSize": 24,
    "color": "#2196F3",
    "tooltip": "Settings"
  }
}
```

#### floating_action_button
FAB.

```json
{
  "type": "floating_action_button",
  "args": {
    "onPressed": "addItem",
    "backgroundColor": "#4CAF50",
    "foregroundColor": "#FFFFFF",
    "elevation": 6,
    "mini": false,
    "tooltip": "Add",
    "child": {"type": "icon", "args": {"icon": "add"}}
  }
}
```

### Form Input Widgets

#### text_field
Text input.

```json
{
  "type": "text_field",
  "args": {
    "controllerId": "email",
    "labelText": "Email",
    "hintText": "Enter your email",
    "helperText": "We'll never share your email",
    "errorText": "Invalid email",
    "prefixIcon": {"type": "icon", "args": {"icon": "email"}},
    "suffixIcon": {...},
    "keyboardType": "emailAddress",
    "textInputAction": "next",
    "obscureText": false,
    "maxLines": 1,
    "maxLength": 50,
    "enabled": true,
    "readOnly": false,
    "autofocus": false,
    "onChanged": "emailChanged",
    "onSubmitted": "emailSubmitted",
    "border": "outline",
    "filled": true,
    "fillColor": "#F5F5F5"
  }
}
```

#### checkbox
Checkbox input.

```json
{
  "type": "checkbox",
  "args": {
    "stateKey": "termsAccepted",
    "value": false,
    "onChanged": "termsChanged",
    "activeColor": "#4CAF50",
    "checkColor": "#FFFFFF"
  }
}
```

#### switch
Toggle switch.

```json
{
  "type": "switch",
  "args": {
    "stateKey": "notifications",
    "value": true,
    "onChanged": "toggleNotifications",
    "activeColor": "#4CAF50",
    "activeTrackColor": "#81C784",
    "inactiveThumbColor": "#9E9E9E",
    "inactiveTrackColor": "#E0E0E0"
  }
}
```

#### radio
Radio button.

```json
{
  "type": "radio",
  "args": {
    "stateKey": "selectedOption",
    "value": "option1",
    "groupValue": "option1",
    "onChanged": "optionChanged",
    "activeColor": "#2196F3"
  }
}
```

#### slider
Value slider.

```json
{
  "type": "slider",
  "args": {
    "stateKey": "volume",
    "value": 50,
    "min": 0,
    "max": 100,
    "divisions": 10,
    "label": "50",
    "onChanged": "volumeChanged",
    "activeColor": "#2196F3",
    "inactiveColor": "#E0E0E0"
  }
}
```

#### dropdown
Dropdown menu.

```json
{
  "type": "dropdown",
  "args": {
    "stateKey": "country",
    "value": "us",
    "hint": "Select country",
    "isExpanded": true,
    "items": [
      {"value": "us", "label": "United States"},
      {"value": "uk", "label": "United Kingdom"},
      {"value": "ca", "label": "Canada"}
    ],
    "onChanged": "countryChanged",
    "dropdownColor": "#FFFFFF"
  }
}
```

#### date_picker
Date picker button.

```json
{
  "type": "date_picker",
  "args": {
    "initialDate": "2024-01-15",
    "firstDate": "1900-01-01",
    "lastDate": "2100-12-31",
    "onSelected": "dateSelected",
    "child": {
      "type": "text",
      "args": {"text": "Pick Date"}
    }
  }
}
```

#### time_picker
Time picker button.

```json
{
  "type": "time_picker",
  "args": {
    "onSelected": "timeSelected",
    "child": {
      "type": "text",
      "args": {"text": "Pick Time"}
    }
  }
}
```

### Gesture Widgets

#### gesture_detector
Gesture recognition.

```json
{
  "type": "gesture_detector",
  "args": {
    "onTap": "handleTap",
    "onDoubleTap": "handleDoubleTap",
    "onLongPress": "handleLongPress",
    "behavior": "opaque",
    "child": {...}
  }
}
```

#### inkwell
Material ink splash.

```json
{
  "type": "inkwell",
  "args": {
    "onTap": "handleTap",
    "borderRadius": 8,
    "splashColor": "#2196F3",
    "highlightColor": "#BBDEFB",
    "child": {...}
  }
}
```

#### dismissible
Swipe to dismiss.

```json
{
  "type": "dismissible",
  "args": {
    "key": "item1",
    "direction": "endToStart",
    "onDismissed": "itemDismissed",
    "background": {
      "type": "container",
      "args": {
        "color": "#F44336",
        "child": {...}
      }
    },
    "child": {...}
  }
}
```

### Navigation Widgets

#### bottom_navigation_bar
Bottom nav bar.

```json
{
  "type": "bottom_navigation_bar",
  "args": {
    "stateKey": "currentTab",
    "currentIndex": 0,
    "onTap": "tabChanged",
    "items": [
      {
        "icon": {"type": "icon", "args": {"icon": "home"}},
        "label": "Home"
      },
      {
        "icon": {"type": "icon", "args": {"icon": "search"}},
        "label": "Search"
      },
      {
        "icon": {"type": "icon", "args": {"icon": "person"}},
        "label": "Profile"
      }
    ],
    "backgroundColor": "#FFFFFF",
    "selectedItemColor": "#2196F3",
    "unselectedItemColor": "#9E9E9E",
    "type": "fixed",
    "elevation": 8
  }
}
```

#### drawer
Side drawer.

```json
{
  "type": "drawer",
  "args": {
    "backgroundColor": "#FFFFFF",
    "elevation": 16,
    "width": 280,
    "child": {...}
  }
}
```

### Dialog & Overlay Widgets

#### alert_dialog
Alert dialog (shown with showDialog).

```json
{
  "type": "alert_dialog",
  "args": {
    "title": {"type": "text", "args": {"text": "Confirm"}},
    "content": {"type": "text", "args": {"text": "Are you sure?"}},
    "actions": [
      {
        "type": "text_button",
        "args": {
          "onPressed": "cancel",
          "child": {"type": "text", "args": {"text": "Cancel"}}
        }
      },
      {
        "type": "text_button",
        "args": {
          "onPressed": "confirm",
          "child": {"type": "text", "args": {"text": "OK"}}
        }
      }
    ],
    "backgroundColor": "#FFFFFF",
    "elevation": 24,
    "borderRadius": 4
  }
}
```

### Decorative Widgets

#### opacity
Transparent overlay.

```json
{
  "type": "opacity",
  "args": {
    "opacity": 0.5,
    "child": {...}
  }
}
```

#### transform
Transform widget.

```json
{
  "type": "transform",
  "args": {
    "rotate": 0.785,  // radians
    "alignment": "center",
    "child": {...}
  }
}

// Or scale
{
  "type": "transform",
  "args": {
    "scale": 1.5,
    "child": {...}
  }
}

// Or translate
{
  "type": "transform",
  "args": {
    "translate": [10, 20, 0],
    "child": {...}
  }
}
```

#### clip_rrect
Rounded rectangle clip.

```json
{
  "type": "clip_rrect",
  "args": {
    "borderRadius": 16,
    "child": {...}
  }
}
```

#### clip_oval
Oval clip.

```json
{
  "type": "clip_oval",
  "args": {
    "child": {...}
  }
}
```

#### backdrop_filter
Blur background.

```json
{
  "type": "backdrop_filter",
  "args": {
    "filter": {
      "type": "blur",
      "sigmaX": 10,
      "sigmaY": 10
    },
    "child": {...}
  }
}
```

### Conditional & Control

#### conditional
If/else rendering.

```json
{
  "type": "conditional",
  "condition": "user.isLoggedIn",
  "args": {
    "then": {...},
    "else": {...}
  }
}
```

#### visibility
Show/hide widget.

```json
{
  "type": "visibility",
  "args": {
    "visible": true,
    "maintainSize": false,
    "maintainState": false,
    "replacement": {...},
    "child": {...}
  }
}
```

### Cupertino (iOS) Widgets

#### cupertino_button
iOS-style button.

```json
{
  "type": "cupertino_button",
  "args": {
    "onPressed": "handleTap",
    "color": "#007AFF",
    "padding": 16,
    "borderRadius": 8,
    "child": {"type": "text", "args": {"text": "Button"}}
  }
}
```

#### cupertino_switch
iOS-style switch.

```json
{
  "type": "cupertino_switch",
  "args": {
    "stateKey": "enabled",
    "value": true,
    "onChanged": "toggle",
    "activeColor": "#34C759"
  }
}
```

#### cupertino_slider
iOS-style slider.

```json
{
  "type": "cupertino_slider",
  "args": {
    "stateKey": "volume",
    "value": 50,
    "min": 0,
    "max": 100,
    "divisions": 10,
    "activeColor": "#007AFF"
  }
}
```

---

## Features

### Data Binding

Bind dynamic data using `{{path}}` syntax:

```dart
SduiParser.dataProvider = (path) {
  final data = {
    'user': {'name': 'John', 'email': 'john@example.com'},
    'products': [...],
  };
  
  // Navigate path: user.name -> "John"
  final parts = path.split('.');
  dynamic current = data;
  for (final part in parts) {
    if (current is Map && current.containsKey(part)) {
      current = current[part];
    } else {
      return null;
    }
  }
  return current;
};
```

Use in JSON:

```json
{
  "type": "text",
  "args": {"text": "Hello {{user.name}}!"}
}
```

### Conditional Rendering

#### Simple conditions

```json
{
  "condition": "user.isLoggedIn",
  "type": "text",
  "args": {"text": "Welcome!"}
}
```

#### Complex conditions

```json
{
  "condition": {
    "op": "and",
    "conditions": [
      {"op": "equals", "left": "user.role", "right": "admin"},
      {"op": "greaterThan", "left": "cart.total", "right": 100}
    ]
  }
}
```

Operators: `equals`, `notEquals`, `greaterThan`, `lessThan`, `and`, `or`, `not`

### State Management

Built-in reactive state:

```dart
// Set state
SduiParser.instance.setState('darkMode', true);

// Get state
bool isDark = SduiParser.instance.getState('darkMode');

// Get notifier for reactive widgets
ValueNotifier notifier = SduiParser.instance.getNotifier('darkMode');

// Text controller for TextFields
TextEditingController controller = SduiParser.instance.getTextController('email');
```

Use in widgets:

```json
{
  "type": "switch",
  "args": {
    "stateKey": "darkMode",
    "value": false
  }
}
```

### Dynamic Lists

Data-driven lists with templates:

```json
{
  "type": "list_view_builder",
  "args": {
    "data": "products",
    "itemTemplate": {
      "type": "card",
      "args": {
        "child": {
          "type": "list_tile",
          "args": {
            "title": {
              "type": "text",
              "args": {"text": "{{item.name}}"}
            },
            "subtitle": {
              "type": "text",
              "args": {"text": "${{item.price}}"}
            }
          }
        }
      }
    }
  }
}
```

Available in template:
- `{{item}}` - Current item
- `{{index}}` - Current index
- `{{item.property}}` - Item properties

### Action Handling

Actions connect UI to logic:

```dart
SduiParser.onAction = (name, args, context) {
  switch (name) {
    case 'navigate':
      Navigator.pushNamed(context, args['route']);
      break;
    case 'api_call':
      fetchData(args['endpoint']);
      break;
    case 'updateState':
      SduiParser.instance.setState(args['key'], args['value']);
      break;
  }
};
```

Actions support:
- Named parameters: `action(key: value, key2: value2)`
- Positional parameters: `action(value1, value2)`
- Access via `args['key']` or `args['_positional'][index]`

---

## Advanced Usage

### Custom Widgets

Extend the parser:

```dart
SduiParser.instance._widgetBuilders['my_widget'] = (args, ctx) {
  return MyCustomWidget(
    title: args['title'],
    onTap: () => SduiParser._handleAction(args['onTap'], ctx),
  );
};
```

### Theme Customization

```json
{
  "type": "material_app",
  "args": {
    "theme": {
      "primaryColor": "#2196F3",
      "scaffoldBackgroundColor": "#FFFFFF",
      "useMaterial3": true,
      "colorScheme": {
        "primary": "#2196F3",
        "brightness": "light"
      }
    },
    "darkTheme": {
      "primaryColor": "#90CAF9",
      "scaffoldBackgroundColor": "#121212",
      "colorScheme": {
        "primary": "#90CAF9",
        "brightness": "dark"
      }
    },
    "themeMode": "system"
  }
}
```

### Error Handling

Errors display as red boxes with messages. Customize:

```dart
// Override error widget
Widget buildError(String message) {
  return Container(
    padding: EdgeInsets.all(16),
    color: Colors.red[100],
    child: Text('Error: $message'),
  );
}
```

### Performance

For large lists, use builders:

```json
{
  "type": "list_view_builder",
  "args": {
    "data": "largeList",
    "shrinkWrap": false,
    "itemTemplate": {...}
  }
}
```

### Schema Versioning

Include version in JSON:

```json
{
  "version": "1.0.0",
  "type": "scaffold",
  "args": {...}
}
```

Handle versions:

```dart
if (json['version'] != SduiParser.currentVersion) {
  // Migrate or show compatibility message
}
```

---

## Best Practices

### 1. Structure Your JSON

Use clear hierarchy:

```json
{
  "type": "scaffold",
  "args": {
    "appBar": {...},
    "body": {
      "type": "column",
      "args": {
        "children": [
          {"type": "header", "args": {...}},
          {"type": "content", "args": {...}},
          {"type": "footer", "args": {...}}
        ]
      }
    }
  }
}
```

### 2. Reuse Components

Create reusable templates:

```dart
final cardTemplate = (String title, String subtitle) => {
  "type": "card",
  "args": {
    "child": {
      "type": "list_tile",
      "args": {
        "title": {"type": "text", "args": {"text": title}},
        "subtitle": {"type": "text", "args": {"text": subtitle}}
      }
    }
  }
};
```

### 3. Validate JSON

Server-side validation:

```dart
bool validateSduiJson(Map<String, dynamic> json) {
  if (!json.containsKey('type')) return false;
  if (!json.containsKey('args')) return false;
  // More validation...
  return true;
}
```

### 4. Handle Loading States

```json
{
  "type": "conditional",
  "condition": "isLoading",
  "args": {
    "then": {
      "type": "center",
      "args": {
        "child": {
          "type": "circular_progress_indicator",
          "args": {}
        }
      }
    },
    "else": {
      "type": "list_view_builder",
      "args": {"data": "items", ...}
    }
  }
}
```

### 5. Security

- Validate all JSON from server
- Sanitize user inputs
- Don't expose sensitive data in JSON
- Use HTTPS for JSON delivery

### 6. Testing

Test JSON responses:

```dart
testWidgets('SDUI renders correctly', (tester) async {
  final json = {...};
  await tester.pumpWidget(
    MaterialApp(
      home: SduiParser.render(json, tester.element(find.byType(MaterialApp))),
    ),
  );
  
  expect(find.text('Expected Text'), findsOneWidget);
});
```

---

## API Reference

### SduiParser

Main parser class (Singleton).

#### Static Methods

```dart
// Render JSON to Widget
static Widget render(dynamic json, BuildContext context)

// Process data binding in args
static Map<String, dynamic> _processDataBinding(Map<String, dynamic> args)

// Evaluate condition
static bool _evaluateCondition(dynamic condition)

// Handle action
static void _handleAction(dynamic actionData, BuildContext context)
```

#### Instance Methods

```dart
// State management
void setState(String key, dynamic value)
dynamic getState(String key)
ValueNotifier getNotifier(String key)
TextEditingController getTextController(String key)

// Cleanup
void dispose()
```

#### Static Properties

```dart
// Action handler
static SduiActionHandler onAction

// Data provider
static SduiDataProvider? dataProvider

// Current schema version
static const String currentVersion = '1.0.0'
```

### Type Definitions

```dart
// Action handler signature
typedef SduiActionHandler = void Function(
  String functionName,
  Map<String, dynamic> args,
  BuildContext context
);

// Data provider signature
typedef SduiDataProvider = dynamic Function(String path);
```

---

## Troubleshooting

### Widget not rendering

1. Check JSON structure is valid
2. Verify `type` field is correct
3. Check `args` contains required fields
4. Look for error widget (red box)

### Data binding not working

1. Verify `dataProvider` is set
2. Check data path is correct
3. Ensure data exists at path
4. Use `{{path}}` syntax correctly

### Actions not firing

1. Check `onAction` handler is set
2. Verify action name matches handler
3. Check action syntax: `name(args)`
4. Debug with `debugPrint` in handler

### State not updating

1. Use `stateKey` parameter
2. Call `setState` to update
3. Widget must support state (Switch, Checkbox, etc.)
4. Check ValueNotifier is being used

### Performance issues

1. Use `list_view_builder` for long lists
2. Don't nest too many widgets
3. Avoid complex conditions in lists
4. Cache parsed JSON when possible

---

## Examples Repository

See `example_usage.dart` for complete examples:

1. **Basic Widgets** - Text, images, buttons, layouts
2. **Forms & Inputs** - TextField, checkboxes, sliders
3. **Dynamic Lists** - Data-driven ListView and GridView
4. **Conditional Rendering** - Show/hide based on state
5. **Interactive Features** - Gestures, dismissible, state

---

## License

This SDUI parser is provided as-is for use in your Flutter projects.

---

## Support

For issues or questions:
1. Check this documentation
2. Review example files
3. Test with simple JSON first
4. Add debug prints to trace issues

---

**Version:** 1.0.0  
**Last Updated:** January 2026