import 'dart:convert';

// ============================================================================
// ABSTRACT BASE CLASS
// ============================================================================

abstract class SWidget {
  /// The 'type' string that the Flutter Parser expects (e.g. 'column')
  String get type;
  
  /// The arguments map
  Map<String, dynamic> args();
  
  /// Converts the widget to the JSON format your Parser reads
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> cleanedArgs = {};
    
    args().forEach((key, value) {
      if (value != null) {
        if (value is SWidget) {
          cleanedArgs[key] = value.toJson();
        } else if (value is List) {
          cleanedArgs[key] = value.map((e) {
            return (e is SWidget) ? e.toJson() : e;
          }).toList();
        } else {
          cleanedArgs[key] = value;
        }
      }
    });
    
    return {
      'type': type,
      'args': cleanedArgs,
    };
  }
  
  /// Converts the widget to a JSON string
  String toJsonString({bool pretty = false}) {
    if (pretty) {
      return JsonEncoder.withIndent('  ').convert(toJson());
    }
    return jsonEncode(toJson());
  }
  
  @override
  String toString() => toJsonString(pretty: true);
}

// ============================================================================
// STRUCTURE WIDGETS
// ============================================================================

class SScaffold extends SWidget {
  final SWidget? appBar;
  final SWidget? body;
  final String? backgroundColor;
  final SWidget? floatingActionButton;
  final String? floatingActionButtonLocation;
  final SWidget? bottomNavigationBar;
  final SWidget? drawer;
  final SWidget? endDrawer;
  final SWidget? bottomSheet;
  final bool? extendBody;
  final bool? extendBodyBehindAppBar;
  final bool? resizeToAvoidBottomInset;

  SScaffold({
    this.appBar,
    this.body,
    this.backgroundColor,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.bottomSheet,
    this.extendBody,
    this.extendBodyBehindAppBar,
    this.resizeToAvoidBottomInset,
  });

  @override
  String get type => 'scaffold';

  @override
  Map<String, dynamic> args() => {
    'appBar': appBar,
    'body': body,
    'backgroundColor': backgroundColor,
    'floatingActionButton': floatingActionButton,
    'floatingActionButtonLocation': floatingActionButtonLocation,
    'bottomNavigationBar': bottomNavigationBar,
    'drawer': drawer,
    'endDrawer': endDrawer,
    'bottomSheet': bottomSheet,
    'extendBody': extendBody,
    'extendBodyBehindAppBar': extendBodyBehindAppBar,
    'resizeToAvoidBottomInset': resizeToAvoidBottomInset,
  };
}

class SAppBar extends SWidget {
  final SWidget? title;
  final String? backgroundColor;
  final String? foregroundColor;
  final bool? centerTitle;
  final double? elevation;
  final SWidget? leading;
  final bool? automaticallyImplyLeading;
  final List<SWidget>? actions;
  final SWidget? bottom;
  final SWidget? flexibleSpace;
  final String? shadowColor;
  final String? surfaceTintColor;

  SAppBar({
    this.title,
    this.backgroundColor,
    this.foregroundColor,
    this.centerTitle,
    this.elevation,
    this.leading,
    this.automaticallyImplyLeading,
    this.actions,
    this.bottom,
    this.flexibleSpace,
    this.shadowColor,
    this.surfaceTintColor,
  });

  @override
  String get type => 'app_bar';

  @override
  Map<String, dynamic> args() => {
    'title': title,
    'backgroundColor': backgroundColor,
    'foregroundColor': foregroundColor,
    'centerTitle': centerTitle,
    'elevation': elevation,
    'leading': leading,
    'automaticallyImplyLeading': automaticallyImplyLeading,
    'actions': actions,
    'bottom': bottom,
    'flexibleSpace': flexibleSpace,
    'shadowColor': shadowColor,
    'surfaceTintColor': surfaceTintColor,
  };
}

class SSafeArea extends SWidget {
  final bool? top;
  final bool? bottom;
  final bool? left;
  final bool? right;
  final dynamic minimum;
  final SWidget child;

  SSafeArea({
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.minimum,
    required this.child,
  });

  @override
  String get type => 'safe_area';

  @override
  Map<String, dynamic> args() => {
    'top': top,
    'bottom': bottom,
    'left': left,
    'right': right,
    'minimum': minimum,
    'child': child,
  };
}

class SMaterialApp extends SWidget {
  final String? title;
  final Map<String, dynamic>? theme;
  final Map<String, dynamic>? darkTheme;
  final String? themeMode;
  final SWidget? home;
  final bool? debugShowCheckedModeBanner;

  SMaterialApp({
    this.title,
    this.theme,
    this.darkTheme,
    this.themeMode,
    this.home,
    this.debugShowCheckedModeBanner,
  });

  @override
  String get type => 'material_app';

  @override
  Map<String, dynamic> args() => {
    'title': title,
    'theme': theme,
    'darkTheme': darkTheme,
    'themeMode': themeMode,
    'home': home,
    'debugShowCheckedModeBanner': debugShowCheckedModeBanner,
  };
}

// ============================================================================
// LAYOUT WIDGETS
// ============================================================================

class SColumn extends SWidget {
  final List<SWidget> children;
  final String? mainAxisAlignment;
  final String? crossAxisAlignment;
  final String? mainAxisSize;

  SColumn({
    required this.children,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.mainAxisSize,
  });

  @override
  String get type => 'column';

  @override
  Map<String, dynamic> args() => {
    'children': children,
    'mainAxisAlignment': mainAxisAlignment,
    'crossAxisAlignment': crossAxisAlignment,
    'mainAxisSize': mainAxisSize,
  };
}

class SRow extends SWidget {
  final List<SWidget> children;
  final String? mainAxisAlignment;
  final String? crossAxisAlignment;
  final String? mainAxisSize;

  SRow({
    required this.children,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.mainAxisSize,
  });

  @override
  String get type => 'row';

