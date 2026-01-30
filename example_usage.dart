import 'package:flutter/material.dart';
import 'sdui_parser.dart';

// ============================================================================
// COMPREHENSIVE SDUI PARSER EXAMPLES
// ============================================================================

void main() {
  // Setup action handler
  SduiParser.onAction = handleAction;
  
  // Setup data provider
  SduiParser.dataProvider = dataProvider;
  
  runApp(const MyApp());
}

// ============================================================================
// ACTION HANDLER
// ============================================================================

void handleAction(String name, Map<String, dynamic> args, BuildContext context) {
  debugPrint('Action: $name with args: $args');
  
  switch (name) {
    case 'navigate':
      final route = args['route'] ?? args['_positional']?[0];
      if (route != null) {
        Navigator.pushNamed(context, route);
      }
      break;
      
    case 'showDialog':
      final title = args['title'] ?? args['_positional']?[0] ?? 'Alert';
      final message = args['message'] ?? args['_positional']?[1] ?? '';
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      break;
      
    case 'showSnackBar':
      final message = args['message'] ?? args['value'] ?? 'Notification';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      break;
      
    case 'updateState':
      final key = args['key'];
      final value = args['value'];
      if (key != null) {
        SduiParser.instance.setState(key, value);
      }
      break;
      
    case 'fetchData':
      // Implement API call
      break;
      
    default:
      debugPrint('Unhandled action: $name');
  }
}

// ============================================================================
// DATA PROVIDER
// ============================================================================

dynamic dataProvider(String path) {
  // Mock data - replace with real data source
  final data = {
    'user': {
      'name': 'John Doe',
      'email': 'john@example.com',
      'isLoggedIn': true,
      'role': 'admin',
      'avatar': 'https://example.com/avatar.jpg',
    },
    'products': [
      {'id': 1, 'name': 'Product 1', 'price': 99.99, 'image': 'https://example.com/p1.jpg'},
      {'id': 2, 'name': 'Product 2', 'price': 149.99, 'image': 'https://example.com/p2.jpg'},
      {'id': 3, 'name': 'Product 3', 'price': 199.99, 'image': 'https://example.com/p3.jpg'},
    ],
    'cart': {
      'itemCount': 3,
      'total': 449.97,
    },
  };
  
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
}

// ============================================================================
// MAIN APP
// ============================================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SDUI Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ExampleListScreen(),
      routes: {
        '/basic': (_) => const SduiScreen(example: basicExample),
        '/forms': (_) => const SduiScreen(example: formsExample),
        '/lists': (_) => const SduiScreen(example: listsExample),
        '/conditional': (_) => const SduiScreen(example: conditionalExample),
        '/interactive': (_) => const SduiScreen(example: interactiveExample),
      },
    );
  }
}

// ============================================================================
// EXAMPLE LIST SCREEN
// ============================================================================

