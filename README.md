# SDUI Parser - Quick Start Guide

## 🚀 Installation

1. Copy these files to your Flutter project:
   - `sdui_parser.dart` → Main parser
   - `sdui_parsing_helpers.dart` → Helper functions
   - `example_usage.dart` → Example implementations

2. Add import to your files:
```dart
import 'sdui_parser.dart';
```

## ⚡ 5-Minute Setup

### Step 1: Setup Action Handler

```dart
void main() {
  SduiParser.onAction = (name, args, context) {
    if (name == 'navigate') {
      Navigator.pushNamed(context, args['route'] ?? args['_positional'][0]);
    }
  };
  
  runApp(MyApp());
}
```

### Step 2: Create Your First UI

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final json = {
      "type": "scaffold",
      "args": {
        "appBar": {
          "type": "app_bar",
          "args": {
            "title": {"type": "text", "args": {"text": "My App"}}
          }
        },
        "body": {
          "type": "center",
          "args": {
            "child": {
              "type": "elevated_button",
              "args": {
                "onPressed": "navigate('/details')",
                "child": {
                  "type": "text",
                  "args": {"text": "Click Me"}
                }
              }
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

### Step 3: Run Your App

```bash
flutter run
```

That's it! You now have a working SDUI app! 🎉

---

## 📱 Common Use Cases

### Show a List of Items

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
            "title": {"type": "text", "args": {"text": "{{item.name}}"}},
            "subtitle": {"type": "text", "args": {"text": "${{item.price}}"}}
          }
        }
      }
    }
  }
}
```

Setup data provider:
```dart
SduiParser.dataProvider = (path) {
  if (path == 'products') {
    return [
      {'name': 'Product 1', 'price': 99.99},
      {'name': 'Product 2', 'price': 149.99},
    ];
  }
  return null;
};
```

### Create a Form

```json
{
  "type": "column",
  "args": {
    "children": [
      {
        "type": "text_field",
        "args": {
          "labelText": "Email",
          "keyboardType": "emailAddress",
          "controllerId": "email"
        }
      },
      {
        "type": "text_field",
        "args": {
          "labelText": "Password",
          "obscureText": true,
          "controllerId": "password"
        }
      },
      {
        "type": "elevated_button",
        "args": {
          "onPressed": "login",
          "child": {"type": "text", "args": {"text": "Login"}}
        }
      }
    ]
  }
}
```

Handle login:
```dart
SduiParser.onAction = (name, args, context) {
  if (name == 'login') {
    final email = SduiParser.instance.getTextController('email').text;
    final password = SduiParser.instance.getTextController('password').text;
    // Perform login
  }
};
```

### Show/Hide Based on Condition

```json
{
  "type": "conditional",
  "condition": "user.isLoggedIn",
  "args": {
    "then": {
      "type": "text",
      "args": {"text": "Welcome {{user.name}}!"}
    },
    "else": {
      "type": "text",
      "args": {"text": "Please log in"}
    }
  }
}
```

---

## 🎨 Styling Tips

### Colors
```json
"color": "#FF5733"        // Hex
"color": "RED"            // Named
"color": "#80FF5733"      // With alpha
```

### Padding/Margin
```json
"padding": 16                    // All sides
"padding": [10, 20, 10, 20]     // [left, top, right, bottom]
```

### Gradients
```json
"gradient": {
  "type": "linear",
  "colors": ["#FF6B6B", "#4ECDC4"],
  "begin": "topLeft",
  "end": "bottomRight"
}
```

### Shadows
```json
"boxShadow": [
  {
    "color": "#000000",
    "offsetX": 0,
    "offsetY": 4,
    "blurRadius": 8
  }
]
```

---

## 🔥 Pro Tips

### 1. Use State for Interactive UIs
```json
{
  "type": "switch",
  "args": {
    "stateKey": "darkMode",
    "value": false
  }
}
```

Access in code:
```dart
bool isDark = SduiParser.instance.getState('darkMode');
```

### 2. Reuse JSON Templates
```dart
Map<String, dynamic> createButton(String text, String action) {
  return {
    "type": "elevated_button",
    "args": {
      "onPressed": action,
      "child": {"type": "text", "args": {"text": text}}
    }
  };
}
```

### 3. Handle Errors Gracefully
Invalid JSON shows a red error box with the error message.

### 4. Use ListView.builder for Long Lists
Always use `list_view_builder` instead of `list_view` with static children for better performance.

### 5. Test with Simple JSON First
Start simple and add complexity gradually:
```json
{"type": "text", "args": {"text": "Hello"}}
```

---

## 🐛 Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| Widget not showing | Check JSON structure, verify `type` is correct |
| Action not firing | Set `SduiParser.onAction` handler |
| Data not binding | Set `SduiParser.dataProvider` |
| State not updating | Use `stateKey` parameter in widget |
| List not scrolling | Set `shrinkWrap: false` |

---

## 📚 Next Steps

1. **Read Full Documentation** - See `COMPREHENSIVE_DOCUMENTATION.md`
2. **Try Examples** - Run `example_usage.dart`
3. **Experiment** - Modify examples and see what happens
4. **Build Your UI** - Create JSON for your app screens

---

## 🎯 Widget Cheat Sheet

### Most Used Widgets

```json
// Layout
{"type": "column", "args": {"children": [...]}}
{"type": "row", "args": {"children": [...]}}
{"type": "container", "args": {"child": {...}}}
{"type": "padding", "args": {"padding": 16, "child": {...}}}
{"type": "center", "args": {"child": {...}}}