  @override
  Map<String, dynamic> args() => {
    'children': children,
    'mainAxisAlignment': mainAxisAlignment,
    'crossAxisAlignment': crossAxisAlignment,
    'mainAxisSize': mainAxisSize,
  };
}

class SStack extends SWidget {
  final List<SWidget> children;
  final String? alignment;
  final String? fit;
  final String? clipBehavior;

  SStack({
    required this.children,
    this.alignment,
    this.fit,
    this.clipBehavior,
  });

  @override
  String get type => 'stack';

  @override
  Map<String, dynamic> args() => {
    'children': children,
    'alignment': alignment,
    'fit': fit,
    'clipBehavior': clipBehavior,
  };
}

class SContainer extends SWidget {
  final SWidget? child;
  final double? width;
  final double? height;
  final dynamic padding;
  final dynamic margin;
  final String? alignment;
  final String? color;
  final double? borderRadius;
  final String? borderColor;
  final double? borderWidth;
  final Map<String, dynamic>? gradient;
  final dynamic boxShadow;
  final String? shape;
  final String? backgroundImage;
  final String? backgroundImageFit;
  final Map<String, dynamic>? constraints;
  final dynamic transform;
  final String? clipBehavior;

  SContainer({
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.alignment,
    this.color,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.gradient,
    this.boxShadow,
    this.shape,
    this.backgroundImage,
    this.backgroundImageFit,
    this.constraints,
    this.transform,
    this.clipBehavior,
  });

  @override
  String get type => 'container';

  @override
  Map<String, dynamic> args() => {
    'child': child,
    'width': width,
    'height': height,
    'padding': padding,
    'margin': margin,
    'alignment': alignment,
    'color': color,
    'borderRadius': borderRadius,
    'borderColor': borderColor,
    'borderWidth': borderWidth,
    'gradient': gradient,
    'boxShadow': boxShadow,
    'shape': shape,
    'backgroundImage': backgroundImage,
    'backgroundImageFit': backgroundImageFit,
    'constraints': constraints,
    'transform': transform,
    'clipBehavior': clipBehavior,
  };
}

class SSizedBox extends SWidget {
  final double? width;
  final double? height;
  final SWidget? child;

  SSizedBox({
    this.width,
    this.height,
    this.child,
  });

  @override
  String get type => 'sized_box';

  @override
  Map<String, dynamic> args() => {
    'width': width,
    'height': height,
    'child': child,
  };
}

class SPadding extends SWidget {
  final dynamic padding;
  final SWidget child;

  SPadding({
    required this.padding,
    required this.child,
  });

  @override
  String get type => 'padding';

  @override
  Map<String, dynamic> args() => {
    'padding': padding,
    'child': child,
  };
}

class SCenter extends SWidget {
  final SWidget child;

  SCenter({required this.child});

  @override
  String get type => 'center';

  @override
  Map<String, dynamic> args() => {
    'child': child,
  };
}

class SAlign extends SWidget {
  final String? alignment;
  final double? widthFactor;
  final double? heightFactor;
  final SWidget child;

  SAlign({
    this.alignment,
    this.widthFactor,
    this.heightFactor,
    required this.child,
  });

  @override
  String get type => 'align';

  @override
  Map<String, dynamic> args() => {
    'alignment': alignment,
    'widthFactor': widthFactor,
    'heightFactor': heightFactor,
    'child': child,
  };
}

class SExpanded extends SWidget {
  final int? flex;
  final SWidget child;

  SExpanded({
    this.flex,
    required this.child,
  });

  @override
  String get type => 'expanded';

  @override
  Map<String, dynamic> args() => {
    'flex': flex,
    'child': child,
  };
}

class SFlexible extends SWidget {
  final int? flex;
  final String? fit;
  final SWidget child;

  SFlexible({
    this.flex,
    this.fit,
    required this.child,
  });

  @override
  String get type => 'flexible';

  @override
  Map<String, dynamic> args() => {
    'flex': flex,
    'fit': fit,
    'child': child,
  };
}

class SWrap extends SWidget {
  final List<SWidget> children;
  final String? direction;
  final String? alignment;
  final double? spacing;
  final double? runSpacing;
  final String? crossAxisAlignment;

  SWrap({
    required this.children,
    this.direction,
    this.alignment,
    this.spacing,
    this.runSpacing,
    this.crossAxisAlignment,
  });

  @override
  String get type => 'wrap';

  @override
  Map<String, dynamic> args() => {
    'children': children,
    'direction': direction,
    'alignment': alignment,
    'spacing': spacing,
    'runSpacing': runSpacing,
    'crossAxisAlignment': crossAxisAlignment,
  };
}

class SSpacer extends SWidget {
  final int? flex;

  SSpacer({this.flex});

  @override
  String get type => 'spacer';

  @override
  Map<String, dynamic> args() => {
    'flex': flex,
  };
}

class SDivider extends SWidget {
  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final String? color;

  SDivider({
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
  });

  @override
  String get type => 'divider';

  @override
  Map<String, dynamic> args() => {
    'height': height,
    'thickness': thickness,
    'indent': indent,
    'endIndent': endIndent,
    'color': color,
  };
}

class SPositioned extends SWidget {
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final double? width;
  final double? height;
  final SWidget child;

  SPositioned({
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
    required this.child,
  });

  @override
  String get type => 'positioned';

  @override
  Map<String, dynamic> args() => {
    'left': left,
    'top': top,
    'right': right,
    'bottom': bottom,
    'width': width,
    'height': height,
    'child': child,
  };
}

// ============================================================================
// SCROLLING WIDGETS
// ============================================================================

class SSingleChildScrollView extends SWidget {
  final SWidget child;
  final String? scrollDirection;
  final bool? reverse;
  final dynamic padding;
  final String? physics;

  SSingleChildScrollView({
    required this.child,
    this.scrollDirection,
    this.reverse,
    this.padding,
    this.physics,
  });

