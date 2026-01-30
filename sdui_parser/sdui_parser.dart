import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

// --- TYPE DEFINITIONS ---
typedef SduiActionHandler = void Function(String functionName, Map<String, dynamic> args, BuildContext context);
typedef SduiDataProvider = dynamic Function(String path);
typedef SduiValidator = String? Function(String? value);

// --- MAIN PARSER CLASS ---
class SduiParser {
  // Singleton Pattern
  static final SduiParser instance = SduiParser._();
  SduiParser._();

  // Global handlers
  static SduiActionHandler onAction = (name, args, ctx) {
    debugPrint("Action Triggered: $name with args $args");
  };

  static SduiDataProvider? dataProvider;
  
  // Schema version for backward compatibility
  static const String currentVersion = '1.0.0';
  
  // State management
  final Map<String, dynamic> _globalState = {};
  final Map<String, TextEditingController> _textControllers = {};
  final Map<String, ValueNotifier> _notifiers = {};

  // Widget registry
  final Map<String, Widget Function(Map<String, dynamic> args, BuildContext ctx)> _widgetBuilders = {
    // === STRUCTURE ===
    'scaffold': (args, ctx) => _buildScaffold(args, ctx),
    'app_bar': (args, ctx) => _buildAppBar(args, ctx),
    'safe_area': (args, ctx) => _buildSafeArea(args, ctx),
    'material_app': (args, ctx) => _buildMaterialApp(args, ctx),
    
    // === LAYOUTS ===
    'column': (args, ctx) => _buildColumn(args, ctx),
    'row': (args, ctx) => _buildRow(args, ctx),
    'stack': (args, ctx) => _buildStack(args, ctx),
    'container': (args, ctx) => _buildContainer(args, ctx),
    'sized_box': (args, ctx) => _buildSizedBox(args, ctx),
    'padding': (args, ctx) => _buildPadding(args, ctx),
    'center': (args, ctx) => Center(child: render(args['child'], ctx)),
    'align': (args, ctx) => _buildAlign(args, ctx),
    'expanded': (args, ctx) => _buildExpanded(args, ctx),
    'flexible': (args, ctx) => _buildFlexible(args, ctx),
    'wrap': (args, ctx) => _buildWrap(args, ctx),
    'spacer': (args, ctx) => _buildSpacer(args, ctx),
    'divider': (args, ctx) => _buildDivider(args, ctx),
    'positioned': (args, ctx) => _buildPositioned(args, ctx),
    
    // === SCROLLING ===
    'single_child_scroll_view': (args, ctx) => _buildSingleChildScrollView(args, ctx),
    'list_view': (args, ctx) => _buildListView(args, ctx),
    'list_view_builder': (args, ctx) => _buildListViewBuilder(args, ctx),
    'grid_view': (args, ctx) => _buildGridView(args, ctx),
    'grid_view_builder': (args, ctx) => _buildGridViewBuilder(args, ctx),
    'page_view': (args, ctx) => _buildPageView(args, ctx),
    'refreshable': (args, ctx) => _buildRefreshIndicator(args, ctx),
    
    // === CONTENT ===
    'text': (args, ctx) => _buildText(args, ctx),
    'rich_text': (args, ctx) => _buildRichText(args, ctx),
    'icon': (args, ctx) => _buildIcon(args, ctx),
    'image_network': (args, ctx) => _buildImageNetwork(args, ctx),
    'image_asset': (args, ctx) => _buildImageAsset(args, ctx),
    'circular_progress_indicator': (args, ctx) => _buildCircularProgressIndicator(args, ctx),
    'linear_progress_indicator': (args, ctx) => _buildLinearProgressIndicator(args, ctx),
    'placeholder': (args, ctx) => _buildPlaceholder(args, ctx),
    
    // === MATERIAL COMPONENTS ===
    'card': (args, ctx) => _buildCard(args, ctx),
    'list_tile': (args, ctx) => _buildListTile(args, ctx),
    'chip': (args, ctx) => _buildChip(args, ctx),
    'badge': (args, ctx) => _buildBadge(args, ctx),
    'tooltip': (args, ctx) => _buildTooltip(args, ctx),
    
    // === BUTTONS ===
    'elevated_button': (args, ctx) => _buildElevatedButton(args, ctx),
    'text_button': (args, ctx) => _buildTextButton(args, ctx),
    'outlined_button': (args, ctx) => _buildOutlinedButton(args, ctx),
    'icon_button': (args, ctx) => _buildIconButton(args, ctx),
    'floating_action_button': (args, ctx) => _buildFloatingActionButton(args, ctx),
    
    // === FORM INPUTS ===
    'text_field': (args, ctx) => _buildTextField(args, ctx),
    'checkbox': (args, ctx) => _buildCheckbox(args, ctx),
    'switch': (args, ctx) => _buildSwitch(args, ctx),
    'radio': (args, ctx) => _buildRadio(args, ctx),
    'slider': (args, ctx) => _buildSlider(args, ctx),
    'dropdown': (args, ctx) => _buildDropdown(args, ctx),
    'date_picker': (args, ctx) => _buildDatePicker(args, ctx),
    'time_picker': (args, ctx) => _buildTimePicker(args, ctx),
    
    // === GESTURES ===
    'gesture_detector': (args, ctx) => _buildGestureDetector(args, ctx),
    'inkwell': (args, ctx) => _buildInkWell(args, ctx),
    'dismissible': (args, ctx) => _buildDismissible(args, ctx),
    
    // === NAVIGATION ===
    'bottom_navigation_bar': (args, ctx) => _buildBottomNavigationBar(args, ctx),
    'drawer': (args, ctx) => _buildDrawer(args, ctx),
    'tab_bar': (args, ctx) => _buildTabBar(args, ctx),
    'tab_bar_view': (args, ctx) => _buildTabBarView(args, ctx),
    
    // === DIALOGS & OVERLAYS ===
    'alert_dialog': (args, ctx) => _buildAlertDialog(args, ctx),
    'bottom_sheet': (args, ctx) => _buildBottomSheet(args, ctx),
    'snack_bar': (args, ctx) => _buildSnackBar(args, ctx),
    
    // === DECORATIVE ===
    'opacity': (args, ctx) => _buildOpacity(args, ctx),
    'transform': (args, ctx) => _buildTransform(args, ctx),
    'clip_rect': (args, ctx) => _buildClipRect(args, ctx),
    'clip_rrect': (args, ctx) => _buildClipRRect(args, ctx),
    'clip_oval': (args, ctx) => _buildClipOval(args, ctx),
    'backdrop_filter': (args, ctx) => _buildBackdropFilter(args, ctx),
    
    // === CONDITIONAL & CONTROL ===
    'conditional': (args, ctx) => _buildConditional(args, ctx),
    'visibility': (args, ctx) => _buildVisibility(args, ctx),
    'stateful_builder': (args, ctx) => _buildStatefulBuilder(args, ctx),
    
    // === CUPERTINO (iOS) ===
    'cupertino_button': (args, ctx) => _buildCupertinoButton(args, ctx),
    'cupertino_switch': (args, ctx) => _buildCupertinoSwitch(args, ctx),
    'cupertino_slider': (args, ctx) => _buildCupertinoSlider(args, ctx),
  };

  // === MAIN RENDERER ===
  static Widget render(dynamic json, BuildContext context) {
    if (json == null) return const SizedBox.shrink();
    if (json is! Map<String, dynamic>) return const SizedBox.shrink();

    // Handle conditional rendering
    if (json['condition'] != null) {
      if (!_evaluateCondition(json['condition'])) {
        return const SizedBox.shrink();
      }
    }

    final String type = json['type'] ?? 'unknown';
    final Map<String, dynamic> args = json['args'] ?? {};

    // Process data binding in args
    final processedArgs = _processDataBinding(args);

    final builder = instance._widgetBuilders[type];
    if (builder != null) {
      try {
        return builder(processedArgs, context);
      } catch (e, stackTrace) {
        debugPrint("Error building $type: $e\n$stackTrace");
        return _buildErrorWidget("Error building $type: $e");
      }
    }

    return _buildErrorWidget("Unknown widget type: $type");
  }

