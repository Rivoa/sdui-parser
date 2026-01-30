import 'package:flutter/material.dart';
import 'dart:ui';

// === PARSING HELPERS ===

class SduiParsingHelpers {
  // === TYPE CONVERTERS ===
  
  static double? toDouble(dynamic val) {
    if (val == null) return null;
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val);
    return null;
  }

  static int? toInt(dynamic val) {
    if (val == null) return null;
    if (val is int) return val;
    if (val is num) return val.toInt();
    if (val is String) return int.tryParse(val);
    return null;
  }

  static bool toBool(dynamic val, {bool defaultValue = false}) {
    if (val == null) return defaultValue;
    if (val is bool) return val;
    if (val is String) {
      return val.toLowerCase() == 'true' || val == '1';
    }
    if (val is num) return val != 0;
    return defaultValue;
  }

  // === COLOR PARSING ===
  
  static Color? parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    
    try {
      String colorString = hex.toUpperCase().replaceAll('#', '');
      
      // Handle named colors
      final namedColors = {
        'RED': Colors.red,
        'BLUE': Colors.blue,
        'GREEN': Colors.green,
        'YELLOW': Colors.yellow,
        'ORANGE': Colors.orange,
        'PURPLE': Colors.purple,
        'PINK': Colors.pink,
        'TEAL': Colors.teal,
        'CYAN': Colors.cyan,
        'INDIGO': Colors.indigo,
        'LIME': Colors.lime,
        'AMBER': Colors.amber,
        'BLACK': Colors.black,
        'WHITE': Colors.white,
        'GREY': Colors.grey,
        'GRAY': Colors.grey,
        'TRANSPARENT': Colors.transparent,
      };
      
      if (namedColors.containsKey(colorString)) {
        return namedColors[colorString];
      }
      
      // Handle hex colors
      if (colorString.length == 6) {
        colorString = 'FF' + colorString; // Add alpha
      } else if (colorString.length == 3) {
        // Convert shorthand (e.g., 'F00' -> 'FF0000')
        colorString = 'FF' + 
          colorString[0] + colorString[0] +
          colorString[1] + colorString[1] +
          colorString[2] + colorString[2];
      } else if (colorString.length == 4) {
        // Convert shorthand with alpha (e.g., '8F00' -> '88FF0000')
        colorString = 
          colorString[0] + colorString[0] +
          colorString[1] + colorString[1] +
          colorString[2] + colorString[2] +
          colorString[3] + colorString[3];
      }
      
      if (colorString.length == 8) {
        return Color(int.parse(colorString, radix: 16));
      }
    } catch (e) {
      debugPrint('Error parsing color: $hex - $e');
    }
    
    return null;
  }

  // === EDGE INSETS PARSING ===
  
  static EdgeInsets parsePadding(dynamic val) {
    if (val == null) return EdgeInsets.zero;
    
    if (val is num) {
      return EdgeInsets.all(val.toDouble());
    }
    
    if (val is String) {
      final parts = val.split(',').map((e) => e.trim()).toList();
      if (parts.length == 1) {
        final value = double.tryParse(parts[0]) ?? 0;
        return EdgeInsets.all(value);
      } else if (parts.length == 2) {
        final vertical = double.tryParse(parts[0]) ?? 0;
        final horizontal = double.tryParse(parts[1]) ?? 0;
        return EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal);
      } else if (parts.length == 4) {
        return EdgeInsets.fromLTRB(
          double.tryParse(parts[0]) ?? 0,
          double.tryParse(parts[1]) ?? 0,
          double.tryParse(parts[2]) ?? 0,
          double.tryParse(parts[3]) ?? 0,
        );
      }
    }
    
    if (val is List) {
      if (val.length == 1) {
        return EdgeInsets.all(toDouble(val[0]) ?? 0);
      } else if (val.length == 2) {
        return EdgeInsets.symmetric(
          vertical: toDouble(val[0]) ?? 0,
          horizontal: toDouble(val[1]) ?? 0,
        );
      } else if (val.length == 4) {
        return EdgeInsets.fromLTRB(
          toDouble(val[0]) ?? 0,
          toDouble(val[1]) ?? 0,
          toDouble(val[2]) ?? 0,
          toDouble(val[3]) ?? 0,
        );
      }
    }
    
    if (val is Map<String, dynamic>) {
      return EdgeInsets.only(
        left: toDouble(val['left']) ?? 0,
        top: toDouble(val['top']) ?? 0,
        right: toDouble(val['right']) ?? 0,
        bottom: toDouble(val['bottom']) ?? 0,
      );
    }
    
    return EdgeInsets.zero;
  }

  // === ALIGNMENT PARSING ===
  
  static Alignment? parseAlignment(String? val) {
    if (val == null) return null;
    
    final alignments = {
      'topLeft': Alignment.topLeft,
      'topCenter': Alignment.topCenter,
      'topRight': Alignment.topRight,
      'centerLeft': Alignment.centerLeft,
      'center': Alignment.center,
      'centerRight': Alignment.centerRight,
      'bottomLeft': Alignment.bottomLeft,
      'bottomCenter': Alignment.bottomCenter,
      'bottomRight': Alignment.bottomRight,
    };
    
    return alignments[val];
  }

  // === AXIS ALIGNMENT PARSING ===
  
  static MainAxisAlignment parseMainAxis(String? val) {
    final alignments = {
      'start': MainAxisAlignment.start,
      'center': MainAxisAlignment.center,
      'end': MainAxisAlignment.end,
      'spaceBetween': MainAxisAlignment.spaceBetween,
      'spaceAround': MainAxisAlignment.spaceAround,
      'spaceEvenly': MainAxisAlignment.spaceEvenly,
    };
    
    return alignments[val] ?? MainAxisAlignment.start;
  }

  static CrossAxisAlignment parseCrossAxis(String? val) {
    final alignments = {
      'start': CrossAxisAlignment.start,
      'center': CrossAxisAlignment.center,
      'end': CrossAxisAlignment.end,
      'stretch': CrossAxisAlignment.stretch,
      'baseline': CrossAxisAlignment.baseline,
    };
    
    return alignments[val] ?? CrossAxisAlignment.start;
  }

  static MainAxisSize parseMainAxisSize(String? val) {
    return val == 'min' ? MainAxisSize.min : MainAxisSize.max;
  }

  static WrapAlignment parseWrapAlignment(String? val) {
    final alignments = {
      'start': WrapAlignment.start,
      'center': WrapAlignment.center,
      'end': WrapAlignment.end,
      'spaceBetween': WrapAlignment.spaceBetween,
      'spaceAround': WrapAlignment.spaceAround,
      'spaceEvenly': WrapAlignment.spaceEvenly,
    };
    
    return alignments[val] ?? WrapAlignment.start;
  }

  static WrapCrossAlignment parseWrapCrossAlignment(String? val) {
    final alignments = {
      'start': WrapCrossAlignment.start,
      'center': WrapCrossAlignment.center,
      'end': WrapCrossAlignment.end,
    };
    
    return alignments[val] ?? WrapCrossAlignment.start;
  }

  // === BOX FIT PARSING ===
  
  static BoxFit parseBoxFit(String? val) {
    final fits = {
      'fill': BoxFit.fill,
      'contain': BoxFit.contain,
      'cover': BoxFit.cover,
      'fitWidth': BoxFit.fitWidth,
      'fitHeight': BoxFit.fitHeight,
      'none': BoxFit.none,
      'scaleDown': BoxFit.scaleDown,
    };
    
    return fits[val] ?? BoxFit.contain;
  }

  // === AXIS PARSING ===
  
  static Axis parseAxis(String? val) {
    return val == 'horizontal' ? Axis.horizontal : Axis.vertical;
  }

  // === TEXT PARSING ===
  
  static TextAlign parseTextAlign(String? val) {
    final aligns = {
      'left': TextAlign.left,
      'right': TextAlign.right,
      'center': TextAlign.center,
      'justify': TextAlign.justify,
      'start': TextAlign.start,
      'end': TextAlign.end,
    };
    
    return aligns[val] ?? TextAlign.left;
  }

  static TextOverflow parseTextOverflow(String? val) {
    final overflows = {
      'clip': TextOverflow.clip,
      'fade': TextOverflow.fade,
      'ellipsis': TextOverflow.ellipsis,
      'visible': TextOverflow.visible,
    };
    
    return overflows[val] ?? TextOverflow.clip;
  }

  static TextStyle? parseTextStyle(Map<String, dynamic>? style) {
    if (style == null) return null;
    
    return TextStyle(
      fontSize: toDouble(style['fontSize']),
      fontWeight: _parseFontWeight(style['fontWeight']),
      fontStyle: style['fontStyle'] == 'italic' ? FontStyle.italic : FontStyle.normal,
      color: parseColor(style['color']),
      backgroundColor: parseColor(style['backgroundColor']),
      letterSpacing: toDouble(style['letterSpacing']),
      wordSpacing: toDouble(style['wordSpacing']),
      height: toDouble(style['height']),
      decoration: _parseTextDecoration(style['decoration']),
      decorationColor: parseColor(style['decorationColor']),
      decorationStyle: _parseTextDecorationStyle(style['decorationStyle']),
      decorationThickness: toDouble(style['decorationThickness']),
      fontFamily: style['fontFamily'],
      shadows: _parseTextShadows(style['shadows']),
    );
  }

  static FontWeight? _parseFontWeight(dynamic val) {
    if (val == null) return null;
    
    if (val is String) {
      final weights = {
        'thin': FontWeight.w100,
        'extraLight': FontWeight.w200,
        'light': FontWeight.w300,
        'normal': FontWeight.w400,
        'medium': FontWeight.w500,
        'semiBold': FontWeight.w600,
        'bold': FontWeight.w700,
        'extraBold': FontWeight.w800,
        'black': FontWeight.w900,
      };
      
      return weights[val];
    }
    
    if (val is int) {
      return FontWeight.values[(val ~/ 100 - 1).clamp(0, 8)];
    }
    
    return null;
  }

  static TextDecoration? _parseTextDecoration(String? val) {
    final decorations = {
      'none': TextDecoration.none,
      'underline': TextDecoration.underline,
      'overline': TextDecoration.overline,
      'lineThrough': TextDecoration.lineThrough,
    };
    
    return decorations[val];
  }

  static TextDecorationStyle? _parseTextDecorationStyle(String? val) {
    final styles = {
      'solid': TextDecorationStyle.solid,
      'double': TextDecorationStyle.double,
      'dotted': TextDecorationStyle.dotted,
      'dashed': TextDecorationStyle.dashed,
      'wavy': TextDecorationStyle.wavy,
    };
    
    return styles[val];
  }

  static List<Shadow>? _parseTextShadows(dynamic shadows) {
    if (shadows is! List) return null;
    
    return shadows.map((shadow) {
      if (shadow is! Map<String, dynamic>) return const Shadow();
      
      return Shadow(
        color: parseColor(shadow['color']) ?? Colors.black,
        offset: Offset(
          toDouble(shadow['offsetX']) ?? 0,
          toDouble(shadow['offsetY']) ?? 0,
        ),
        blurRadius: toDouble(shadow['blurRadius']) ?? 0,
      );
    }).toList();
  }

  // === ICON PARSING ===
  
  static IconData parseIconData(String? name) {
    if (name == null || name.isEmpty) return Icons.help_outline;
    
    // Common icons mapping
    final icons = {
      // Navigation
      'home': Icons.home,
      'menu': Icons.menu,
      'arrow_back': Icons.arrow_back,
      'arrow_forward': Icons.arrow_forward,
      'arrow_upward': Icons.arrow_upward,
      'arrow_downward': Icons.arrow_downward,
      'close': Icons.close,
      'more_vert': Icons.more_vert,
      'more_horiz': Icons.more_horiz,
      
      // Actions
      'add': Icons.add,
      'remove': Icons.remove,
      'edit': Icons.edit,
      'delete': Icons.delete,
      'save': Icons.save,
      'search': Icons.search,
      'refresh': Icons.refresh,
      'share': Icons.share,
      'favorite': Icons.favorite,
      'favorite_border': Icons.favorite_border,
      'star': Icons.star,
      'star_border': Icons.star_border,
      
      // Content
      'content_copy': Icons.content_copy,
      'content_cut': Icons.content_cut,
      'content_paste': Icons.content_paste,
      'attach_file': Icons.attach_file,
      'download': Icons.download,
      'upload': Icons.upload,
      
      // Communication
      'call': Icons.call,
      'email': Icons.email,
      'message': Icons.message,
      'chat': Icons.chat,
      'notifications': Icons.notifications,
      'notifications_off': Icons.notifications_off,
      
      // Media
      'play_arrow': Icons.play_arrow,
      'pause': Icons.pause,
      'stop': Icons.stop,
      'skip_next': Icons.skip_next,
      'skip_previous': Icons.skip_previous,
      'volume_up': Icons.volume_up,
      'volume_down': Icons.volume_down,
      'volume_off': Icons.volume_off,
      
      // Device
      'phone': Icons.phone,
      'tablet': Icons.tablet,
      'computer': Icons.computer,
      'camera': Icons.camera,
      'photo_camera': Icons.photo_camera,
      'videocam': Icons.videocam,
      
      // File
      'folder': Icons.folder,
      'folder_open': Icons.folder_open,
      'insert_drive_file': Icons.insert_drive_file,
      'description': Icons.description,
      'cloud': Icons.cloud,
      'cloud_upload': Icons.cloud_upload,
      'cloud_download': Icons.cloud_download,
      
      // Status
      'check': Icons.check,
      'check_circle': Icons.check_circle,
      'cancel': Icons.cancel,
      'error': Icons.error,
      'warning': Icons.warning,
      'info': Icons.info,
      
      // User
      'person': Icons.person,
      'person_add': Icons.person_add,
      'group': Icons.group,
      'account_circle': Icons.account_circle,
      
      // Settings
      'settings': Icons.settings,
      'tune': Icons.tune,
      'filter_list': Icons.filter_list,
      'sort': Icons.sort,
      
      // Shopping
      'shopping_cart': Icons.shopping_cart,
      'shopping_bag': Icons.shopping_bag,
      'payment': Icons.payment,
      
      // Location
      'location_on': Icons.location_on,
      'location_off': Icons.location_off,
      'map': Icons.map,
      'navigation': Icons.navigation,
      
      // Time
      'access_time': Icons.access_time,
      'schedule': Icons.schedule,
      'event': Icons.event,
      'today': Icons.today,
      
      // Misc
      'lock': Icons.lock,
      'lock_open': Icons.lock_open,
      'visibility': Icons.visibility,
      'visibility_off': Icons.visibility_off,
      'help': Icons.help,
      'help_outline': Icons.help_outline,
      'lightbulb': Icons.lightbulb,
      'emoji_emotions': Icons.emoji_emotions,
    };
    
    return icons[name] ?? Icons.help_outline;
  }

  // === SCROLL PHYSICS PARSING ===
  
  static ScrollPhysics? parseScrollPhysics(String? val) {
    final physics = {
      'never': const NeverScrollableScrollPhysics(),
      'always': const AlwaysScrollableScrollPhysics(),
      'bouncing': const BouncingScrollPhysics(),
      'clamping': const ClampingScrollPhysics(),
    };
    
    return physics[val];
  }

  // === STACK FIT PARSING ===
  
  static StackFit parseStackFit(String? val) {
    final fits = {
      'loose': StackFit.loose,
      'expand': StackFit.expand,
      'passthrough': StackFit.passthrough,
    };
    
    return fits[val] ?? StackFit.loose;
  }

  // === CLIP BEHAVIOR PARSING ===
  
  static Clip parseClip(String? val) {
    final clips = {
      'none': Clip.none,
      'hardEdge': Clip.hardEdge,
      'antiAlias': Clip.antiAlias,
      'antiAliasWithSaveLayer': Clip.antiAliasWithSaveLayer,
    };
    
    return clips[val] ?? Clip.none;
  }

  // === FLEX FIT PARSING ===
  
  static FlexFit parseFlexFit(String? val) {
    return val == 'loose' ? FlexFit.loose : FlexFit.tight;
  }

  // === GRADIENT PARSING ===
  
  static Gradient? parseGradient(Map<String, dynamic>? gradient) {
    if (gradient == null) return null;
    
    final type = gradient['type'] as String?;
    final colors = (gradient['colors'] as List?)
        ?.map((c) => parseColor(c))
        .whereType<Color>()
        .toList();
    
    if (colors == null || colors.isEmpty) return null;
    
    final stops = (gradient['stops'] as List?)
        ?.map((s) => toDouble(s))
        .whereType<double>()
        .toList();
    
    switch (type) {
      case 'linear':
        return LinearGradient(
          colors: colors,
          stops: stops,
          begin: parseAlignment(gradient['begin']) ?? Alignment.centerLeft,
          end: parseAlignment(gradient['end']) ?? Alignment.centerRight,
        );
      case 'radial':
        return RadialGradient(
          colors: colors,
          stops: stops,
          center: parseAlignment(gradient['center']) ?? Alignment.center,
          radius: toDouble(gradient['radius']) ?? 0.5,
        );
      case 'sweep':
        return SweepGradient(
          colors: colors,
          stops: stops,
          center: parseAlignment(gradient['center']) ?? Alignment.center,
          startAngle: toDouble(gradient['startAngle']) ?? 0.0,
          endAngle: toDouble(gradient['endAngle']) ?? 6.283185307179586, // 2*pi
        );
      default:
        return LinearGradient(colors: colors, stops: stops);
    }
  }

  // === BOX SHADOW PARSING ===
  
  static List<BoxShadow>? parseBoxShadow(dynamic shadows) {
    if (shadows == null) return null;
    
    if (shadows is! List) {
      shadows = [shadows];
    }
    
    return shadows.map((shadow) {
      if (shadow is! Map<String, dynamic>) return const BoxShadow();
      
      return BoxShadow(
        color: parseColor(shadow['color']) ?? Colors.black26,
        offset: Offset(
          toDouble(shadow['offsetX']) ?? 0,
          toDouble(shadow['offsetY']) ?? 0,
        ),
        blurRadius: toDouble(shadow['blurRadius']) ?? 0,
        spreadRadius: toDouble(shadow['spreadRadius']) ?? 0,
      );
    }).toList();
  }

  // === BOX CONSTRAINTS PARSING ===
  
  static BoxConstraints? parseBoxConstraints(Map<String, dynamic>? constraints) {
    if (constraints == null) return null;
    
    return BoxConstraints(
      minWidth: toDouble(constraints['minWidth']) ?? 0.0,
      maxWidth: toDouble(constraints['maxWidth']) ?? double.infinity,
      minHeight: toDouble(constraints['minHeight']) ?? 0.0,
      maxHeight: toDouble(constraints['maxHeight']) ?? double.infinity,
    );
  }

  // === MATRIX4 PARSING ===
  
  static Matrix4? parseMatrix4(dynamic matrix) {
    if (matrix == null) return null;
    
    if (matrix is List && matrix.length == 16) {
      return Matrix4(
        toDouble(matrix[0]) ?? 0, toDouble(matrix[1]) ?? 0, toDouble(matrix[2]) ?? 0, toDouble(matrix[3]) ?? 0,
        toDouble(matrix[4]) ?? 0, toDouble(matrix[5]) ?? 0, toDouble(matrix[6]) ?? 0, toDouble(matrix[7]) ?? 0,
        toDouble(matrix[8]) ?? 0, toDouble(matrix[9]) ?? 0, toDouble(matrix[10]) ?? 0, toDouble(matrix[11]) ?? 0,
        toDouble(matrix[12]) ?? 0, toDouble(matrix[13]) ?? 0, toDouble(matrix[14]) ?? 0, toDouble(matrix[15]) ?? 0,
      );
    }
    
    return null;
  }

  // === SHAPE BORDER PARSING ===
  
  static ShapeBorder? parseShapeBorder(String? shape, dynamic borderRadius) {
    if (shape == 'circle') {
      return const CircleBorder();
    }
    
    if (shape == 'stadium') {
      return const StadiumBorder();
    }
    
    final radius = toDouble(borderRadius) ?? 0;
    if (radius > 0) {
      return RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      );
    }
    
    return null;
  }

  // === INPUT BORDER PARSING ===
  
  static InputBorder? parseInputBorder(dynamic border) {
    if (border == null) return null;
    
    if (border == 'outline') {
      return const OutlineInputBorder();
    }
    
    if (border == 'underline') {
      return const UnderlineInputBorder();
    }
    
    if (border == 'none') {
      return InputBorder.none;
    }
    
    if (border is Map<String, dynamic>) {
      final type = border['type'] as String?;
      final borderRadius = toDouble(border['borderRadius']) ?? 4.0;
      final borderSide = BorderSide(
        color: parseColor(border['color']) ?? Colors.grey,
        width: toDouble(border['width']) ?? 1.0,
      );
      
      if (type == 'outline') {
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: borderSide,
        );
      }
      
      if (type == 'underline') {
        return UnderlineInputBorder(
          borderSide: borderSide,
        );
      }
    }
    
    return const OutlineInputBorder();
  }

  // === TEXT INPUT TYPE PARSING ===
  
  static TextInputType parseTextInputType(String? type) {
    final types = {
      'text': TextInputType.text,
      'multiline': TextInputType.multiline,
      'number': TextInputType.number,
      'phone': TextInputType.phone,
      'datetime': TextInputType.datetime,
      'emailAddress': TextInputType.emailAddress,
      'url': TextInputType.url,
      'visiblePassword': TextInputType.visiblePassword,
      'name': TextInputType.name,
      'streetAddress': TextInputType.streetAddress,
    };
    
    return types[type] ?? TextInputType.text;
  }

  // === TEXT INPUT ACTION PARSING ===
  
  static TextInputAction parseTextInputAction(String? action) {
    final actions = {
      'none': TextInputAction.none,
      'unspecified': TextInputAction.unspecified,
      'done': TextInputAction.done,
      'go': TextInputAction.go,
      'search': TextInputAction.search,
      'send': TextInputAction.send,
      'next': TextInputAction.next,
      'previous': TextInputAction.previous,
      'continueAction': TextInputAction.continueAction,
      'join': TextInputAction.join,
      'route': TextInputAction.route,
      'emergencyCall': TextInputAction.emergencyCall,
      'newline': TextInputAction.newline,
    };
    
    return actions[action] ?? TextInputAction.done;
  }

  // === SIZE PARSING ===
  
  static Size? parseSize(dynamic size) {
    if (size == null) return null;
    
    if (size is Map<String, dynamic>) {
      return Size(
        toDouble(size['width']) ?? 0,
        toDouble(size['height']) ?? 0,
      );
    }
    
    if (size is List && size.length == 2) {
      return Size(
        toDouble(size[0]) ?? 0,
        toDouble(size[1]) ?? 0,
      );
    }
    
    return null;
  }

  // === IMAGE REPEAT PARSING ===
  
  static ImageRepeat parseImageRepeat(String? repeat) {
    final repeats = {
      'repeat': ImageRepeat.repeat,
      'repeatX': ImageRepeat.repeatX,
      'repeatY': ImageRepeat.repeatY,
      'noRepeat': ImageRepeat.noRepeat,
    };
    
    return repeats[repeat] ?? ImageRepeat.noRepeat;
  }

  // === BLEND MODE PARSING ===
  
  static BlendMode? parseBlendMode(String? mode) {
    final modes = {
      'clear': BlendMode.clear,
      'src': BlendMode.src,
      'dst': BlendMode.dst,
      'srcOver': BlendMode.srcOver,
      'dstOver': BlendMode.dstOver,
      'srcIn': BlendMode.srcIn,
      'dstIn': BlendMode.dstIn,
      'srcOut': BlendMode.srcOut,
      'dstOut': BlendMode.dstOut,
      'srcATop': BlendMode.srcATop,
      'dstATop': BlendMode.dstATop,
      'xor': BlendMode.xor,
      'plus': BlendMode.plus,
      'modulate': BlendMode.modulate,
      'screen': BlendMode.screen,
      'overlay': BlendMode.overlay,
      'darken': BlendMode.darken,
      'lighten': BlendMode.lighten,
      'colorDodge': BlendMode.colorDodge,
      'colorBurn': BlendMode.colorBurn,
      'hardLight': BlendMode.hardLight,
      'softLight': BlendMode.softLight,
      'difference': BlendMode.difference,
      'exclusion': BlendMode.exclusion,
      'multiply': BlendMode.multiply,
      'hue': BlendMode.hue,
      'saturation': BlendMode.saturation,
      'color': BlendMode.color,
      'luminosity': BlendMode.luminosity,
    };
    
    return modes[mode];
  }

  // === HIT TEST BEHAVIOR PARSING ===
  
  static HitTestBehavior parseHitTestBehavior(String? behavior) {
    final behaviors = {
      'deferToChild': HitTestBehavior.deferToChild,
      'opaque': HitTestBehavior.opaque,
      'translucent': HitTestBehavior.translucent,
    };
    
    return behaviors[behavior] ?? HitTestBehavior.deferToChild;
  }

  // === DISMISS DIRECTION PARSING ===
  
  static DismissDirection parseDismissDirection(String? direction) {
    final directions = {
      'horizontal': DismissDirection.horizontal,
      'vertical': DismissDirection.vertical,
      'endToStart': DismissDirection.endToStart,
      'startToEnd': DismissDirection.startToEnd,
      'up': DismissDirection.up,
      'down': DismissDirection.down,
    };
    
    return directions[direction] ?? DismissDirection.horizontal;
  }

  // === BOTTOM NAVIGATION BAR TYPE PARSING ===
  
  static BottomNavigationBarType parseBottomNavigationBarType(String? type) {
    return type == 'shifting' 
        ? BottomNavigationBarType.shifting 
        : BottomNavigationBarType.fixed;
  }

  // === FLOATING ACTION BUTTON LOCATION PARSING ===
  
  static FloatingActionButtonLocation? parseFloatingActionButtonLocation(String? location) {
    final locations = {
      'endFloat': FloatingActionButtonLocation.endFloat,
      'centerFloat': FloatingActionButtonLocation.centerFloat,
      'startFloat': FloatingActionButtonLocation.startFloat,
      'endDocked': FloatingActionButtonLocation.endDocked,
      'centerDocked': FloatingActionButtonLocation.centerDocked,
      'startDocked': FloatingActionButtonLocation.startDocked,
      'endTop': FloatingActionButtonLocation.endTop,
      'startTop': FloatingActionButtonLocation.startTop,
    };
    
    return locations[location];
  }

  // === THEME MODE PARSING ===
  
  static ThemeMode parseThemeMode(String? mode) {
    final modes = {
      'light': ThemeMode.light,
      'dark': ThemeMode.dark,
      'system': ThemeMode.system,
    };
    
    return modes[mode] ?? ThemeMode.system;
  }

  // === THEME DATA PARSING ===
  
  static ThemeData? parseThemeData(Map<String, dynamic>? theme) {
    if (theme == null) return null;
    
    return ThemeData(
      primaryColor: parseColor(theme['primaryColor']),
      colorScheme: _parseColorScheme(theme['colorScheme']),
      scaffoldBackgroundColor: parseColor(theme['scaffoldBackgroundColor']),
      appBarTheme: _parseAppBarTheme(theme['appBarTheme']),
      textTheme: _parseTextTheme(theme['textTheme']),
      iconTheme: _parseIconThemeData(theme['iconTheme']),
      useMaterial3: toBool(theme['useMaterial3'], defaultValue: true),
    );
  }

  static ColorScheme? _parseColorScheme(Map<String, dynamic>? scheme) {
    if (scheme == null) return null;
    
    // Simplified - would need all required colors in production
    return ColorScheme.fromSeed(
      seedColor: parseColor(scheme['primary']) ?? Colors.blue,
      brightness: scheme['brightness'] == 'dark' ? Brightness.dark : Brightness.light,
    );
  }

  static AppBarTheme? _parseAppBarTheme(Map<String, dynamic>? theme) {
    if (theme == null) return null;
    
    return AppBarTheme(
      backgroundColor: parseColor(theme['backgroundColor']),
      foregroundColor: parseColor(theme['foregroundColor']),
      elevation: toDouble(theme['elevation']),
      centerTitle: toBool(theme['centerTitle']),
    );
  }

  static TextTheme? _parseTextTheme(Map<String, dynamic>? theme) {
    if (theme == null) return null;
    
    return TextTheme(
      displayLarge: parseTextStyle(theme['displayLarge']),
      displayMedium: parseTextStyle(theme['displayMedium']),
      displaySmall: parseTextStyle(theme['displaySmall']),
      headlineLarge: parseTextStyle(theme['headlineLarge']),
      headlineMedium: parseTextStyle(theme['headlineMedium']),
      headlineSmall: parseTextStyle(theme['headlineSmall']),
      titleLarge: parseTextStyle(theme['titleLarge']),
      titleMedium: parseTextStyle(theme['titleMedium']),
      titleSmall: parseTextStyle(theme['titleSmall']),
      bodyLarge: parseTextStyle(theme['bodyLarge']),
      bodyMedium: parseTextStyle(theme['bodyMedium']),
      bodySmall: parseTextStyle(theme['bodySmall']),
      labelLarge: parseTextStyle(theme['labelLarge']),
      labelMedium: parseTextStyle(theme['labelMedium']),
      labelSmall: parseTextStyle(theme['labelSmall']),
    );
  }

  static IconThemeData? _parseIconThemeData(Map<String, dynamic>? theme) {
    if (theme == null) return null;
    
    return IconThemeData(
      color: parseColor(theme['color']),
      size: toDouble(theme['size']),
      opacity: toDouble(theme['opacity']),
    );
  }

  // === IMAGE FILTER PARSING ===
  
  static ImageFilter parseImageFilter(Map<String, dynamic>? filter) {
    if (filter == null) return ImageFilter.blur(sigmaX: 0, sigmaY: 0);
    
    final type = filter['type'] as String?;
    
    switch (type) {
      case 'blur':
        return ImageFilter.blur(
          sigmaX: toDouble(filter['sigmaX']) ?? 0,
          sigmaY: toDouble(filter['sigmaY']) ?? 0,
        );
      default:
        return ImageFilter.blur(sigmaX: 0, sigmaY: 0);
    }
  }
}