  @override
  String get type => 'single_child_scroll_view';

  @override
  Map<String, dynamic> args() => {
    'child': child,
    'scrollDirection': scrollDirection,
    'reverse': reverse,
    'padding': padding,
    'physics': physics,
  };
}

class SListView extends SWidget {
  final List<SWidget> children;
  final String? scrollDirection;
  final bool? reverse;
  final bool? shrinkWrap;
  final String? physics;
  final dynamic padding;

  SListView({
    required this.children,
    this.scrollDirection,
    this.reverse,
    this.shrinkWrap,
    this.physics,
    this.padding,
  });

  @override
  String get type => 'list_view';

  @override
  Map<String, dynamic> args() => {
    'children': children,
    'scrollDirection': scrollDirection,
    'reverse': reverse,
    'shrinkWrap': shrinkWrap,
    'physics': physics,
    'padding': padding,
  };
}

class SListViewBuilder extends SWidget {
  final String data;
  final Map<String, dynamic> itemTemplate;
  final String? scrollDirection;
  final bool? reverse;
  final bool? shrinkWrap;
  final String? physics;
  final dynamic padding;

  SListViewBuilder({
    required this.data,
    required this.itemTemplate,
    this.scrollDirection,
    this.reverse,
    this.shrinkWrap,
    this.physics,
    this.padding,
  });

  @override
  String get type => 'list_view_builder';

  @override
  Map<String, dynamic> args() => {
    'data': data,
    'itemTemplate': itemTemplate,
    'scrollDirection': scrollDirection,
    'reverse': reverse,
    'shrinkWrap': shrinkWrap,
    'physics': physics,
    'padding': padding,
  };
}

class SGridView extends SWidget {
  final List<SWidget> children;
  final int? crossAxisCount;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final double? childAspectRatio;
  final dynamic padding;

  SGridView({
    required this.children,
    this.crossAxisCount,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.childAspectRatio,
    this.padding,
  });

  @override
  String get type => 'grid_view';

  @override
  Map<String, dynamic> args() => {
    'children': children,
    'crossAxisCount': crossAxisCount,
    'mainAxisSpacing': mainAxisSpacing,
    'crossAxisSpacing': crossAxisSpacing,
    'childAspectRatio': childAspectRatio,
    'padding': padding,
  };
}

class SGridViewBuilder extends SWidget {
  final String data;
  final Map<String, dynamic> itemTemplate;
  final int? crossAxisCount;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final double? childAspectRatio;
  final dynamic padding;

  SGridViewBuilder({
    required this.data,
    required this.itemTemplate,
    this.crossAxisCount,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.childAspectRatio,
    this.padding,
  });

  @override
  String get type => 'grid_view_builder';

  @override
  Map<String, dynamic> args() => {
    'data': data,
    'itemTemplate': itemTemplate,
    'crossAxisCount': crossAxisCount,
    'mainAxisSpacing': mainAxisSpacing,
    'crossAxisSpacing': crossAxisSpacing,
    'childAspectRatio': childAspectRatio,
    'padding': padding,
  };
}

class SPageView extends SWidget {
  final List<SWidget> children;
  final String? scrollDirection;
  final bool? reverse;
  final String? physics;
  final bool? pageSnapping;

  SPageView({
    required this.children,
    this.scrollDirection,
    this.reverse,
    this.physics,
    this.pageSnapping,
  });

  @override
  String get type => 'page_view';

  @override
  Map<String, dynamic> args() => {
    'children': children,
    'scrollDirection': scrollDirection,
    'reverse': reverse,
    'physics': physics,
    'pageSnapping': pageSnapping,
  };
}

class SRefreshIndicator extends SWidget {
  final SWidget child;
  final String? onRefresh;
  final String? color;
  final String? backgroundColor;

  SRefreshIndicator({
    required this.child,
    this.onRefresh,
    this.color,
    this.backgroundColor,
  });

  @override
  String get type => 'refreshable';

  @override
  Map<String, dynamic> args() => {
    'child': child,
    'onRefresh': onRefresh,
    'color': color,
    'backgroundColor': backgroundColor,
  };
}

// ============================================================================
// CONTENT WIDGETS
// ============================================================================

class SText extends SWidget {
  final String text;
  final String? textAlign;
  final int? maxLines;
  final String? overflow;
  final bool? softWrap;
  final Map<String, dynamic>? style;
  final String? semanticsLabel;

  SText(
    this.text, {
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.style,
    this.semanticsLabel,
  });

  @override
  String get type => 'text';

  @override
  Map<String, dynamic> args() => {
    'text': text,
    'textAlign': textAlign,
    'maxLines': maxLines,
    'overflow': overflow,
    'softWrap': softWrap,
    'style': style,
    'semanticsLabel': semanticsLabel,
  };
}

class SRichText extends SWidget {
  final List<Map<String, dynamic>> spans;
  final String? textAlign;
  final int? maxLines;
  final String? overflow;