// Content
{"type": "text", "args": {"text": "Hello"}}
{"type": "icon", "args": {"icon": "home"}}
{"type": "image_network", "args": {"url": "..."}}

// Buttons
{"type": "elevated_button", "args": {"onPressed": "...", "child": {...}}}
{"type": "text_button", "args": {"onPressed": "...", "child": {...}}}
{"type": "icon_button", "args": {"onPressed": "...", "icon": {...}}}

// Forms
{"type": "text_field", "args": {"labelText": "...", "controllerId": "..."}}
{"type": "checkbox", "args": {"stateKey": "...", "value": false}}
{"type": "switch", "args": {"stateKey": "...", "value": true}}
{"type": "slider", "args": {"stateKey": "...", "min": 0, "max": 100}}
{"type": "dropdown", "args": {"items": [...], "stateKey": "..."}}

// Lists
{"type": "list_view_builder", "args": {"data": "...", "itemTemplate": {...}}}
{"type": "grid_view_builder", "args": {"data": "...", "crossAxisCount": 2}}

// Material
{"type": "card", "args": {"elevation": 4, "child": {...}}}
{"type": "list_tile", "args": {"title": {...}, "subtitle": {...}}}
{"type": "app_bar", "args": {"title": {...}}}
{"type": "scaffold", "args": {"appBar": {...}, "body": {...}}}
```

---

## 🌟 Example: Complete App Screen

```json
{
  "type": "scaffold",
  "args": {
    "appBar": {
      "type": "app_bar",
      "args": {
        "title": {"type": "text", "args": {"text": "Shop"}},
        "backgroundColor": "#2196F3",
        "actions": [
          {
            "type": "icon_button",
            "args": {
              "icon": {"type": "icon", "args": {"icon": "shopping_cart"}},
              "onPressed": "viewCart"
            }
          }
        ]
      }
    },
    "body": {
      "type": "list_view_builder",
      "args": {
        "data": "products",
        "padding": 16,
        "itemTemplate": {
          "type": "card",
          "args": {
            "margin": [0, 0, 0, 16],
            "child": {
              "type": "column",
              "args": {
                "crossAxisAlignment": "stretch",
                "children": [
                  {
                    "type": "image_network",
                    "args": {
                      "url": "{{item.image}}",
                      "height": 200,
                      "fit": "cover"
                    }
                  },
                  {
                    "type": "padding",
                    "args": {
                      "padding": 16,
                      "child": {
                        "type": "column",
                        "args": {
                          "crossAxisAlignment": "start",
                          "children": [
                            {
                              "type": "text",
                              "args": {
                                "text": "{{item.name}}",
                                "style": {"fontSize": 18, "fontWeight": "bold"}
                              }
                            },
                            {
                              "type": "text",
                              "args": {
                                "text": "${{item.price}}",
                                "style": {"fontSize": 16, "color": "#4CAF50"}
                              }
                            },
                            {
                              "type": "sized_box",
                              "args": {"height": 8}
                            },
                            {
                              "type": "elevated_button",
                              "args": {
                                "onPressed": "addToCart('{{item.id}}')",
                                "backgroundColor": "#4CAF50",
                                "child": {
                                  "type": "text",
                                  "args": {"text": "Add to Cart"}
                                }
                              }
                            }
                          ]
                        }
                      }
                    }
                  }
                ]
              }
            }
          }
        }
      }
    }
  }
}
```

---

Happy building! 🚀

For full documentation, see `README.md`