  // === DATA BINDING ===
  static Map<String, dynamic> _processDataBinding(Map<String, dynamic> args) {
    final processed = <String, dynamic>{};
    
    args.forEach((key, value) {
      if (value is String && value.startsWith('{{') && value.endsWith('}}')) {
        // Variable binding: {{user.name}}
        final path = value.substring(2, value.length - 2).trim();
        processed[key] = _resolveDataPath(path);
      } else if (value is Map) {
        processed[key] = _processDataBinding(value as Map<String, dynamic>);
      } else if (value is List) {
        processed[key] = value.map((item) {
          if (item is Map<String, dynamic>) {
            return _processDataBinding(item);
          }
          return item;
        }).toList();
      } else {
        processed[key] = value;
      }
    });
    
    return processed;
  }

  static dynamic _resolveDataPath(String path) {
    if (dataProvider != null) {
      return dataProvider!(path);
    }
    
    // Fallback to global state
    final parts = path.split('.');
    dynamic current = instance._globalState;
    
    for (final part in parts) {
      if (current is Map && current.containsKey(part)) {
        current = current[part];
      } else {
        return null;
      }
    }
    
    return current;
  }

  // === CONDITION EVALUATION ===
  static bool _evaluateCondition(dynamic condition) {
    if (condition is bool) return condition;
    if (condition is String) {
      // Simple variable check: "user.isLoggedIn"
      final value = _resolveDataPath(condition);
      if (value is bool) return value;
      return value != null;
    }
    if (condition is Map) {
      // Complex conditions: {"op": "equals", "left": "user.role", "right": "admin"}
      final op = condition['op'] as String?;
      switch (op) {
        case 'equals':
          return _resolveDataPath(condition['left']) == _resolveDataPath(condition['right']);
        case 'notEquals':
          return _resolveDataPath(condition['left']) != _resolveDataPath(condition['right']);
        case 'greaterThan':
          return (_resolveDataPath(condition['left']) ?? 0) > (_resolveDataPath(condition['right']) ?? 0);
        case 'lessThan':
          return (_resolveDataPath(condition['left']) ?? 0) < (_resolveDataPath(condition['right']) ?? 0);
        case 'and':
          return _evaluateCondition(condition['conditions'][0]) && 
                 _evaluateCondition(condition['conditions'][1]);
        case 'or':
          return _evaluateCondition(condition['conditions'][0]) || 
                 _evaluateCondition(condition['conditions'][1]);
        case 'not':
          return !_evaluateCondition(condition['condition']);
      }
    }
    return false;
  }

  // === STATE MANAGEMENT ===
  void setState(String key, dynamic value) {
    _globalState[key] = value;
    _notifiers[key]?.value = value;
  }

  dynamic getState(String key) {
    return _globalState[key];
  }

  ValueNotifier getNotifier(String key) {
    return _notifiers.putIfAbsent(key, () => ValueNotifier(_globalState[key]));
  }

  TextEditingController getTextController(String key) {
    return _textControllers.putIfAbsent(key, () => TextEditingController());
  }

  void dispose() {
    _textControllers.forEach((key, controller) => controller.dispose());
    _textControllers.clear();
    _notifiers.clear();
    _globalState.clear();
  }

  // === ACTION HANDLING ===
  static void _handleAction(dynamic actionData, BuildContext context) {
    if (actionData == null) return;
    
    if (actionData is String) {
      // Simple string action
      _parseAndExecuteAction(actionData, context);
    } else if (actionData is Map<String, dynamic>) {
      // Structured action
      final name = actionData['name'] as String;
      final args = actionData['args'] as Map<String, dynamic>? ?? {};
      onAction(name, args, context);
    }
  }

  static void _parseAndExecuteAction(String actionString, BuildContext context) {
    if (actionString.isEmpty) return;
    
    // Parse "functionName(arg1, arg2)" or "functionName(key: value)"
    final RegExp regex = RegExp(r"(\w+)\((.*)\)");
    final match = regex.firstMatch(actionString);

    if (match != null) {
      final name = match.group(1)!;
      final rawArgs = match.group(2)!;
      
      // Parse arguments
      final args = <String, dynamic>{};
      if (rawArgs.isNotEmpty) {
        // Check if it's key-value pairs or positional
        if (rawArgs.contains(':')) {
          // Key-value: "navigate(route: '/home', replace: true)"
          final pairs = rawArgs.split(',');
          for (final pair in pairs) {
            final parts = pair.split(':');
            if (parts.length == 2) {
              final key = parts[0].trim();
              final value = parts[1].trim().replaceAll(RegExp(r"^['\"]|['\"]$"), "");
              args[key] = _parseValue(value);
            }
          }
        } else {
          // Positional: "navigate('/home', true)"
          final values = rawArgs
              .split(',')
              .map((e) => e.trim().replaceAll(RegExp(r"^['\"]|['\"]$"), ""))
              .toList();
          args['_positional'] = values;
        }
      }

      onAction(name, args, context);
    } else {
      // Simple string action without parentheses
      onAction(actionString, {}, context);
    }
  }

  static dynamic _parseValue(String value) {
    if (value == 'true') return true;
    if (value == 'false') return false;
    if (value == 'null') return null;
    final number = num.tryParse(value);
    if (number != null) return number;
    return value;
  }

  // === BUILDER METHODS - STRUCTURE ===

  static Widget _buildScaffold(Map<String, dynamic> args, BuildContext ctx) {
    return Scaffold(
      appBar: args['appBar'] != null ? render(args['appBar'], ctx) as PreferredSizeWidget : null,
      body: render(args['body'], ctx),
      backgroundColor: _parseColor(args['backgroundColor']),
      floatingActionButton: args['floatingActionButton'] != null ? render(args['floatingActionButton'], ctx) : null,
      floatingActionButtonLocation: _parseFloatingActionButtonLocation(args['floatingActionButtonLocation']),
      bottomNavigationBar: args['bottomNavigationBar'] != null ? render(args['bottomNavigationBar'], ctx) : null,
      drawer: args['drawer'] != null ? render(args['drawer'], ctx) as Drawer : null,
      endDrawer: args['endDrawer'] != null ? render(args['endDrawer'], ctx) as Drawer : null,
      bottomSheet: args['bottomSheet'] != null ? render(args['bottomSheet'], ctx) : null,
      extendBody: args['extendBody'] ?? false,
      extendBodyBehindAppBar: args['extendBodyBehindAppBar'] ?? false,
      resizeToAvoidBottomInset: args['resizeToAvoidBottomInset'] ?? true,
    );
  }

  static Widget _buildAppBar(Map<String, dynamic> args, BuildContext ctx) {
    return AppBar(
      title: render(args['title'], ctx),
      backgroundColor: _parseColor(args['backgroundColor']),
      foregroundColor: _parseColor(args['foregroundColor']),
      centerTitle: args['centerTitle'] ?? false,
      elevation: _toDouble(args['elevation']),
      leading: args['leading'] != null ? render(args['leading'], ctx) : null,
      automaticallyImplyLeading: args['automaticallyImplyLeading'] ?? true,
      actions: _buildChildrenList(args['actions'], ctx),
      bottom: args['bottom'] != null ? render(args['bottom'], ctx) as PreferredSizeWidget : null,
      flexibleSpace: args['flexibleSpace'] != null ? render(args['flexibleSpace'], ctx) : null,
      shadowColor: _parseColor(args['shadowColor']),
      surfaceTintColor: _parseColor(args['surfaceTintColor']),
    );
  }

  static Widget _buildSafeArea(Map<String, dynamic> args, BuildContext ctx) {
    return SafeArea(
      top: args['top'] ?? true,
      bottom: args['bottom'] ?? true,
      left: args['left'] ?? true,
      right: args['right'] ?? true,
      minimum: _parsePadding(args['minimum']),
      child: render(args['child'], ctx),
    );
  }

  static Widget _buildMaterialApp(Map<String, dynamic> args, BuildContext ctx) {
    return MaterialApp(
      title: args['title'] ?? '',
      theme: _parseThemeData(args['theme']),
      darkTheme: _parseThemeData(args['darkTheme']),
      themeMode: _parseThemeMode(args['themeMode']),
      home: render(args['home'], ctx),
      debugShowCheckedModeBanner: args['debugShowCheckedModeBanner'] ?? true,
    );
  }

  // === BUILDER METHODS - LAYOUTS ===

  static Widget _buildColumn(Map<String, dynamic> args, BuildContext ctx) {
    return Column(
      mainAxisAlignment: _parseMainAxis(args['mainAxisAlignment']),
      crossAxisAlignment: _parseCrossAxis(args['crossAxisAlignment']),
      mainAxisSize: _parseMainAxisSize(args['mainAxisSize']),
      children: _buildChildrenList(args['children'], ctx),
    );
  }