  SRichText({
    required this.spans,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  String get type => 'rich_text';

  @override
  Map<String, dynamic> args() => {
    'spans': spans,
    'textAlign': textAlign,
    'maxLines': maxLines,
    'overflow': overflow,
  };
}

class SIcon extends SWidget {
  final String icon;
  final double? size;
  final String? color;
  final String? semanticLabel;

  SIcon(
    this.icon, {
    this.size,
    this.color,
    this.semanticLabel,
  });

  @override
  String get type => 'icon';

  @override
  Map<String, dynamic> args() => {
    'icon': icon,
    'size': size,
    'color': color,
    'semanticLabel': semanticLabel,
  };
}

class SImageNetwork extends SWidget {
  final String url;
  final double? width;
  final double? height;
  final String? fit;
  final String? alignment;
  final String? repeat;
  final String? color;
  final String? colorBlendMode;
  final bool? showLoading;

  SImageNetwork({
    required this.url,
    this.width,
    this.height,
    this.fit,
    this.alignment,
    this.repeat,
    this.color,
    this.colorBlendMode,
    this.showLoading,
  });

  @override
  String get type => 'image_network';

  @override
  Map<String, dynamic> args() => {
    'url': url,
    'width': width,
    'height': height,
    'fit': fit,
    'alignment': alignment,
    'repeat': repeat,
    'color': color,
    'colorBlendMode': colorBlendMode,
    'showLoading': showLoading,
  };
}

class SImageAsset extends SWidget {
  final String path;
  final double? width;
  final double? height;
  final String? fit;
  final String? alignment;
  final String? color;
  final String? colorBlendMode;

  SImageAsset({
    required this.path,
    this.width,
    this.height,
    this.fit,
    this.alignment,
    this.color,
    this.colorBlendMode,
  });

  @override
  String get type => 'image_asset';

  @override
  Map<String, dynamic> args() => {
    'path': path,
    'width': width,
    'height': height,
    'fit': fit,
    'alignment': alignment,
    'color': color,
    'colorBlendMode': colorBlendMode,
  };
}

class SCircularProgressIndicator extends SWidget {
  final double? value;
  final String? backgroundColor;
  final String? color;
  final double? strokeWidth;

  SCircularProgressIndicator({
    this.value,
    this.backgroundColor,
    this.color,
    this.strokeWidth,
  });

  @override
  String get type => 'circular_progress_indicator';

  @override
  Map<String, dynamic> args() => {
    'value': value,
    'backgroundColor': backgroundColor,
    'color': color,
    'strokeWidth': strokeWidth,
  };
}

class SLinearProgressIndicator extends SWidget {
  final double? value;
  final String? backgroundColor;
  final String? color;
  final double? minHeight;

  SLinearProgressIndicator({
    this.value,
    this.backgroundColor,
    this.color,
    this.minHeight,
  });

  @override
  String get type => 'linear_progress_indicator';

  @override
  Map<String, dynamic> args() => {
    'value': value,
    'backgroundColor': backgroundColor,
    'color': color,
    'minHeight': minHeight,
  };
}

class SPlaceholder extends SWidget {
  final String? color;
  final double? strokeWidth;
  final double? fallbackWidth;
  final double? fallbackHeight;

  SPlaceholder({
    this.color,
    this.strokeWidth,
    this.fallbackWidth,
    this.fallbackHeight,
  });

  @override
  String get type => 'placeholder';

  @override
  Map<String, dynamic> args() => {
    'color': color,
    'strokeWidth': strokeWidth,
    'fallbackWidth': fallbackWidth,
    'fallbackHeight': fallbackHeight,
  };
}

// ============================================================================
// MATERIAL COMPONENTS
// ============================================================================

class SCard extends SWidget {
  final SWidget? child;
  final String? color;
  final String? shadowColor;
  final String? surfaceTintColor;
  final double? elevation;
  final String? shape;
  final double? borderRadius;
  final dynamic margin;
  final String? clipBehavior;

  SCard({
    this.child,
    this.color,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.shape,
    this.borderRadius,
    this.margin,
    this.clipBehavior,
  });

  @override
  String get type => 'card';

  @override
  Map<String, dynamic> args() => {
    'child': child,
    'color': color,
    'shadowColor': shadowColor,
    'surfaceTintColor': surfaceTintColor,
    'elevation': elevation,
    'shape': shape,
    'borderRadius': borderRadius,
    'margin': margin,
    'clipBehavior': clipBehavior,
  };
}

class SListTile extends SWidget {
  final SWidget? leading;
  final SWidget? title;
  final SWidget? subtitle;
  final SWidget? trailing;
  final bool? isThreeLine;
  final bool? dense;
  final dynamic contentPadding;
  final bool? enabled;
  final String? onTap;
  final String? onLongPress;
  final bool? selected;
  final String? selectedColor;
  final String? tileColor;
  final String? shape;
  final double? borderRadius;

  SListTile({
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.isThreeLine,
    this.dense,
    this.contentPadding,
    this.enabled,
    this.onTap,
    this.onLongPress,
    this.selected,
    this.selectedColor,
    this.tileColor,
    this.shape,
    this.borderRadius,
  });

  @override
  String get type => 'list_tile';

  @override
  Map<String, dynamic> args() => {
    'leading': leading,
    'title': title,
    'subtitle': subtitle,
    'trailing': trailing,
    'isThreeLine': isThreeLine,
    'dense': dense,
    'contentPadding': contentPadding,
    'enabled': enabled,
    'onTap': onTap,
    'onLongPress': onLongPress,
    'selected': selected,
    'selectedColor': selectedColor,
    'tileColor': tileColor,
    'shape': shape,
    'borderRadius': borderRadius,
  };
}

class SChip extends SWidget {
  final SWidget label;
  final SWidget? avatar;
  final SWidget? deleteIcon;
  final String? onDeleted;
  final String? backgroundColor;
  final Map<String, dynamic>? labelStyle;
  final dynamic padding;
  final String? shape;
  final double? borderRadius;
  final dynamic side;

  SChip({
    required this.label,
    this.avatar,
    this.deleteIcon,
    this.onDeleted,
    this.backgroundColor,
    this.labelStyle,
    this.padding,
    this.shape,
    this.borderRadius,
    this.side,
  });

  @override
  String get type => 'chip';

  @override
  Map<String, dynamic> args() => {
    'label': label,
    'avatar': avatar,
    'deleteIcon': deleteIcon,
    'onDeleted': onDeleted,
    'backgroundColor': backgroundColor,
    'labelStyle': labelStyle,
    'padding': padding,
    'shape': shape,
    'borderRadius': borderRadius,
    'side': side,
  };
}

class SBadge extends SWidget {
  final SWidget? label;
  final String? backgroundColor;
  final String? textColor;
  final String? alignment;
  final SWidget child;

  SBadge({
    this.label,
    this.backgroundColor,
    this.textColor,
    this.alignment,
    required this.child,
  });

  @override
  String get type => 'badge';

  @override
  Map<String, dynamic> args() => {
    'label': label,
    'backgroundColor': backgroundColor,
    'textColor': textColor,
    'alignment': alignment,
    'child': child,
  };
}

class STooltip extends SWidget {
  final String message;
  final String? backgroundColor;
  final Map<String, dynamic>? textStyle;
  final int? waitDuration;
  final SWidget child;

  STooltip({
    required this.message,
    this.backgroundColor,
    this.textStyle,
    this.waitDuration,
    required this.child,
  });

  @override
  String get type => 'tooltip';

  @override
  Map<String, dynamic> args() => {
    'message': message,
    'backgroundColor': backgroundColor,
    'textStyle': textStyle,
    'waitDuration': waitDuration,
    'child': child,
  };
}

// ============================================================================
// BUTTONS
// ============================================================================

class SElevatedButton extends SWidget {
  final String? onPressed;
  final String? onLongPress;
  final String? backgroundColor;
  final String? foregroundColor;
  final String? disabledBackgroundColor;
  final String? disabledForegroundColor;
  final double? elevation;
  final dynamic padding;
  final dynamic minimumSize;
  final String? shape;
  final double? borderRadius;
  final SWidget child;

  SElevatedButton({
    this.onPressed,
    this.onLongPress,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.elevation,
    this.padding,
    this.minimumSize,
    this.shape,
    this.borderRadius,
    required this.child,
  });

  @override
  String get type => 'elevated_button';

  @override
  Map<String, dynamic> args() => {
    'onPressed': onPressed,
    'onLongPress': onLongPress,
    'backgroundColor': backgroundColor,
    'foregroundColor': foregroundColor,
    'disabledBackgroundColor': disabledBackgroundColor,
    'disabledForegroundColor': disabledForegroundColor,
    'elevation': elevation,
    'padding': padding,
    'minimumSize': minimumSize,
    'shape': shape,
    'borderRadius': borderRadius,
    'child': child,
  };
}

class STextButton extends SWidget {
  final String? onPressed;
  final String? onLongPress;
  final String? foregroundColor;
  final dynamic padding;
  final dynamic minimumSize;
  final String? shape;
  final double? borderRadius;
  final SWidget child;

  STextButton({
    this.onPressed,
    this.onLongPress,
    this.foregroundColor,
    this.padding,
    this.minimumSize,
    this.shape,
    this.borderRadius,
    required this.child,
  });

  @override
  String get type => 'text_button';

  @override
  Map<String, dynamic> args() => {
    'onPressed': onPressed,
    'onLongPress': onLongPress,
    'foregroundColor': foregroundColor,
    'padding': padding,
    'minimumSize': minimumSize,
    'shape': shape,
    'borderRadius': borderRadius,
    'child': child,
  };
}

class SOutlinedButton extends SWidget {
  final String? onPressed;
  final String? onLongPress;
  final String? foregroundColor;
  final String? borderColor;
  final double? borderWidth;
  final dynamic padding;
  final dynamic minimumSize;
  final String? shape;
  final double? borderRadius;
  final SWidget child;

  SOutlinedButton({
    this.onPressed,
    this.onLongPress,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth,
    this.padding,
    this.minimumSize,
    this.shape,
    this.borderRadius,
    required this.child,
  });

  @override
  String get type => 'outlined_button';

  @override
  Map<String, dynamic> args() => {
    'onPressed': onPressed,
    'onLongPress': onLongPress,
    'foregroundColor': foregroundColor,
    'borderColor': borderColor,
    'borderWidth': borderWidth,
    'padding': padding,
    'minimumSize': minimumSize,
    'shape': shape,
    'borderRadius': borderRadius,
    'child': child,
  };
}

class SIconButton extends SWidget {
  final String? onPressed;
  final SWidget icon;
  final double? iconSize;
  final String? color;
  final String? disabledColor;
  final String? tooltip;
  final dynamic padding;

  SIconButton({
    this.onPressed,
    required this.icon,
    this.iconSize,
    this.color,
    this.disabledColor,
    this.tooltip,
    this.padding,
  });

  @override
  String get type => 'icon_button';

  @override
  Map<String, dynamic> args() => {
    'onPressed': onPressed,
    'icon': icon,
    'iconSize': iconSize,
    'color': color,
    'disabledColor': disabledColor,
    'tooltip': tooltip,
    'padding': padding,
  };
}

class SFloatingActionButton extends SWidget {
  final String? onPressed;
  final String? backgroundColor;
  final String? foregroundColor;
  final double? elevation;
  final String? tooltip;
  final bool? mini;
  final String? shape;
  final SWidget child;

  SFloatingActionButton({
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.tooltip,
    this.mini,
    this.shape,
    required this.child,
  });

  @override
  String get type => 'floating_action_button';

  @override
  Map<String, dynamic> args() => {
    'onPressed': onPressed,
    'backgroundColor': backgroundColor,
    'foregroundColor': foregroundColor,
    'elevation': elevation,
    'tooltip': tooltip,
    'mini': mini,
    'shape': shape,
    'child': child,
  };
}

// ============================================================================
// FORM INPUTS
// ============================================================================

class STextField extends SWidget {
  final String? controllerId;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final SWidget? prefixIcon;
  final SWidget? suffixIcon;
  final dynamic border;
  final dynamic enabledBorder;
  final dynamic focusedBorder;
  final dynamic errorBorder;
  final bool? filled;
  final String? fillColor;
  final dynamic contentPadding;
  final String? keyboardType;
  final String? textInputAction;
  final bool? obscureText;
  final int? maxLines;
  final int? maxLength;
  final bool? enabled;
  final bool? readOnly;
  final bool? autofocus;
  final Map<String, dynamic>? style;
  final String? onChanged;
  final String? onSubmitted;

  STextField({
    this.controllerId,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.filled,
    this.fillColor,
    this.contentPadding,
    this.keyboardType,
    this.textInputAction,
    this.obscureText,
    this.maxLines,
    this.maxLength,
    this.enabled,
    this.readOnly,
    this.autofocus,
    this.style,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  String get type => 'text_field';

  @override
  Map<String, dynamic> args() => {
    'controllerId': controllerId,
    'labelText': labelText,
    'hintText': hintText,
    'helperText': helperText,
    'errorText': errorText,
    'prefixIcon': prefixIcon,
    'suffixIcon': suffixIcon,
    'border': border,
    'enabledBorder': enabledBorder,
    'focusedBorder': focusedBorder,
    'errorBorder': errorBorder,
    'filled': filled,
    'fillColor': fillColor,
    'contentPadding': contentPadding,
    'keyboardType': keyboardType,
    'textInputAction': textInputAction,
    'obscureText': obscureText,
    'maxLines': maxLines,
    'maxLength': maxLength,
    'enabled': enabled,
    'readOnly': readOnly,
    'autofocus': autofocus,
    'style': style,
    'onChanged': onChanged,
    'onSubmitted': onSubmitted,
  };
}

class SCheckbox extends SWidget {
  final String? stateKey;
  final bool? value;
  final String? onChanged;
  final String? activeColor;
  final String? checkColor;

  SCheckbox({
    this.stateKey,
    this.value,
    this.onChanged,
    this.activeColor,
    this.checkColor,
  });

  @override
  String get type => 'checkbox';

  @override
  Map<String, dynamic> args() => {
    'stateKey': stateKey,
    'value': value,
    'onChanged': onChanged,
    'activeColor': activeColor,
    'checkColor': checkColor,
  };
}

class SSwitch extends SWidget {
  final String? stateKey;
  final bool? value;
  final String? onChanged;
  final String? activeColor;
  final String? activeTrackColor;
  final String? inactiveThumbColor;
  final String? inactiveTrackColor;

  SSwitch({
    this.stateKey,
    this.value,
    this.onChanged,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
  });

  @override
  String get type => 'switch';

  @override
  Map<String, dynamic> args() => {
    'stateKey': stateKey,
    'value': value,
    'onChanged': onChanged,
    'activeColor': activeColor,
    'activeTrackColor': activeTrackColor,
    'inactiveThumbColor': inactiveThumbColor,
    'inactiveTrackColor': inactiveTrackColor,
  };
}

class SRadio extends SWidget {
  final String? stateKey;
  final dynamic value;
  final dynamic groupValue;
  final String? onChanged;
  final String? activeColor;

  SRadio({
    this.stateKey,
    this.value,
    this.groupValue,
    this.onChanged,
    this.activeColor,
  });

  @override
  String get type => 'radio';

  @override
  Map<String, dynamic> args() => {
    'stateKey': stateKey,
    'value': value,
    'groupValue': groupValue,
    'onChanged': onChanged,
    'activeColor': activeColor,
  };
}

class SSlider extends SWidget {
  final String? stateKey;
  final double? value;
  final double? min;
  final double? max;
  final int? divisions;
  final String? label;
  final String? onChanged;
  final String? activeColor;
  final String? inactiveColor;

  SSlider({
    this.stateKey,
    this.value,
    this.min,
    this.max,
    this.divisions,
    this.label,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  String get type => 'slider';

  @override
  Map<String, dynamic> args() => {
    'stateKey': stateKey,
    'value': value,
    'min': min,
    'max': max,
    'divisions': divisions,
    'label': label,
    'onChanged': onChanged,
    'activeColor': activeColor,
    'inactiveColor': inactiveColor,
  };
}

class SDropdown extends SWidget {
  final String? stateKey;
  final dynamic value;
  final List<Map<String, dynamic>> items;
  final String? onChanged;
  final bool? isExpanded;
  final String? hint;
  final String? disabledHint;
  final String? dropdownColor;
  final String? iconEnabledColor;
  final String? iconDisabledColor;

  SDropdown({
    this.stateKey,
    this.value,
    required this.items,
    this.onChanged,
    this.isExpanded,
    this.hint,
    this.disabledHint,
    this.dropdownColor,
    this.iconEnabledColor,
    this.iconDisabledColor,
  });

  @override
  String get type => 'dropdown';

  @override
  Map<String, dynamic> args() => {
    'stateKey': stateKey,
    'value': value,
    'items': items,
    'onChanged': onChanged,
    'isExpanded': isExpanded,
    'hint': hint,
    'disabledHint': disabledHint,
    'dropdownColor': dropdownColor,
    'iconEnabledColor': iconEnabledColor,
    'iconDisabledColor': iconDisabledColor,
  };
}

class SDatePicker extends SWidget {
  final String? initialDate;
  final String? firstDate;
  final String? lastDate;
  final String? onSelected;
  final SWidget child;

  SDatePicker({
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onSelected,
    required this.child,
  });

  @override
  String get type => 'date_picker';

  @override
  Map<String, dynamic> args() => {
    'initialDate': initialDate,
    'firstDate': firstDate,
    'lastDate': lastDate,
    'onSelected': onSelected,
    'child': child,
  };
}

class STimePicker extends SWidget {
  final String? onSelected;
  final SWidget child;

  STimePicker({
    this.onSelected,
    required this.child,
  });

  @override
  String get type => 'time_picker';

  @override
  Map<String, dynamic> args() => {
    'onSelected': onSelected,
    'child': child,
  };
}

// ============================================================================
// GESTURES
// ============================================================================

class SGestureDetector extends SWidget {
  final String? onTap;
  final String? onDoubleTap;
  final String? onLongPress;
  final String? onPanStart;
  final String? onPanUpdate;
  final String? onPanEnd;
  final String? behavior;
  final SWidget child;

  SGestureDetector({
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.behavior,
    required this.child,
  });

  @override
  String get type => 'gesture_detector';

  @override
  Map<String, dynamic> args() => {
    'onTap': onTap,
    'onDoubleTap': onDoubleTap,
    'onLongPress': onLongPress,
    'onPanStart': onPanStart,
    'onPanUpdate': onPanUpdate,
    'onPanEnd': onPanEnd,
    'behavior': behavior,
    'child': child,
  };
}

class SInkWell extends SWidget {
  final String? onTap;
  final String? onDoubleTap;
  final String? onLongPress;
  final double? borderRadius;
  final String? splashColor;
  final String? highlightColor;
  final String? hoverColor;
  final SWidget child;

  SInkWell({
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.borderRadius,
    this.splashColor,
    this.highlightColor,
    this.hoverColor,
    required this.child,
  });

  @override
  String get type => 'inkwell';

  @override
  Map<String, dynamic> args() => {
    'onTap': onTap,
    'onDoubleTap': onDoubleTap,
    'onLongPress': onLongPress,
    'borderRadius': borderRadius,
    'splashColor': splashColor,
    'highlightColor': highlightColor,
    'hoverColor': hoverColor,
    'child': child,
  };
}

class SDismissible extends SWidget {
  final String key;
  final String? direction;
  final String? onDismissed;
  final SWidget? background;
  final SWidget? secondaryBackground;
  final bool? confirmDismiss;
  final SWidget child;

  SDismissible({
    required this.key,
    this.direction,
    this.onDismissed,
    this.background,
    this.secondaryBackground,
    this.confirmDismiss,
    required this.child,
  });

  @override
  String get type => 'dismissible';

  @override
  Map<String, dynamic> args() => {
    'key': key,
    'direction': direction,
    'onDismissed': onDismissed,
    'background': background,
    'secondaryBackground': secondaryBackground,
    'confirmDismiss': confirmDismiss,
    'child': child,
  };
}

// ============================================================================
// NAVIGATION
// ============================================================================

class SBottomNavigationBar extends SWidget {
  final List<Map<String, dynamic>> items;
  final String? stateKey;
  final int? currentIndex;
  final String? onTap;
  final String? backgroundColor;
  final String? selectedItemColor;
  final String? unselectedItemColor;
  
  // FIX 1: Renamed variable to avoid collision with base class
  final String? barType; 
  final double? elevation;

  SBottomNavigationBar({
    required this.items,
    this.stateKey,
    this.currentIndex,
    this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.barType, // Updated constructor
    this.elevation,
  });

  @override
  String get type => 'bottom_navigation_bar';

  @override
  Map<String, dynamic> args() => {
    'items': items,
    'stateKey': stateKey,
    'currentIndex': currentIndex,
    'onTap': onTap,
    'backgroundColor': backgroundColor,
    'selectedItemColor': selectedItemColor,
    'unselectedItemColor': unselectedItemColor,
    
    // FIX 2: Map the new variable name back to the 'type' key for JSON
    'type': barType, 
    
    'elevation': elevation,
  };
}

class SDrawer extends SWidget {
  final String? backgroundColor;
  final double? elevation;
  final double? width;
  final SWidget child;

  SDrawer({
    this.backgroundColor,
    this.elevation,
    this.width,
    required this.child,
  });

  @override
  String get type => 'drawer';

  @override
  Map<String, dynamic> args() => {
    'backgroundColor': backgroundColor,
    'elevation': elevation,
    'width': width,
    'child': child,
  };
}

class STabBar extends SWidget {
  final List<SWidget> tabs;
  final bool? isScrollable;
  final String? indicatorColor;
  final double? indicatorWeight;
  final String? labelColor;
  final String? unselectedLabelColor;
  final Map<String, dynamic>? labelStyle;
  final Map<String, dynamic>? unselectedLabelStyle;

  STabBar({
    required this.tabs,
    this.isScrollable,
    this.indicatorColor,
    this.indicatorWeight,
    this.labelColor,
    this.unselectedLabelColor,
    this.labelStyle,
    this.unselectedLabelStyle,
  });

  @override
  String get type => 'tab_bar';

  @override
  Map<String, dynamic> args() => {
    'tabs': tabs,
    'isScrollable': isScrollable,
    'indicatorColor': indicatorColor,
    'indicatorWeight': indicatorWeight,
    'labelColor': labelColor,
    'unselectedLabelColor': unselectedLabelColor,
    'labelStyle': labelStyle,
    'unselectedLabelStyle': unselectedLabelStyle,
  };
}

class STabBarView extends SWidget {
  final List<SWidget> children;

  STabBarView({required this.children});

  @override
  String get type => 'tab_bar_view';

  @override
  Map<String, dynamic> args() => {
    'children': children,
  };
}

// ============================================================================
// DIALOGS & OVERLAYS
// ============================================================================

class SAlertDialog extends SWidget {
  final SWidget? title;
  final SWidget? content;
  final List<SWidget>? actions;
  final String? backgroundColor;
  final double? elevation;
  final String? shape;
  final double? borderRadius;
  final Map<String, dynamic>? titleTextStyle;
  final Map<String, dynamic>? contentTextStyle;

  SAlertDialog({
    this.title,
    this.content,
    this.actions,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.borderRadius,
    this.titleTextStyle,
    this.contentTextStyle,
  });

  @override
  String get type => 'alert_dialog';

  @override
  Map<String, dynamic> args() => {
    'title': title,
    'content': content,
    'actions': actions,
    'backgroundColor': backgroundColor,
    'elevation': elevation,
    'shape': shape,
    'borderRadius': borderRadius,
    'titleTextStyle': titleTextStyle,
    'contentTextStyle': contentTextStyle,
  };
}

class SBottomSheet extends SWidget {
  final String? backgroundColor;
  final SWidget child;

  SBottomSheet({
    this.backgroundColor,
    required this.child,
  });

  @override
  String get type => 'bottom_sheet';

  @override
  Map<String, dynamic> args() => {
    'backgroundColor': backgroundColor,
    'child': child,
  };
}

class SSnackBar extends SWidget {
  final String? backgroundColor;
  final SWidget content;

  SSnackBar({
    this.backgroundColor,
    required this.content,
  });

  @override
  String get type => 'snack_bar';

  @override
  Map<String, dynamic> args() => {
    'backgroundColor': backgroundColor,
    'content': content,
  };
}

// ============================================================================
// DECORATIVE
// ============================================================================

class SOpacity extends SWidget {
  final double opacity;
  final SWidget child;

  SOpacity({
    required this.opacity,
    required this.child,
  });

  @override
  String get type => 'opacity';

  @override
  Map<String, dynamic> args() => {
    'opacity': opacity,
    'child': child,
  };
}

class STransform extends SWidget {
  final double? rotate;
  final double? scale;
  final List<double>? translate;
  final dynamic matrix;
  final String? alignment;
  final SWidget child;

  STransform({
    this.rotate,
    this.scale,
    this.translate,
    this.matrix,
    this.alignment,
    required this.child,
  });

  @override
  String get type => 'transform';

  @override
  Map<String, dynamic> args() => {
    'rotate': rotate,
    'scale': scale,
    'translate': translate,
    'matrix': matrix,
    'alignment': alignment,
    'child': child,
  };
}

class SClipRect extends SWidget {
  final String? clipBehavior;
  final SWidget child;

  SClipRect({
    this.clipBehavior,
    required this.child,
  });

  @override
  String get type => 'clip_rect';

  @override
  Map<String, dynamic> args() => {
    'clipBehavior': clipBehavior,
    'child': child,
  };
}

class SClipRRect extends SWidget {
  final double? borderRadius;
  final String? clipBehavior;
  final SWidget child;

  SClipRRect({
    this.borderRadius,
    this.clipBehavior,
    required this.child,
  });

  @override
  String get type => 'clip_rrect';

  @override
  Map<String, dynamic> args() => {
    'borderRadius': borderRadius,
    'clipBehavior': clipBehavior,
    'child': child,
  };
}

class SClipOval extends SWidget {
  final String? clipBehavior;
  final SWidget child;

  SClipOval({
    this.clipBehavior,
    required this.child,
  });

  @override
  String get type => 'clip_oval';

  @override
  Map<String, dynamic> args() => {
    'clipBehavior': clipBehavior,
    'child': child,
  };
}

class SBackdropFilter extends SWidget {
  final Map<String, dynamic> filter;
  final SWidget child;

  SBackdropFilter({
    required this.filter,
    required this.child,
  });

  @override
  String get type => 'backdrop_filter';

  @override
  Map<String, dynamic> args() => {
    'filter': filter,
    'child': child,
  };
}

// ============================================================================
// CONDITIONAL & CONTROL
// ============================================================================

class SConditional extends SWidget {
  final dynamic condition;
  final SWidget then;
  final SWidget? otherwise;

  SConditional({
    required this.condition,
    required this.then,
    this.otherwise,
  });

  @override
  String get type => 'conditional';

  @override
  Map<String, dynamic> args() => {
    'condition': condition,
    'then': then,
    'else': otherwise,
  };
}

class SVisibility extends SWidget {
  final bool? visible;
  final bool? maintainSize;
  final bool? maintainAnimation;
  final bool? maintainState;
  final SWidget? replacement;
  final SWidget child;

  SVisibility({
    this.visible,
    this.maintainSize,
    this.maintainAnimation,
    this.maintainState,
    this.replacement,
    required this.child,
  });

  @override
  String get type => 'visibility';

  @override
  Map<String, dynamic> args() => {
    'visible': visible,
    'maintainSize': maintainSize,
    'maintainAnimation': maintainAnimation,
    'maintainState': maintainState,
    'replacement': replacement,
    'child': child,
  };
}

class SStatefulBuilder extends SWidget {
  final SWidget child;

  SStatefulBuilder({required this.child});

  @override
  String get type => 'stateful_builder';

  @override
  Map<String, dynamic> args() => {
    'child': child,
  };
}

// ============================================================================
// CUPERTINO (iOS)
// ============================================================================

class SCupertinoButton extends SWidget {
  final String? onPressed;
  final String? color;
  final dynamic padding;
  final double? borderRadius;
  final double? minSize;
  final SWidget child;

  SCupertinoButton({
    this.onPressed,
    this.color,
    this.padding,
    this.borderRadius,
    this.minSize,
    required this.child,
  });

  @override
  String get type => 'cupertino_button';

  @override
  Map<String, dynamic> args() => {
    'onPressed': onPressed,
    'color': color,
    'padding': padding,
    'borderRadius': borderRadius,
    'minSize': minSize,
    'child': child,
  };
}

class SCupertinoSwitch extends SWidget {
  final String? stateKey;
  final bool? value;
  final String? onChanged;
  final String? activeColor;
  final String? trackColor;

  SCupertinoSwitch({
    this.stateKey,
    this.value,
    this.onChanged,
    this.activeColor,
    this.trackColor,
  });

  @override
  String get type => 'cupertino_switch';

  @override
  Map<String, dynamic> args() => {
    'stateKey': stateKey,
    'value': value,
    'onChanged': onChanged,
    'activeColor': activeColor,
    'trackColor': trackColor,
  };
}

class SCupertinoSlider extends SWidget {
  final String? stateKey;
  final double? value;
  final double? min;
  final double? max;
  final int? divisions;
  final String? onChanged;
  final String? activeColor;

  SCupertinoSlider({
    this.stateKey,
    this.value,
    this.min,
    this.max,
    this.divisions,
    this.onChanged,
    this.activeColor,
  });

  @override
  String get type => 'cupertino_slider';

  @override
  Map<String, dynamic> args() => {
    'stateKey': stateKey,
    'value': value,
    'min': min,
    'max': max,
    'divisions': divisions,
    'onChanged': onChanged,
    'activeColor': activeColor,
  };
}