class ExampleListScreen extends StatelessWidget {
  const ExampleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SDUI Examples')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Basic Widgets'),
            subtitle: const Text('Text, images, buttons, layouts'),
            onTap: () => Navigator.pushNamed(context, '/basic'),
          ),
          ListTile(
            title: const Text('Forms & Inputs'),
            subtitle: const Text('TextField, checkboxes, sliders, dropdowns'),
            onTap: () => Navigator.pushNamed(context, '/forms'),
          ),
          ListTile(
            title: const Text('Dynamic Lists'),
            subtitle: const Text('ListView.builder, GridView.builder'),
            onTap: () => Navigator.pushNamed(context, '/lists'),
          ),
          ListTile(
            title: const Text('Conditional Rendering'),
            subtitle: const Text('Show/hide widgets based on conditions'),
            onTap: () => Navigator.pushNamed(context, '/conditional'),
          ),
          ListTile(
            title: const Text('Interactive Features'),
            subtitle: const Text('Gestures, dismissible, state management'),
            onTap: () => Navigator.pushNamed(context, '/interactive'),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SDUI SCREEN
// ============================================================================

class SduiScreen extends StatelessWidget {
  final Map<String, dynamic> example;
  
  const SduiScreen({super.key, required this.example});

  @override
  Widget build(BuildContext context) {
    return SduiParser.render(example, context);
  }
}

// ============================================================================
// EXAMPLE 1: BASIC WIDGETS
// ============================================================================

const basicExample = {
  "type": "scaffold",
  "args": {
    "appBar": {
      "type": "app_bar",
      "args": {
        "title": {"type": "text", "args": {"text": "Basic Widgets"}},
        "backgroundColor": "#2196F3"
      }
    },
    "body": {
      "type": "single_child_scroll_view",
      "args": {
        "child": {
          "type": "padding",
          "args": {
            "padding": 16,
            "child": {
              "type": "column",
              "args": {
                "crossAxisAlignment": "stretch",
                "children": [
                  // Card with image
                  {
                    "type": "card",
                    "args": {
                      "elevation": 4,
                      "margin": [0, 0, 0, 16],
                      "child": {
                        "type": "column",
                        "args": {
                          "crossAxisAlignment": "stretch",
                          "children": [
                            {
                              "type": "image_network",
                              "args": {
                                "url": "https://picsum.photos/400/200",
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
                                          "text": "Beautiful Card",
                                          "style": {
                                            "fontSize": 24,
                                            "fontWeight": "bold"
                                          }
                                        }
                                      },
                                      {
                                        "type": "sized_box",
                                        "args": {"height": 8}
                                      },
                                      {
                                        "type": "text",
                                        "args": {
                                          "text": "This is a card with an image and text content.",
                                          "style": {"fontSize": 16, "color": "#666666"}
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
                  },
                  // Buttons row
                  {
                    "type": "row",
                    "args": {
                      "mainAxisAlignment": "spaceEvenly",
                      "children": [
                        {
                          "type": "elevated_button",
                          "args": {
                            "backgroundColor": "#4CAF50",
                            "onPressed": "showSnackBar(message: 'Elevated clicked!')",
                            "child": {
                              "type": "text",
                              "args": {
                                "text": "Elevated",
                                "style": {"color": "#FFFFFF"}
                              }
                            }
                          }
                        },
                        {
                          "type": "text_button",
                          "args": {
                            "onPressed": "showSnackBar(message: 'Text clicked!')",
                            "child": {
                              "type": "text",
                              "args": {"text": "Text"}
                            }
                          }
                        },
                        {
                          "type": "outlined_button",
                          "args": {
                            "onPressed": "showSnackBar(message: 'Outlined clicked!')",
                            "child": {
                              "type": "text",
                              "args": {"text": "Outlined"}
                            }
                          }
                        }
                      ]
                    }
                  },
                  {
                    "type": "sized_box",
                    "args": {"height": 16}
                  },
                  // Container with gradient
                  {
                    "type": "container",
                    "args": {
                      "height": 150,
                      "borderRadius": 12,
                      "gradient": {
                        "type": "linear",
                        "colors": ["#FF6B6B", "#4ECDC4"],
                        "begin": "topLeft",
                        "end": "bottomRight"
                      },
                      "child": {
                        "type": "center",
                        "args": {
                          "child": {
                            "type": "text",
                            "args": {
                              "text": "Gradient Container",
                              "style": {
                                "fontSize": 24,
                                "color": "#FFFFFF",
                                "fontWeight": "bold"
                              }
                            }
                          }
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
};

// ============================================================================
// EXAMPLE 2: FORMS & INPUTS
// ============================================================================

const formsExample = {
  "type": "scaffold",
  "args": {
    "appBar": {
      "type": "app_bar",
      "args": {
        "title": {"type": "text", "args": {"text": "Forms & Inputs"}},
        "backgroundColor": "#9C27B0"
      }
    },
    "body": {
      "type": "single_child_scroll_view",
      "args": {
        "child": {
          "type": "padding",
          "args": {
            "padding": 16,
            "child": {
              "type": "column",
              "args": {
                "crossAxisAlignment": "stretch",
                "children": [
                  // Text Field
                  {
                    "type": "text_field",
                    "args": {
                      "labelText": "Email",
                      "hintText": "Enter your email",
                      "keyboardType": "emailAddress",
                      "prefixIcon": {
                        "type": "icon",
                        "args": {"icon": "email"}
                      },
                      "onChanged": "updateState",
                      "controllerId": "email"
                    }
                  },
                  {
                    "type": "sized_box",
                    "args": {"height": 16}
                  },
                  // Password Field
                  {
                    "type": "text_field",
                    "args": {
                      "labelText": "Password",
                      "hintText": "Enter password",
                      "obscureText": true,
                      "prefixIcon": {
                        "type": "icon",
                        "args": {"icon": "lock"}
                      }
                    }
                  },
                  {
                    "type": "sized_box",
                    "args": {"height": 24}
                  },
                  // Checkbox
                  {
                    "type": "row",
                    "args": {
                      "children": [
                        {
                          "type": "checkbox",
                          "args": {
                            "stateKey": "terms",
                            "value": false,
                            "onChanged": "updateState"
                          }
                        },
                        {
                          "type": "text",
                          "args": {"text": "I agree to terms and conditions"}
                        }
                      ]
                    }
                  },
                  {
                    "type": "sized_box",
                    "args": {"height": 16}
                  },
                  // Switch
                  {
                    "type": "row",
                    "args": {
                      "mainAxisAlignment": "spaceBetween",
                      "children": [
                        {
                          "type": "text",
                          "args": {"text": "Enable notifications"}
                        },
                        {
                          "type": "switch",
                          "args": {
                            "stateKey": "notifications",
                            "value": true,
                            "activeColor": "#4CAF50"
                          }
                        }
                      ]
                    }
                  },
                  {
                    "type": "sized_box",
                    "args": {"height": 24}
                  },
                  // Slider
                  {
                    "type": "column",
                    "args": {
                      "crossAxisAlignment": "start",
                      "children": [
                        {
                          "type": "text",
                          "args": {
                            "text": "Volume",
                            "style": {"fontWeight": "bold"}
                          }
                        },
                        {
                          "type": "slider",
                          "args": {
                            "stateKey": "volume",
                            "value": 50,
                            "min": 0,
                            "max": 100,
                            "divisions": 10,
                            "activeColor": "#2196F3"
                          }
                        }
                      ]
                    }
                  },
                  {
                    "type": "sized_box",
                    "args": {"height": 24}
                  },
                  // Dropdown
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
                        {"value": "ca", "label": "Canada"},
                        {"value": "au", "label": "Australia"}
                      ]
                    }
                  },
                  {
                    "type": "sized_box",
                    "args": {"height": 32}
                  },
                  // Submit button
                  {
                    "type": "elevated_button",
                    "args": {
                      "backgroundColor": "#4CAF50",
                      "padding": 16,
                      "onPressed": "showDialog(title: 'Success', message: 'Form submitted!')",
                      "child": {
                        "type": "text",
                        "args": {
                          "text": "Submit",
                          "style": {
                            "color": "#FFFFFF",
                            "fontSize": 16,
                            "fontWeight": "bold"
                          }
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
};

// ============================================================================
// EXAMPLE 3: DYNAMIC LISTS
// ============================================================================

const listsExample = {
  "type": "scaffold",
  "args": {
    "appBar": {
      "type": "app_bar",
      "args": {
        "title": {"type": "text", "args": {"text": "Dynamic Lists"}},
        "backgroundColor": "#FF5722"
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
            "elevation": 2,
            "child": {
              "type": "inkwell",
              "args": {
                "onTap": "showSnackBar(message: 'Tapped product')",
                "child": {
                  "type": "row",
                  "args": {
                    "children": [
                      {
                        "type": "clip_rrect",
                        "args": {
                          "borderRadius": 8,
                          "child": {
                            "type": "image_network",
                            "args": {
                              "url": "{{item.image}}",
                              "width": 80,
                              "height": 80,
                              "fit": "cover"
                            }
                          }
                        }
                      },
                      {
                        "type": "sized_box",
                        "args": {"width": 16}
                      },
                      {
                        "type": "expanded",
                        "args": {
                          "child": {
                            "type": "column",
                            "args": {
                              "crossAxisAlignment": "start",
                              "mainAxisAlignment": "center",
                              "children": [
                                {
                                  "type": "text",
                                  "args": {
                                    "text": "{{item.name}}",
                                    "style": {
                                      "fontSize": 18,
                                      "fontWeight": "bold"
                                    }
                                  }
                                },
                                {
                                  "type": "sized_box",
                                  "args": {"height": 4}
                                },
                                {
                                  "type": "text",
                                  "args": {
                                    "text": "${{item.price}}",
                                    "style": {
                                      "fontSize": 16,
                                      "color": "#4CAF50",
                                      "fontWeight": "bold"
                                    }
                                  }
                                }
                              ]
                            }
                          }
                        }
                      },
                      {
                        "type": "icon_button",
                        "args": {
                          "icon": {
                            "type": "icon",
                            "args": {
                              "icon": "shopping_cart",
                              "color": "#2196F3"
                            }
                          },
                          "onPressed": "showSnackBar(message: 'Added to cart')"
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
  }
};

// ============================================================================
// EXAMPLE 4: CONDITIONAL RENDERING
// ============================================================================

const conditionalExample = {
  "type": "scaffold",
  "args": {
    "appBar": {
      "type": "app_bar",
      "args": {
        "title": {"type": "text", "args": {"text": "Conditional Rendering"}},
        "backgroundColor": "#00BCD4"
      }
    },
    "body": {
      "type": "padding",
      "args": {
        "padding": 16,
        "child": {
          "type": "column",
          "args": {
            "crossAxisAlignment": "stretch",
            "children": [
              // Show/hide based on user login
              {
                "type": "conditional",
                "condition": "user.isLoggedIn",
                "args": {
                  "then": {
                    "type": "card",
                    "args": {
                      "child": {
                        "type": "padding",
                        "args": {
                          "padding": 16,
                          "child": {
                            "type": "column",
                            "args": {
                              "children": [
                                {
                                  "type": "text",
                                  "args": {
                                    "text": "Welcome, {{user.name}}!",
                                    "style": {
                                      "fontSize": 20,
                                      "fontWeight": "bold"
                                    }
                                  }
                                },
                                {
                                  "type": "sized_box",
                                  "args": {"height": 8}
                                },
                                {
                                  "type": "text",
                                  "args": {"text": "{{user.email}}"}
                                }
                              ]
                            }
                          }
                        }
                      }
                    }
                  },
                  "else": {
                    "type": "card",
                    "args": {
                      "child": {
                        "type": "padding",
                        "args": {
                          "padding": 16,
                          "child": {
                            "type": "column",
                            "args": {
                              "children": [
                                {
                                  "type": "text",
                                  "args": {
                                    "text": "Please log in",
                                    "style": {"fontSize": 20}
                                  }
                                },
                                {
                                  "type": "sized_box",
                                  "args": {"height": 16}
                                },
                                {
                                  "type": "elevated_button",
                                  "args": {
                                    "onPressed": "navigate(route: '/login')",
                                    "child": {
                                      "type": "text",
                                      "args": {"text": "Login"}
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
              },
              {
                "type": "sized_box",
                "args": {"height": 16}
              },
              // Visibility example
              {
                "type": "visibility",
                "args": {
                  "visible": true,
                  "child": {
                    "type": "card",
                    "args": {
                      "color": "#E8F5E9",
                      "child": {
                        "type": "padding",
                        "args": {
                          "padding": 16,
                          "child": {
                            "type": "text",
                            "args": {
                              "text": "This widget is visible",
                              "style": {"fontSize": 16}
                            }
                          }
                        }
                      }
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
};

// ============================================================================
// EXAMPLE 5: INTERACTIVE FEATURES
// ============================================================================

const interactiveExample = {
  "type": "scaffold",
  "args": {
    "appBar": {
      "type": "app_bar",
      "args": {
        "title": {"type": "text", "args": {"text": "Interactive Features"}},
        "backgroundColor": "#673AB7"
      }
    },
    "body": {
      "type": "single_child_scroll_view",
      "args": {
        "child": {
          "type": "padding",
          "args": {
            "padding": 16,
            "child": {
              "type": "column",
              "args": {
                "crossAxisAlignment": "stretch",
                "children": [
                  // Gesture Detector
                  {
                    "type": "gesture_detector",
                    "args": {
                      "onTap": "showSnackBar(message: 'Tapped!')",
                      "onDoubleTap": "showSnackBar(message: 'Double tapped!')",
                      "onLongPress": "showSnackBar(message: 'Long pressed!')",
                      "child": {
                        "type": "container",
                        "args": {
                          "height": 100,
                          "color": "#E3F2FD",
                          "borderRadius": 8,
                          "child": {
                            "type": "center",
                            "args": {
                              "child": {
                                "type": "text",
                                "args": {
                                  "text": "Tap, Double Tap, or Long Press",
                                  "style": {"fontSize": 16}
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  },
                  {
                    "type": "sized_box",
                    "args": {"height": 16}
                  },
                  // InkWell with ripple
                  {
                    "type": "inkwell",
                    "args": {
                      "onTap": "showSnackBar(message: 'InkWell tapped!')",
                      "borderRadius": 8,
                      "splashColor": "#2196F3",
                      "child": {
                        "type": "container",
                        "args": {
                          "height": 100,
                          "decoration": {
                            "color": "#FFF3E0",
                            "borderRadius": 8
                          },
                          "child": {
                            "type": "center",
                            "args": {
                              "child": {
                                "type": "text",
                                "args": {
                                  "text": "InkWell with Ripple Effect",
                                  "style": {"fontSize": 16}
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  },
                  {
                    "type": "sized_box",
                    "args": {"height": 16}
                  },
                  // Dismissible example
                  {
                    "type": "text",
                    "args": {
                      "text": "Swipe to dismiss:",
                      "style": {"fontWeight": "bold", "fontSize": 16}
                    }
                  },
                  {
                    "type": "sized_box",
                    "args": {"height": 8}
                  },
                  {
                    "type": "dismissible",
                    "args": {
                      "key": "item1",
                      "direction": "endToStart",
                      "onDismissed": "showSnackBar(message: 'Item dismissed')",
                      "background": {
                        "type": "container",
                        "args": {
                          "color": "#F44336",
                          "child": {
                            "type": "align",
                            "args": {
                              "alignment": "centerRight",
                              "child": {
                                "type": "padding",
                                "args": {
                                  "padding": 16,
                                  "child": {
                                    "type": "icon",
                                    "args": {
                                      "icon": "delete",
                                      "color": "#FFFFFF"
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      },
                      "child": {
                        "type": "card",
                        "args": {
                          "child": {
                            "type": "list_tile",
                            "args": {
                              "leading": {
                                "type": "icon",
                                "args": {"icon": "inbox"}
                              },
                              "title": {
                                "type": "text",
                                "args": {"text": "Swipe me left to delete"}
                              },
                              "subtitle": {
                                "type": "text",
                                "args": {"text": "This item can be dismissed"}
                              }
                            }
                          }
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
};