  static Widget _buildRow(Map<String, dynamic> args, BuildContext ctx) {
    return Row(
      mainAxisAlignment: _parseMainAxis(args['mainAxisAlignment']),
      crossAxisAlignment: _parseCrossAxis(args['crossAxisAlignment']),
      mainAxisSize: _parseMainAxisSize(args['mainAxisSize']),
      children: _buildChildrenList(args['children'], ctx),
    );
  }

  static Widget _buildStack(Map<String, dynamic> args, BuildContext ctx) {
    return Stack(
      alignment: _parseAlignment(args['alignment']) ?? Alignment.topLeft,
      fit: _parseStackFit(args['fit']),
      clipBehavior: _parseClip(args['clipBehavior']),
      children: _buildChildrenList(args['children'], ctx),
    );
  }

  static Widget _buildContainer(Map<String, dynamic> args, BuildContext ctx) {
    final borderRadius = _toDouble(args['borderRadius']) ?? 0;
    final borderColor = _parseColor(args['borderColor']);
    final borderWidth = _toDouble(args['borderWidth']) ?? 1.0;
    
    BoxDecoration? decoration;
    if (args['gradient'] != null || args['color'] != null || borderRadius > 0 || borderColor != null || args['boxShadow'] != null) {
      decoration = BoxDecoration(
        color: _parseColor(args['color']),
        gradient: _parseGradient(args['gradient']),
        borderRadius: borderRadius > 0 ? BorderRadius.circular(borderRadius) : null,
        border: borderColor != null ? Border.all(color: borderColor, width: borderWidth) : null,
        boxShadow: _parseBoxShadow(args['boxShadow']),
        shape: args['shape'] == 'circle' ? BoxShape.circle : BoxShape.rectangle,
        image: args['backgroundImage'] != null ? DecorationImage(
          image: NetworkImage(args['backgroundImage']),
          fit: _parseBoxFit(args['backgroundImageFit']),
        ) : null,
      );
    }

    return Container(
      width: _toDouble(args['width']),
      height: _toDouble(args['height']),
      padding: _parsePadding(args['padding']),
      margin: _parsePadding(args['margin']),
      alignment: _parseAlignment(args['alignment']),
      decoration: decoration,
      constraints: _parseBoxConstraints(args['constraints']),
      transform: _parseMatrix4(args['transform']),
      clipBehavior: _parseClip(args['clipBehavior']),
      child: render(args['child'], ctx),
    );
  }

  static Widget _buildSizedBox(Map<String, dynamic> args, BuildContext ctx) {
    return SizedBox(
      width: _toDouble(args['width']),
      height: _toDouble(args['height']),
      child: args['child'] != null ? render(args['child'], ctx) : null,
    );
  }

  static Widget _buildPadding(Map<String, dynamic> args, BuildContext ctx) {
    return Padding(
      padding: _parsePadding(args['padding']),
      child: render(args['child'], ctx),
    );
  }

  static Widget _buildAlign(Map<String, dynamic> args, BuildContext ctx) {
    return Align(
      alignment: _parseAlignment(args['alignment']) ?? Alignment.center,
      widthFactor: _toDouble(args['widthFactor']),
      heightFactor: _toDouble(args['heightFactor']),
      child: render(args['child'], ctx),
    );
  }

  static Widget _buildExpanded(Map<String, dynamic> args, BuildContext ctx) {
    return Expanded(
      flex: args['flex'] ?? 1,
      child: render(args['child'], ctx),
    );
  }

  static Widget _buildFlexible(Map<String, dynamic> args, BuildContext ctx) {
    return Flexible(
      flex: args['flex'] ?? 1,
      fit: _parseFlexFit(args['fit']),
      child: render(args['child'], ctx),
    );
  }

  static Widget _buildWrap(Map<String, dynamic> args, BuildContext ctx) {
    return Wrap(
      direction: _parseAxis(args['direction']),
      alignment: _parseWrapAlignment(args['alignment']),
      spacing: _toDouble(args['spacing']) ?? 0.0,
      runSpacing: _toDouble(args['runSpacing']) ?? 0.0,
      crossAxisAlignment: _parseWrapCrossAlignment(args['crossAxisAlignment']),
      children: _buildChildrenList(args['children'], ctx),
    );
  }

  static Widget _buildSpacer(Map<String, dynamic> args, BuildContext ctx) {
    return Spacer(flex: args['flex'] ?? 1);
  }

  static Widget _buildDivider(Map<String, dynamic> args, BuildContext ctx) {
    return Divider(
      height: _toDouble(args['height']),
      thickness: _toDouble(args['thickness']),
      indent: _toDouble(args['indent']),
      endIndent: _toDouble(args['endIndent']),
      color: _parseColor(args['color']),
    );
  }

  static Widget _buildPositioned(Map<String, dynamic> args, BuildContext ctx) {
    return Positioned(
      left: _toDouble(args['left']),
      top: _toDouble(args['top']),
      right: _toDouble(args['right']),
      bottom: _toDouble(args['bottom']),
      width: _toDouble(args['width']),
      height: _toDouble(args['height']),
      child: render(args['child'], ctx),
    );
  }

  // === BUILDER METHODS - SCROLLING ===

  static Widget _buildSingleChildScrollView(Map<String, dynamic> args, BuildContext ctx) {
    return SingleChildScrollView(
      scrollDirection: _parseAxis(args['scrollDirection']),
      reverse: args['reverse'] ?? false,
      padding: _parsePadding(args['padding']),
      physics: _parseScrollPhysics(args['physics']),
      child: render(args['child'], ctx),
    );
  }

  static Widget _buildListView(Map<String, dynamic> args, BuildContext ctx) {
    final children = _buildChildrenList(args['children'], ctx);
    return ListView(
      scrollDirection: _parseAxis(args['scrollDirection']),
      reverse: args['reverse'] ?? false,
      shrinkWrap: args['shrinkWrap'] ?? false,
      physics: _parseScrollPhysics(args['physics']),
      padding: _parsePadding(args['padding']),
      children: children,
    );
  }

  static Widget _buildListViewBuilder(Map<String, dynamic> args, BuildContext ctx) {
    final dataPath = args['data'] as String?;
    final itemTemplate = args['itemTemplate'];
    
    if (dataPath == null || itemTemplate == null) {
      return _buildErrorWidget('ListView.builder requires "data" and "itemTemplate"');
    }

    final data = _resolveDataPath(dataPath);
    if (data is! List) {
      return _buildErrorWidget('Data must be a list');
    }

    return ListView.builder(
      scrollDirection: _parseAxis(args['scrollDirection']),
      reverse: args['reverse'] ?? false,
      shrinkWrap: args['shrinkWrap'] ?? false,
      physics: _parseScrollPhysics(args['physics']),
      padding: _parsePadding(args['padding']),
      itemCount: data.length,
      itemBuilder: (context, index) {
        // Make item data available
        final previousProvider = dataProvider;
        dataProvider = (path) {
          if (path == 'item') return data[index];
          if (path == 'index') return index;
          if (path.startsWith('item.')) {
            final key = path.substring(5);
            return data[index][key];
          }
          return previousProvider?.call(path);
        };
        
        final widget = render(itemTemplate, context);
        dataProvider = previousProvider;
        return widget;
      },
    );
  }

  static Widget _buildGridView(Map<String, dynamic> args, BuildContext ctx) {
    final crossAxisCount = args['crossAxisCount'] as int? ?? 2;
    return GridView.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: _toDouble(args['mainAxisSpacing']) ?? 0.0,
      crossAxisSpacing: _toDouble(args['crossAxisSpacing']) ?? 0.0,
      childAspectRatio: _toDouble(args['childAspectRatio']) ?? 1.0,
      padding: _parsePadding(args['padding']),
      children: _buildChildrenList(args['children'], ctx),
    );
  }

  static Widget _buildGridViewBuilder(Map<String, dynamic> args, BuildContext ctx) {
    final dataPath = args['data'] as String?;
    final itemTemplate = args['itemTemplate'];
    final crossAxisCount = args['crossAxisCount'] as int? ?? 2;
    
    if (dataPath == null || itemTemplate == null) {
      return _buildErrorWidget('GridView.builder requires "data" and "itemTemplate"');
    }

    final data = _resolveDataPath(dataPath);
    if (data is! List) {
      return _buildErrorWidget('Data must be a list');
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: _toDouble(args['mainAxisSpacing']) ?? 0.0,
        crossAxisSpacing: _toDouble(args['crossAxisSpacing']) ?? 0.0,
        childAspectRatio: _toDouble(args['childAspectRatio']) ?? 1.0,
      ),
      padding: _parsePadding(args['padding']),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final previousProvider = dataProvider;
        dataProvider = (path) {
          if (path == 'item') return data[index];
          if (path == 'index') return index;
          if (path.startsWith('item.')) {
            final key = path.substring(5);
            return data[index][key];
          }
          return previousProvider?.call(path);
        };
        
        final widget = render(itemTemplate, context);
        dataProvider = previousProvider;
        return widget;
      },
    );
  }

  static Widget _buildPageView(Map<String, dynamic> args, BuildContext ctx) {
    return PageView(
      scrollDirection: _parseAxis(args['scrollDirection']),
      reverse: args['reverse'] ?? false,
      physics: _parseScrollPhysics(args['physics']),
      pageSnapping: args['pageSnapping'] ?? true,
      children: _buildChildrenList(args['children'], ctx),
    );
  }

  static Widget _buildRefreshIndicator(Map<String, dynamic> args, BuildContext ctx) {
    return RefreshIndicator(
      onRefresh: () async {
        _handleAction(args['onRefresh'], ctx);
        await Future.delayed(const Duration(milliseconds: 500));
      },
      color: _parseColor(args['color']),
      backgroundColor: _parseColor(args['backgroundColor']),
      child: render(args['child'], ctx),
    );
  }

  // === BUILDER METHODS - CONTENT ===

  static Widget _buildText(Map<String, dynamic> args, BuildContext ctx) {
    return Text(
      args['text']?.toString() ?? '',
      textAlign: _parseTextAlign(args['textAlign']),
      maxLines: args['maxLines'],
      overflow: _parseTextOverflow(args['overflow']),
      softWrap: args['softWrap'] ?? true,
      style: _parseTextStyle(args['style']),
      semanticsLabel: args['semanticsLabel'],
    );
  }

  static Widget _buildRichText(Map<String, dynamic> args, BuildContext ctx) {
    final spans = args['spans'] as List?;
    if (spans == null) return const SizedBox.shrink();

    return RichText(
      text: TextSpan(
        children: spans.map((span) {
          return TextSpan(
            text: span['text']?.toString() ?? '',
            style: _parseTextStyle(span['style']),
          );
        }).toList(),
      ),
      textAlign: _parseTextAlign(args['textAlign']),
      maxLines: args['maxLines'],
      overflow: _parseTextOverflow(args['overflow']),
    );
  }

  static Widget _buildIcon(Map<String, dynamic> args, BuildContext ctx) {
    return Icon(
      _parseIconData(args['icon']),
      size: _toDouble(args['size']),
      color: _parseColor(args['color']),
      semanticLabel: args['semanticLabel'],
    );
  }

  static Widget _buildImageNetwork(Map<String, dynamic> args, BuildContext ctx) {
    return Image.network(
      args['url'] ?? '',
      width: _toDouble(args['width']),
      height: _toDouble(args['height']),
      fit: _parseBoxFit(args['fit']),
      alignment: _parseAlignment(args['alignment']) ?? Alignment.center,
      repeat: _parseImageRepeat(args['repeat']),
      color: _parseColor(args['color']),
      colorBlendMode: _parseBlendMode(args['colorBlendMode']),
      loadingBuilder: args['showLoading'] == true
          ? (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            }
          : null,
      errorBuilder: (ctx, error, stack) => Container(
        width: _toDouble(args['width']),
        height: _toDouble(args['height']),
        color: Colors.grey[300],
        child: const Icon(Icons.error, color: Colors.red),
      ),
    );
  }

  static Widget _buildImageAsset(Map<String, dynamic> args, BuildContext ctx) {
    return Image.asset(
      args['path'] ?? '',
      width: _toDouble(args['width']),
      height: _toDouble(args['height']),
      fit: _parseBoxFit(args['fit']),
      alignment: _parseAlignment(args['alignment']) ?? Alignment.center,
      color: _parseColor(args['color']),
      colorBlendMode: _parseBlendMode(args['colorBlendMode']),
      errorBuilder: (ctx, error, stack) => const Icon(Icons.error, color: Colors.red),
    );
  }

  static Widget _buildCircularProgressIndicator(Map<String, dynamic> args, BuildContext ctx) {
    return CircularProgressIndicator(
      value: _toDouble(args['value']),
      backgroundColor: _parseColor(args['backgroundColor']),
      color: _parseColor(args['color']),
      strokeWidth: _toDouble(args['strokeWidth']) ?? 4.0,
    );
  }

  static Widget _buildLinearProgressIndicator(Map<String, dynamic> args, BuildContext ctx) {
    return LinearProgressIndicator(
      value: _toDouble(args['value']),
      backgroundColor: _parseColor(args['backgroundColor']),
      color: _parseColor(args['color']),
      minHeight: _toDouble(args['minHeight']),
    );
  }

  static Widget _buildPlaceholder(Map<String, dynamic> args, BuildContext ctx) {
    return Placeholder(
      color: _parseColor(args['color']) ?? Colors.grey,
      strokeWidth: _toDouble(args['strokeWidth']) ?? 2.0,
      fallbackWidth: _toDouble(args['fallbackWidth']) ?? 400.0,
      fallbackHeight: _toDouble(args['fallbackHeight']) ?? 400.0,
    );
  }

  // === BUILDER METHODS - MATERIAL COMPONENTS ===

  static Widget _buildCard(Map<String, dynamic> args, BuildContext ctx) {
    return Card(
      color: _parseColor(args['color']),
      shadowColor: _parseColor(args['shadowColor']),
      surfaceTintColor: _parseColor(args['surfaceTintColor']),
      elevation: _toDouble(args['elevation']),
      shape: _parseShapeBorder(args['shape'], args['borderRadius']),
      margin: _parsePadding(args['margin']),
      clipBehavior: _parseClip(args['clipBehavior']),
      child: render(args['child'], ctx),
    );
  }

  static Widget _buildListTile(Map<String, dynamic> args, BuildContext ctx) {
    return ListTile(
      leading: args['leading'] != null ? render(args['leading'], ctx) : null,
      title: args['title'] != null ? render(args['title'], ctx) : null,
      subtitle: args['subtitle'] != null ? render(args['subtitle'], ctx) : null,
      trailing: args['trailing'] != null ? render(args['trailing'], ctx) : null,
      isThreeLine: args['isThreeLine'] ?? false,
      dense: args['dense'],
      contentPadding: _parsePadding(args['contentPadding']),
      enabled: args['enabled'] ?? true,
      onTap: args['onTap'] != null ? () => _handleAction(args['onTap'], ctx) : null,
      onLongPress: args['onLongPress'] != null ? () => _handleAction(args['onLongPress'], ctx) : null,
      selected: args['selected'] ?? false,
      selectedColor: _parseColor(args['selectedColor']),
      tileColor: _parseColor(args['tileColor']),
      shape: _parseShapeBorder(args['shape'], args['borderRadius']),
    );
  }

  static Widget _buildChip(Map<String, dynamic> args, BuildContext ctx) {
    return Chip(
      label: render(args['label'], ctx),
      avatar: args['avatar'] != null ? render(args['avatar'], ctx) : null,
      deleteIcon: args['deleteIcon'] != null ? render(args['deleteIcon'], ctx) : null,
      onDeleted: args['onDeleted'] != null ? () => _handleAction(args['onDeleted'], ctx) : null,
      backgroundColor: _parseColor(args['backgroundColor']),
      labelStyle: _parseTextStyle(args['labelStyle']),
      padding: _parsePadding(args['padding']),
      shape: _parseShapeBorder(args['shape'], args['borderRadius']),
    );
  }

  static Widget _buildBadge(Map<String, dynamic> args, BuildContext ctx) {
    return Badge(
      label: args['label'] != null ? render(args['label'], ctx) : null,
      backgroundColor: _parseColor(args['backgroundColor']),
      textColor: _parseColor(args['textColor']),
      alignment: _parseAlignment(args['alignment']) ?? AlignmentDirectional.topEnd,
      child: render(args['child'], ctx),
    );
  }

  static Widget _buildTooltip(Map<String, dynamic> args, BuildContext ctx) {
    return Tooltip(
      message: args['message'] ?? '',
      decoration: args['backgroundColor'] != null
          ? BoxDecoration(
              color: _parseColor(args['backgroundColor']),
              borderRadius: BorderRadius.circular(4),
            )
          : null,
      textStyle: _parseTextStyle(args['textStyle']),
      waitDuration: Duration(milliseconds: args['waitDuration'] ?? 0),
      child: render(args['child'], ctx),
    );
  }

  // === BUILDER METHODS - BUTTONS ===

  static Widget _buildElevatedButton(Map<String, dynamic> args, BuildContext ctx) {
    return ElevatedButton(
      onPressed: args['onPressed'] != null ? () => _handleAction(args['onPressed'], ctx) : null,
      onLongPress: args['onLongPress'] != null ? () => _handleAction(args['onLongPress'], ctx) : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: _parseColor(args['backgroundColor']),
        foregroundColor: _parseColor(args['foregroundColor']),
        disabledBackgroundColor: _parseColor(args['disabledBackgroundColor']),
        disabledForegroundColor: _parseColor(args['disabledForegroundColor']),
        elevation: _toDouble(args['elevation']),
        padding: _parsePadding(args['padding']),
        minimumSize: _parseSize(args['minimumSize']),
        shape: _parseShapeBorder(args['shape'], args['borderRadius']),
      ),
      child: render(args['child'], ctx),
    );
  }

  static Widget _buildTextButton(Map<String, dynamic> args, BuildContext ctx) {
    return TextButton(
      onPressed: args['onPressed'] != null ? () => _handleAction(args['onPressed'], ctx) : null,
      onLongPress: args['onLongPress'] != null ? () => _handleAction(args['onLongPress'], ctx) : null,
      style: TextButton.styleFrom(
        foregroundColor: _parseColor(args['foregroundColor']),
        padding: _parsePadding(args['padding']),
        minimumSize: _parseSize(args['minimumSize']),
        shape: _parseShapeBorder(args['shape'], args['borderRadius']),
      ),
      child: render(args['child'], ctx),
    );
  }

  static Widget _buildOutlinedButton(Map<String, dynamic> args, BuildContext ctx) {
    return OutlinedButton(
      onPressed: args['onPressed'] != null ? () => _handleAction(args['onPressed'], ctx) : null,
      onLongPress: args['onLongPress'] != null ? () => _handleAction(args['onLongPress'], ctx) : null,
      style: OutlinedButton.styleFrom(
        foregroundColor: _parseColor(args['foregroundColor']),
        side: BorderSide(
          color: _parseColor(args['borderColor']) ?? Colors.grey,
          width: _toDouble(args['borderWidth']) ?? 1.0,
        ),
        padding: _parsePadding(args['padding']),
        minimumSize: _parseSize(args['minimumSize']),
        shape: _parseShapeBorder(args['shape'], args['borderRadius']),
      ),
      child: render(args['child'], ctx),
    );
  }

  static Widget _buildIconButton(Map<String, dynamic> args, BuildContext ctx) {
    return IconButton(
      onPressed: args['onPressed'] != null ? () => _handleAction(args['onPressed'], ctx) : null,
      icon: render(args['icon'], ctx),
      iconSize: _toDouble(args['iconSize']),
      color: _parseColor(args['color']),
      disabledColor: _parseColor(args['disabledColor']),
      tooltip: args['tooltip'],
      padding: _parsePadding(args['padding']),
    );
  }

  static Widget _buildFloatingActionButton(Map<String, dynamic> args, BuildContext ctx) {
    return FloatingActionButton(
      onPressed: args['onPressed'] != null ? () => _handleAction(args['onPressed'], ctx) : null,
      backgroundColor: _parseColor(args['backgroundColor']),
      foregroundColor: _parseColor(args['foregroundColor']),
      elevation: _toDouble(args['elevation']),
      tooltip: args['tooltip'],
      mini: args['mini'] ?? false,
      shape: args['shape'] == 'circle' ? const CircleBorder() : null,
      child: render(args['child'], ctx),
    );
  }

  // === BUILDER METHODS - FORM INPUTS ===

  static Widget _buildTextField(Map<String, dynamic> args, BuildContext ctx) {
    final controllerId = args['controllerId'] as String?;
    final controller = controllerId != null ? instance.getTextController(controllerId) : null;
    
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: args['labelText'],
        hintText: args['hintText'],
        helperText: args['helperText'],
        errorText: args['errorText'],
        prefixIcon: args['prefixIcon'] != null ? render(args['prefixIcon'], ctx) : null,
        suffixIcon: args['suffixIcon'] != null ? render(args['suffixIcon'], ctx) : null,
        border: _parseInputBorder(args['border']),
        enabledBorder: _parseInputBorder(args['enabledBorder']),
        focusedBorder: _parseInputBorder(args['focusedBorder']),
        errorBorder: _parseInputBorder(args['errorBorder']),
        filled: args['filled'] ?? false,
        fillColor: _parseColor(args['fillColor']),
        contentPadding: _parsePadding(args['contentPadding']),
      ),
      keyboardType: _parseTextInputType(args['keyboardType']),
      textInputAction: _parseTextInputAction(args['textInputAction']),
      obscureText: args['obscureText'] ?? false,
      maxLines: args['maxLines'] ?? 1,
      maxLength: args['maxLength'],
      enabled: args['enabled'] ?? true,
      readOnly: args['readOnly'] ?? false,
      autofocus: args['autofocus'] ?? false,
      style: _parseTextStyle(args['style']),
      onChanged: (val) {
        if (args['onChanged'] != null) {
          _handleAction({'name': args['onChanged'], 'args': {'value': val}}, ctx);
        }
      },
      onSubmitted: (val) {
        if (args['onSubmitted'] != null) {
          _handleAction({'name': args['onSubmitted'], 'args': {'value': val}}, ctx);
        }
      },
    );
  }

  static Widget _buildCheckbox(Map<String, dynamic> args, BuildContext ctx) {
    final stateKey = args['stateKey'] as String?;
    final initialValue = args['value'] ?? false;

    if (stateKey != null) {
      return ValueListenableBuilder<dynamic>(
        valueListenable: instance.getNotifier(stateKey),
        builder: (context, value, child) {
          return Checkbox(
            value: value ?? initialValue,
            onChanged: (newValue) {
              if (newValue != null) {
                instance.setState(stateKey, newValue);
                if (args['onChanged'] != null) {
                  _handleAction({'name': args['onChanged'], 'args': {'value': newValue}}, ctx);
                }
              }
            },
            activeColor: _parseColor(args['activeColor']),
            checkColor: _parseColor(args['checkColor']),
          );
        },
      );
    }

    return Checkbox(
      value: initialValue,
      onChanged: (newValue) {
        if (args['onChanged'] != null && newValue != null) {
          _handleAction({'name': args['onChanged'], 'args': {'value': newValue}}, ctx);
        }
      },
      activeColor: _parseColor(args['activeColor']),
      checkColor: _parseColor(args['checkColor']),
    );
  }

  static Widget _buildSwitch(Map<String, dynamic> args, BuildContext ctx) {
    final stateKey = args['stateKey'] as String?;
    final initialValue = args['value'] ?? false;

    if (stateKey != null) {
      return ValueListenableBuilder<dynamic>(
        valueListenable: instance.getNotifier(stateKey),
        builder: (context, value, child) {
          return Switch(
            value: value ?? initialValue,
            onChanged: (newValue) {
              instance.setState(stateKey, newValue);
              if (args['onChanged'] != null) {
                _handleAction({'name': args['onChanged'], 'args': {'value': newValue}}, ctx);
              }
            },
            activeColor: _parseColor(args['activeColor']),
            activeTrackColor: _parseColor(args['activeTrackColor']),
            inactiveThumbColor: _parseColor(args['inactiveThumbColor']),
            inactiveTrackColor: _parseColor(args['inactiveTrackColor']),
          );
        },
      );
    }

    return Switch(
      value: initialValue,
      onChanged: (newValue) {
        if (args['onChanged'] != null) {
          _handleAction({'name': args['onChanged'], 'args': {'value': newValue}}, ctx);
        }
      },
      activeColor: _parseColor(args['activeColor']),
      activeTrackColor: _parseColor(args['activeTrackColor']),
    );
  }

  static Widget _buildRadio(Map<String, dynamic> args, BuildContext ctx) {
    final stateKey = args['stateKey'] as String?;
    final value = args['value'];
    final groupValue = args['groupValue'];

    if (stateKey != null) {
      return ValueListenableBuilder<dynamic>(
        valueListenable: instance.getNotifier(stateKey),
        builder: (context, currentValue, child) {
          return Radio(
            value: value,
            groupValue: currentValue ?? groupValue,
            onChanged: (newValue) {
              if (newValue != null) {
                instance.setState(stateKey, newValue);
                if (args['onChanged'] != null) {
                  _handleAction({'name': args['onChanged'], 'args': {'value': newValue}}, ctx);
                }
              }
            },
            activeColor: _parseColor(args['activeColor']),
          );
        },
      );
    }

    return Radio(
      value: value,
      groupValue: groupValue,
      onChanged: (newValue) {
        if (args['onChanged'] != null && newValue != null) {
          _handleAction({'name': args['onChanged'], 'args': {'value': newValue}}, ctx);
        }
      },
      activeColor: _parseColor(args['activeColor']),
    );
  }

  static Widget _buildSlider(Map<String, dynamic> args, BuildContext ctx) {
    final stateKey = args['stateKey'] as String?;
    final initialValue = _toDouble(args['value']) ?? 0.0;
    final min = _toDouble(args['min']) ?? 0.0;
    final max = _toDouble(args['max']) ?? 1.0;

    if (stateKey != null) {
      return ValueListenableBuilder<dynamic>(
        valueListenable: instance.getNotifier(stateKey),
        builder: (context, value, child) {
          return Slider(
            value: (value ?? initialValue).clamp(min, max),
            min: min,
            max: max,
            divisions: args['divisions'],
            label: args['label'],
            onChanged: (newValue) {
              instance.setState(stateKey, newValue);
              if (args['onChanged'] != null) {
                _handleAction({'name': args['onChanged'], 'args': {'value': newValue}}, ctx);
              }
            },
            activeColor: _parseColor(args['activeColor']),
            inactiveColor: _parseColor(args['inactiveColor']),
          );
        },
      );
    }

    return Slider(
      value: initialValue.clamp(min, max),
      min: min,
      max: max,
      divisions: args['divisions'],
      label: args['label'],
      onChanged: (newValue) {
        if (args['onChanged'] != null) {
          _handleAction({'name': args['onChanged'], 'args': {'value': newValue}}, ctx);
        }
      },
      activeColor: _parseColor(args['activeColor']),
      inactiveColor: _parseColor(args['inactiveColor']),
    );
  }

  static Widget _buildDropdown(Map<String, dynamic> args, BuildContext ctx) {
    final stateKey = args['stateKey'] as String?;
    final items = args['items'] as List?;
    final initialValue = args['value'];

    if (items == null || items.isEmpty) {
      return _buildErrorWidget('Dropdown requires items list');
    }

    if (stateKey != null) {
      return ValueListenableBuilder<dynamic>(
        valueListenable: instance.getNotifier(stateKey),
        builder: (context, value, child) {
          return DropdownButton<dynamic>(
            value: value ?? initialValue,
            items: items.map((item) {
              final itemValue = item['value'];
              final itemLabel = item['label']?.toString() ?? itemValue.toString();
              return DropdownMenuItem<dynamic>(
                value: itemValue,
                child: Text(itemLabel),
              );
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                instance.setState(stateKey, newValue);
                if (args['onChanged'] != null) {
                  _handleAction({'name': args['onChanged'], 'args': {'value': newValue}}, ctx);
                }
              }
            },
            isExpanded: args['isExpanded'] ?? false,
            hint: args['hint'] != null ? Text(args['hint']) : null,
            disabledHint: args['disabledHint'] != null ? Text(args['disabledHint']) : null,
            dropdownColor: _parseColor(args['dropdownColor']),
            iconEnabledColor: _parseColor(args['iconEnabledColor']),
            iconDisabledColor: _parseColor(args['iconDisabledColor']),
          );
        },
      );
    }

    return DropdownButton<dynamic>(
      value: initialValue,
      items: items.map((item) {
        final itemValue = item['value'];
        final itemLabel = item['label']?.toString() ?? itemValue.toString();
        return DropdownMenuItem<dynamic>(
          value: itemValue,
          child: Text(itemLabel),
        );
      }).toList(),
      onChanged: (newValue) {
        if (args['onChanged'] != null && newValue != null) {
          _handleAction({'name': args['onChanged'], 'args': {'value': newValue}}, ctx);
        }
      },
      isExpanded: args['isExpanded'] ?? false,
      hint: args['hint'] != null ? Text(args['hint']) : null,
      dropdownColor: _parseColor(args['dropdownColor']),
    );
  }

  static Widget _buildDatePicker(Map<String, dynamic> args, BuildContext ctx) {
    final initialDate = DateTime.tryParse(args['initialDate'] ?? '') ?? DateTime.now();
    final firstDate = DateTime.tryParse(args['firstDate'] ?? '') ?? DateTime(1900);
    final lastDate = DateTime.tryParse(args['lastDate'] ?? '') ?? DateTime(2100);

    return ElevatedButton(
      onPressed: () async {
        final date = await showDatePicker(
          context: ctx,
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
        );
        if (date != null && args['onSelected'] != null) {
          _handleAction({'name': args['onSelected'], 'args': {'date': date.toIso8601String()}}, ctx);
        }
      },
      child: render(args['child'], ctx),
    );
  }

  static Widget _buildTimePicker(Map<String, dynamic> args, BuildContext ctx) {
    final initialTime = TimeOfDay.now();

    return ElevatedButton(
      onPressed: () async {
        final time = await showTimePicker(
          context: ctx,
          initialTime: initialTime,
        );
        if (time != null && args['onSelected'] != null) {
          _handleAction({'name': args['onSelected'], 'args': {'time': '${time.hour}:${time.minute}'}}, ctx);
        }
      },
      child: render(args['child'], ctx),
    );
  }

  // === BUILDER METHODS - GESTURES ===

  static Widget _buildGestureDetector(Map<String, dynamic> args, BuildContext ctx) {
    return GestureDetector(
      onTap: args['onTap'] != null ? () => _handleAction(args['onTap'], ctx) : null,
      onDoubleTap: args['onDoubleTap'] != null ? () => _handleAction(args['onDoubleTap'], ctx) : null,
      onLongPress: args['onLongPress'] != null ? () => _handleAction(args['onLongPress'], ctx) : null,
      onPanStart: args['onPanStart'] != null ? (details) => _handleAction(args['onPanStart'], ctx) : null,
      onPanUpdate: args['onPanUpdate'] != null ? (details) => _handleAction(args['onPanUpdate'], ctx) : null,
      onPanEnd: args['onPanEnd'] != null ? (details) => _handleAction(args['onPanEnd'], ctx) : null,
      behavior: _parseHitTestBehavior(args['behavior']),
      child: render(args['child'], ctx),
    );
  }

  static Widget _buildInkWell(Map<String, dynamic> args, BuildContext ctx) {
    return InkWell(
      onTap: args['onTap'] != null ? () => _handleAction(args['onTap'], ctx) : null,
      onDoubleTap: args['onDoubleTap'] != null ? () => _handleAction(args['onDoubleTap'], ctx) : null,
      onLongPress: args['onLongPress'] != null ? () => _handleAction(args['onLongPress'], ctx) : null,
      borderRadius: BorderRadius.circular(_toDouble(args['borderRadius']) ?? 0),
      splashColor: _parseColor(args['splashColor']),
      highlightColor: _parseColor(args['highlightColor']),
      hoverColor: _parseColor(args['hoverColor']),
      child: render(args['child'], ctx),
    );
  }

  static Widget _buildDismissible(Map<String, dynamic> args, BuildContext ctx) {
    return Dismissible(
      key: Key(args['key'] ?? UniqueKey().toString()),
      direction: _parseDismissDirection(args['direction']),
      onDismissed: (direction) {
        if (args['onDismissed'] != null) {
          _handleAction({'name': args['onDismissed'], 'args': {'direction': direction.toString()}}, ctx);
        }
      },
      background: args['background'] != null ? render(args['background'], ctx) : null,
      secondaryBackground: args['secondaryBackground'] != null ? render(args['secondaryBackground'], ctx) : null,
      confirmDismiss: args['confirmDismiss'] != null
          ? (direction) async {
              // This would need custom handling
              return true;
            }
          : null,
      child: render(args['child'], ctx),
    );
  }

  // === BUILDER METHODS - NAVIGATION ===

  static Widget _buildBottomNavigationBar(Map<String, dynamic> args, BuildContext ctx) {
    final items = args['items'] as List?;
    if (items == null || items.isEmpty) {
      return _buildErrorWidget('BottomNavigationBar requires items');
    }

    final stateKey = args['stateKey'] as String?;
    final initialIndex = args['currentIndex'] ?? 0;

    if (stateKey != null) {
      return ValueListenableBuilder<dynamic>(
        valueListenable: instance.getNotifier(stateKey),
        builder: (context, value, child) {
          return BottomNavigationBar(
            items: items.map((item) {
              return BottomNavigationBarItem(
                icon: render(item['icon'], ctx),
                label: item['label'],
                activeIcon: item['activeIcon'] != null ? render(item['activeIcon'], ctx) : null,
                backgroundColor: _parseColor(item['backgroundColor']),
              );
            }).toList(),
            currentIndex: value ?? initialIndex,
            onTap: (index) {
              instance.setState(stateKey, index);
              if (args['onTap'] != null) {
                _handleAction({'name': args['onTap'], 'args': {'index': index}}, ctx);
              }
            },
            backgroundColor: _parseColor(args['backgroundColor']),
            selectedItemColor: _parseColor(args['selectedItemColor']),
            unselectedItemColor: _parseColor(args['unselectedItemColor']),
            type: _parseBottomNavigationBarType(args['type']),
            elevation: _toDouble(args['elevation']),
          );
        },
      );
    }

    return BottomNavigationBar(
      items: items.map((item) {
        return BottomNavigationBarItem(
          icon: render(item['icon'], ctx),
          label: item['label'],
          activeIcon: item['activeIcon'] != null ? render(item['activeIcon'], ctx) : null,
        );
      }).toList(),
      currentIndex: initialIndex,
      onTap: (index) {
        if (args['onTap'] != null) {
          _handleAction({'name': args['onTap'], 'args': {'index': index}}, ctx);
        }
      },
      backgroundColor: _parseColor(args['backgroundColor']),
      selectedItemColor: _parseColor(args['selectedItemColor']),
      unselectedItemColor: _parseColor(args['unselectedItemColor']),
      type: _parseBottomNavigationBarType(args['type']),
    );
  }

  static Widget _buildDrawer(Map<String, dynamic> args, BuildContext ctx) {
    return Drawer(
      backgroundColor: _parseColor(args['backgroundColor']),
      elevation: _toDouble(args['elevation']),
      width: _toDouble(args['width']),
      child: render(args['child'], ctx),
    );
  }

  static Widget _buildTabBar(Map<String, dynamic> args, BuildContext ctx) {
    final tabs = args['tabs'] as List?;
    if (tabs == null || tabs.isEmpty) {
      return _buildErrorWidget('TabBar requires tabs');
    }

    // Note: TabBar requires a TabController which should be managed externally
    return TabBar(
      tabs: tabs.map((tab) => render(tab, ctx)).toList(),
      isScrollable: args['isScrollable'] ?? false,
      indicatorColor: _parseColor(args['indicatorColor']),
      indicatorWeight: _toDouble(args['indicatorWeight']) ?? 2.0,
      labelColor: _parseColor(args['labelColor']),
      unselectedLabelColor: _parseColor(args['unselectedLabelColor']),
      labelStyle: _parseTextStyle(args['labelStyle']),
      unselectedLabelStyle: _parseTextStyle(args['unselectedLabelStyle']),
    );
  }

  static Widget _buildTabBarView(Map<String, dynamic> args, BuildContext ctx) {
    final children = _buildChildrenList(args['children'], ctx);
    
    // Note: TabBarView requires a TabController which should be managed externally
    return TabBarView(
      children: children,
    );
  }

  // === BUILDER METHODS - DIALOGS & OVERLAYS ===

  static Widget _buildAlertDialog(Map<String, dynamic> args, BuildContext ctx) {
    return AlertDialog(
      title: args['title'] != null ? render(args['title'], ctx) : null,
      content: args['content'] != null ? render(args['content'], ctx) : null,
      actions: _buildChildrenList(args['actions'], ctx),
      backgroundColor: _parseColor(args['backgroundColor']),
      elevation: _toDouble(args['elevation']),
      shape: _parseShapeBorder(args['shape'], args['borderRadius']),
      titleTextStyle: _parseTextStyle(args['titleTextStyle']),
      contentTextStyle: _parseTextStyle(args['contentTextStyle']),
    );
  }

  static Widget _buildBottomSheet(Map<String, dynamic> args, BuildContext ctx) {
    // This is typically shown programmatically, not as a widget
    return Container(
      decoration: BoxDecoration(
        color: _parseColor(args['backgroundColor']) ?? Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: render(args['child'], ctx),
    );
  }

  static Widget _buildSnackBar(Map<String, dynamic> args, BuildContext ctx) {
    // SnackBars are shown via ScaffoldMessenger, not rendered as widgets
    // This is a placeholder
    return Container(
      padding: const EdgeInsets.all(16),
      color: _parseColor(args['backgroundColor']) ?? Colors.black87,
      child: render(args['content'], ctx),
    );
  }

  // === BUILDER METHODS - DECORATIVE ===

  static Widget _buildOpacity(Map<String, dynamic> args, BuildContext ctx) {
    return Opacity(
      opacity: (_toDouble(args['opacity']) ?? 1.0).clamp(0.0, 1.0),
      child: render(args['child'], ctx),
    );
  }

  static Widget _buildTransform(Map<String, dynamic> args, BuildContext ctx) {
    Matrix4? transform;
    
    if (args['rotate'] != null) {
      transform = Matrix4.rotationZ(_toDouble(args['rotate']) ?? 0);
    } else if (args['scale'] != null) {
      final scale = _toDouble(args['scale']) ?? 1.0;
      transform = Matrix4.diagonal3Values(scale, scale, 1.0);
    } else if (args['translate'] != null) {
      final translate = args['translate'];
      if (translate is List && translate.length >= 2) {
        transform = Matrix4.translationValues(
          _toDouble(translate[0]) ?? 0,
          _toDouble(translate[1]) ?? 0,
          translate.length > 2 ? (_toDouble(translate[2]) ?? 0) : 0,
        );
      }
    } else if (args['matrix'] != null) {
      transform = _parseMatrix4(args['matrix']);
    }

    if (transform == null) {
      return render(args['child'], ctx);
    }

    return Transform(
      transform: transform,
      alignment: _parseAlignment(args['alignment']) ?? Alignment.center,
      child: render(args['child'], ctx),
    );
  }

  static Widget _buildClipRect(Map<String, dynamic> args, BuildContext ctx) {
    return ClipRect(
      clipBehavior: _parseClip(args['clipBehavior']),
      child: render(args['child'], ctx),
    );
  }

  static Widget _buildClipRRect(Map<String, dynamic> args, BuildContext ctx) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_toDouble(args['borderRadius']) ?? 0),
      clipBehavior: _parseClip(args['clipBehavior']),
      child: render(args['child'], ctx),
    );
  }

  static Widget _buildClipOval(Map<String, dynamic> args, BuildContext ctx) {
    return ClipOval(
      clipBehavior: _parseClip(args['clipBehavior']),
      child: render(args['child'], ctx),
    );
  }

  static Widget _buildBackdropFilter(Map<String, dynamic> args, BuildContext ctx) {
    return BackdropFilter(
      filter: _parseImageFilter(args['filter']),
      child: render(args['child'], ctx),
    );
  }

  // === BUILDER METHODS - CONDITIONAL & CONTROL ===

  static Widget _buildConditional(Map<String, dynamic> args, BuildContext ctx) {
    final condition = _evaluateCondition(args['condition']);
    
    if (condition) {
      return render(args['then'], ctx);
    } else if (args['else'] != null) {
      return render(args['else'], ctx);
    }
    
    return const SizedBox.shrink();
  }

  static Widget _buildVisibility(Map<String, dynamic> args, BuildContext ctx) {
    return Visibility(
      visible: args['visible'] ?? true,
      maintainSize: args['maintainSize'] ?? false,
      maintainAnimation: args['maintainAnimation'] ?? false,
      maintainState: args['maintainState'] ?? false,
      replacement: args['replacement'] != null ? render(args['replacement'], ctx) : const SizedBox.shrink(),
      child: render(args['child'], ctx),
    );
  }

  static Widget _buildStatefulBuilder(Map<String, dynamic> args, BuildContext ctx) {
    return StatefulBuilder(
      builder: (context, setState) {
        return render(args['child'], context);
      },
    );
  }

  // === BUILDER METHODS - CUPERTINO ===

  static Widget _buildCupertinoButton(Map<String, dynamic> args, BuildContext ctx) {
    return CupertinoButton(
      onPressed: args['onPressed'] != null ? () => _handleAction(args['onPressed'], ctx) : null,
      color: _parseColor(args['color']),
      padding: _parsePadding(args['padding']),
      borderRadius: BorderRadius.circular(_toDouble(args['borderRadius']) ?? 8.0),
      minSize: _toDouble(args['minSize']),
      child: render(args['child'], ctx),
    );
  }

  static Widget _buildCupertinoSwitch(Map<String, dynamic> args, BuildContext ctx) {
    final stateKey = args['stateKey'] as String?;
    final initialValue = args['value'] ?? false;

    if (stateKey != null) {
      return ValueListenableBuilder<dynamic>(
        valueListenable: instance.getNotifier(stateKey),
        builder: (context, value, child) {
          return CupertinoSwitch(
            value: value ?? initialValue,
            onChanged: (newValue) {
              instance.setState(stateKey, newValue);
              if (args['onChanged'] != null) {
                _handleAction({'name': args['onChanged'], 'args': {'value': newValue}}, ctx);
              }
            },
            activeColor: _parseColor(args['activeColor']),
            trackColor: _parseColor(args['trackColor']),
          );
        },
      );
    }

    return CupertinoSwitch(
      value: initialValue,
      onChanged: (newValue) {
        if (args['onChanged'] != null) {
          _handleAction({'name': args['onChanged'], 'args': {'value': newValue}}, ctx);
        }
      },
      activeColor: _parseColor(args['activeColor']),
    );
  }

  static Widget _buildCupertinoSlider(Map<String, dynamic> args, BuildContext ctx) {
    final stateKey = args['stateKey'] as String?;
    final initialValue = _toDouble(args['value']) ?? 0.0;
    final min = _toDouble(args['min']) ?? 0.0;
    final max = _toDouble(args['max']) ?? 1.0;

    if (stateKey != null) {
      return ValueListenableBuilder<dynamic>(
        valueListenable: instance.getNotifier(stateKey),
        builder: (context, value, child) {
          return CupertinoSlider(
            value: (value ?? initialValue).clamp(min, max),
            min: min,
            max: max,
            divisions: args['divisions'],
            onChanged: (newValue) {
              instance.setState(stateKey, newValue);
              if (args['onChanged'] != null) {
                _handleAction({'name': args['onChanged'], 'args': {'value': newValue}}, ctx);
              }
            },
            activeColor: _parseColor(args['activeColor']),
          );
        },
      );
    }

    return CupertinoSlider(
      value: initialValue.clamp(min, max),
      min: min,
      max: max,
      divisions: args['divisions'],
      onChanged: (newValue) {
        if (args['onChanged'] != null) {
          _handleAction({'name': args['onChanged'], 'args': {'value': newValue}}, ctx);
        }
      },
      activeColor: _parseColor(args['activeColor']),
    );
  }

  // === HELPER METHODS ===

  static List<Widget> _buildChildrenList(dynamic childrenJson, BuildContext ctx) {
    if (childrenJson is! List) return [];
    return childrenJson.map((c) => render(c, ctx)).toList();
  }

  static Widget _buildErrorWidget(String msg) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red[100],
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              "SDUI Error: $msg",
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // === PARSING HELPER WRAPPERS ===
  
  static double? _toDouble(dynamic val) => SduiParsingHelpers.toDouble(val);
  static int? _toInt(dynamic val) => SduiParsingHelpers.toInt(val);
  static bool _toBool(dynamic val) => SduiParsingHelpers.toBool(val);
  
  static Color? _parseColor(String? hex) => SduiParsingHelpers.parseColor(hex);
  static EdgeInsets _parsePadding(dynamic val) => SduiParsingHelpers.parsePadding(val);
  static Alignment? _parseAlignment(String? val) => SduiParsingHelpers.parseAlignment(val);
  
  static MainAxisAlignment _parseMainAxis(String? val) => SduiParsingHelpers.parseMainAxis(val);
  static CrossAxisAlignment _parseCrossAxis(String? val) => SduiParsingHelpers.parseCrossAxis(val);
  static MainAxisSize _parseMainAxisSize(String? val) => SduiParsingHelpers.parseMainAxisSize(val);
  static WrapAlignment _parseWrapAlignment(String? val) => SduiParsingHelpers.parseWrapAlignment(val);
  static WrapCrossAlignment _parseWrapCrossAlignment(String? val) => SduiParsingHelpers.parseWrapCrossAlignment(val);
  
  static BoxFit _parseBoxFit(String? val) => SduiParsingHelpers.parseBoxFit(val);
  static Axis _parseAxis(String? val) => SduiParsingHelpers.parseAxis(val);
  
  static TextAlign _parseTextAlign(String? val) => SduiParsingHelpers.parseTextAlign(val);
  static TextOverflow _parseTextOverflow(String? val) => SduiParsingHelpers.parseTextOverflow(val);
  static TextStyle? _parseTextStyle(Map<String, dynamic>? style) => SduiParsingHelpers.parseTextStyle(style);
  
  static IconData _parseIconData(String? name) => SduiParsingHelpers.parseIconData(name);
  
  static ScrollPhysics? _parseScrollPhysics(String? val) => SduiParsingHelpers.parseScrollPhysics(val);
  static StackFit _parseStackFit(String? val) => SduiParsingHelpers.parseStackFit(val);
  static Clip _parseClip(String? val) => SduiParsingHelpers.parseClip(val);
  static FlexFit _parseFlexFit(String? val) => SduiParsingHelpers.parseFlexFit(val);
  
  static Gradient? _parseGradient(Map<String, dynamic>? gradient) => SduiParsingHelpers.parseGradient(gradient);
  static List<BoxShadow>? _parseBoxShadow(dynamic shadows) => SduiParsingHelpers.parseBoxShadow(shadows);
  static BoxConstraints? _parseBoxConstraints(Map<String, dynamic>? constraints) => SduiParsingHelpers.parseBoxConstraints(constraints);
  static Matrix4? _parseMatrix4(dynamic matrix) => SduiParsingHelpers.parseMatrix4(matrix);
  
  static ShapeBorder? _parseShapeBorder(String? shape, dynamic borderRadius) => SduiParsingHelpers.parseShapeBorder(shape, borderRadius);
  static InputBorder? _parseInputBorder(dynamic border) => SduiParsingHelpers.parseInputBorder(border);
  
  static TextInputType _parseTextInputType(String? type) => SduiParsingHelpers.parseTextInputType(type);
  static TextInputAction _parseTextInputAction(String? action) => SduiParsingHelpers.parseTextInputAction(action);
  
  static Size? _parseSize(dynamic size) => SduiParsingHelpers.parseSize(size);
  static ImageRepeat _parseImageRepeat(String? repeat) => SduiParsingHelpers.parseImageRepeat(repeat);
  static BlendMode? _parseBlendMode(String? mode) => SduiParsingHelpers.parseBlendMode(mode);
  
  static HitTestBehavior _parseHitTestBehavior(String? behavior) => SduiParsingHelpers.parseHitTestBehavior(behavior);
  static DismissDirection _parseDismissDirection(String? direction) => SduiParsingHelpers.parseDismissDirection(direction);
  
  static BottomNavigationBarType _parseBottomNavigationBarType(String? type) => SduiParsingHelpers.parseBottomNavigationBarType(type);
  static FloatingActionButtonLocation? _parseFloatingActionButtonLocation(String? location) => SduiParsingHelpers.parseFloatingActionButtonLocation(location);
  
  static ThemeMode _parseThemeMode(String? mode) => SduiParsingHelpers.parseThemeMode(mode);
  static ThemeData? _parseThemeData(Map<String, dynamic>? theme) => SduiParsingHelpers.parseThemeData(theme);
  
  static ImageFilter _parseImageFilter(Map<String, dynamic>? filter) => SduiParsingHelpers.parseImageFilter(filter);
}