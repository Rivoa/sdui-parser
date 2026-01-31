# SDUI Builder - Quick Reference

## Common Patterns

### Simple Screen
```dart
SScaffold(
  appBar: SAppBar(title: SText('Title')),
  body: SColumn(children: [...]),
)
```

### Card List
```dart
SListView(
  padding: {'all': 16.0},
  children: items.map((item) => 
    SCard(
      margin: {'bottom': 16.0},
      child: SListTile(
        title: SText(item.title),
        onTap: 'select(${item.id})',
      ),
    ),
  ).toList(),
)
```

### Form
```dart
SColumn(
  children: [
    STextField(
      controllerId: 'name',
      labelText: 'Name',
    ),
    STextField(
      controllerId: 'email',
      labelText: 'Email',
      keyboardType: 'email',
    ),
    SElevatedButton(
      onPressed: 'submit()',
      child: SText('Submit'),
    ),
  ],
)
```

## Widget Categories

### Structure
- `SScaffold` - Main app structure
- `SAppBar` - Top app bar
- `SSafeArea` - Safe area insets
- `SMaterialApp` - Material app root

### Layout
- `SColumn` - Vertical layout
- `SRow` - Horizontal layout
- `SStack` - Layered layout
- `SContainer` - Box model
- `SSizedBox` - Fixed size
- `SPadding` - Padding wrapper
- `SCenter` - Center alignment
- `SAlign` - Custom alignment
- `SExpanded` - Fill space
- `SWrap` - Wrapping layout
- `SSpacer` - Flexible space
- `SDivider` - Horizontal line
- `SPositioned` - Absolute position in Stack

### Scrolling
- `SSingleChildScrollView` - Single scrollable child
- `SListView` - Scrollable list
- `SListViewBuilder` - Dynamic list
- `SGridView` - Grid layout
- `SGridViewBuilder` - Dynamic grid
- `SPageView` - Swipeable pages
- `SRefreshIndicator` - Pull to refresh

### Content
- `SText` - Text display
- `SRichText` - Styled text
- `SIcon` - Icon display
- `SImageNetwork` - Network image
- `SImageAsset` - Asset image
- `SCircularProgressIndicator` - Circular loading
- `SLinearProgressIndicator` - Linear loading
- `SPlaceholder` - Placeholder box

### Material
- `SCard` - Material card
- `SListTile` - List item
- `SChip` - Compact label
- `SBadge` - Notification badge
- `STooltip` - Hover tooltip

### Buttons
- `SElevatedButton` - Filled button
- `STextButton` - Text button
- `SOutlinedButton` - Outlined button
- `SIconButton` - Icon button
- `SFloatingActionButton` - FAB

### Forms
- `STextField` - Text input
- `SCheckbox` - Checkbox
- `SSwitch` - Toggle switch
- `SRadio` - Radio button
- `SSlider` - Value slider
- `SDropdown` - Dropdown select
- `SDatePicker` - Date picker
- `STimePicker` - Time picker

### Gestures
- `SGestureDetector` - Gesture detection
- `SInkWell` - Material ripple
- `SDismissible` - Swipe to dismiss

### Navigation
- `SBottomNavigationBar` - Bottom nav
- `SDrawer` - Side drawer
- `STabBar` - Tab bar
- `STabBarView` - Tab content

### Dialogs
- `SAlertDialog` - Alert dialog
- `SBottomSheet` - Bottom sheet
- `SSnackBar` - Snack bar

### Decorative
- `SOpacity` - Transparency
- `STransform` - Transformations
- `SClipRect` - Rectangle clip
- `SClipRRect` - Rounded clip
- `SClipOval` - Oval clip
- `SBackdropFilter` - Blur filter

### Conditional
- `SConditional` - If/else rendering
- `SVisibility` - Show/hide
- `SStatefulBuilder` - Local state

### Cupertino
- `SCupertinoButton` - iOS button
- `SCupertinoSwitch` - iOS switch
- `SCupertinoSlider` - iOS slider

## Property Quick Reference

### Colors
```dart
color: '#RRGGBB'         // RGB
color: '#AARRGGBB'       // ARGB with alpha
```

### Padding/Margin
```dart
{'all': 16.0}
{'horizontal': 16.0, 'vertical': 8.0}
{'left': 8.0, 'top': 4.0, 'right': 8.0, 'bottom': 4.0}
[8.0, 4.0, 8.0, 4.0]  // LTRB array
```

### Alignment
Values: `topLeft`, `topCenter`, `topRight`, `centerLeft`, `center`, `centerRight`, `bottomLeft`, `bottomCenter`, `bottomRight`

### MainAxisAlignment
Values: `start`, `end`, `center`, `spaceBetween`, `spaceAround`, `spaceEvenly`

### CrossAxisAlignment
Values: `start`, `end`, `center`, `stretch`, `baseline`

### BoxFit
Values: `fill`, `contain`, `cover`, `fitWidth`, `fitHeight`, `none`, `scaleDown`

### Text Style
```dart
{
  'fontSize': 16.0,
  'fontWeight': 'bold',  // normal, bold, w100-w900
  'fontStyle': 'italic',  // normal, italic
  'color': '#212121',
  'letterSpacing': 1.2,
  'height': 1.5,
  'decoration': 'underline',  // none, underline, overline, lineThrough
}
```

### Gradient
```dart
{
  'type': 'linear',  // or 'radial', 'sweep'
  'colors': ['#2196F3', '#1976D2'],
  'begin': 'topLeft',
  'end': 'bottomRight',
  'stops': [0.0, 1.0],
}
```

### Box Shadow
```dart
[
  {
    'color': '#00000033',
    'offset': {'dx': 0, 'dy': 2},
    'blurRadius': 4.0,
    'spreadRadius': 0.0,
  }
]
```

## Data Binding

### Variable Binding
```dart
'{{variableName}}'
'{{object.property}}'
'{{array[0].property}}'
```

### In List Builders
```dart
'{{item}}'              // Current item
'{{index}}'             // Current index
'{{item.property}}'     // Item property
```

## Action Handling

### Simple Actions
```dart
onPressed: 'functionName()'
```

### With Arguments
```dart
onPressed: 'functionName(arg1, arg2)'
onPressed: 'functionName(key: value, key2: value2)'
```

### With Bound Data
```dart
onPressed: 'selectItem({{item.id}})'
onPressed: 'updateUser(id: {{user.id}}, name: "{{user.name}}")'
```

## Common Icons

### Navigation
`home`, `menu`, `arrow_back`, `arrow_forward`, `close`, `more_vert`, `more_horiz`

### Actions
`add`, `remove`, `edit`, `delete`, `save`, `refresh`, `search`, `filter_list`

### Status
`check`, `check_circle`, `cancel`, `error`, `warning`, `info`, `help`

### Content
`favorite`, `star`, `thumb_up`, `thumb_down`, `share`, `comment`

### User
`person`, `account_circle`, `group`, `email`, `phone`, `location_on`

### Shopping
`shopping_cart`, `payment`, `local_shipping`, `inventory`

### Media
`play_arrow`, `pause`, `stop`, `skip_next`, `skip_previous`, `volume_up`

### File
`folder`, `insert_drive_file`, `attach_file`, `cloud_upload`, `cloud_download`

## Keyboard Types

- `text` - Default text
- `multiline` - Multiline text
- `number` - Numeric
- `phone` - Phone number
- `email` - Email address
- `url` - URL
- `datetime` - Date and time

## Text Input Actions

- `done` - Done button
- `next` - Next field
- `search` - Search button
- `send` - Send button
- `go` - Go button

## Scroll Physics

- `bouncingScrollPhysics` - iOS bouncing
- `clampingScrollPhysics` - Android clamping
- `neverScrollableScrollPhysics` - Disable scroll

## Material Colors

### Primary Colors
```dart
'#F44336'  // Red
'#E91E63'  // Pink
'#9C27B0'  // Purple
'#673AB7'  // Deep Purple
'#3F51B5'  // Indigo
'#2196F3'  // Blue
'#03A9F4'  // Light Blue
'#00BCD4'  // Cyan
'#009688'  // Teal
'#4CAF50'  // Green
'#8BC34A'  // Light Green
'#CDDC39'  // Lime
'#FFEB3B'  // Yellow
'#FFC107'  // Amber
'#FF9800'  // Orange
'#FF5722'  // Deep Orange
'#795548'  // Brown
'#9E9E9E'  // Gray
'#607D8B'  // Blue Gray
```

### Common Grays
```dart
'#FFFFFF'  // White
'#FAFAFA'  // Gray 50
'#F5F5F5'  // Gray 100
'#EEEEEE'  // Gray 200
'#E0E0E0'  // Gray 300
'#BDBDBD'  // Gray 400
'#9E9E9E'  // Gray 500
'#757575'  // Gray 600
'#616161'  // Gray 700
'#424242'  // Gray 800
'#212121'  // Gray 900
'#000000'  // Black
```

## Common Patterns Cheat Sheet

### Button Row
```dart
SRow(
  mainAxisAlignment: 'spaceEvenly',
  children: [
    SElevatedButton(
      onPressed: 'cancel()',
      child: SText('Cancel'),
    ),
    SElevatedButton(
      onPressed: 'submit()',
      child: SText('Submit'),
    ),
  ],
)
```

### Loading State
```dart
SConditional(
  condition: 'isLoading',
  then: SCenter(child: SCircularProgressIndicator()),
  otherwise: SListView(children: [...]),
)
```

### Empty State
```dart
SConditional(
  condition: {
    'op': 'greaterThan',
    'left': 'items.length',
    'right': 0,
  },
  then: SListView(children: [...]),
  otherwise: SCenter(
    child: SColumn(
      children: [
        SIcon('inbox', size: 64, color: '#9E9E9E'),
        SText('No items found'),
      ],
    ),
  ),
)
```

### Image Card
```dart
SCard(
  clipBehavior: 'antiAlias',
  child: SColumn(
    children: [
      SImageNetwork(
        url: 'image.jpg',
        height: 200,
        fit: 'cover',
      ),
      SPadding(
        padding: {'all': 16.0},
        child: SText('Title'),
      ),
    ],
  ),
)
```

### Avatar with Badge
```dart
SBadge(
  label: SText('5'),
  backgroundColor: '#F44336',
  child: SContainer(
    width: 50,
    height: 50,
    shape: 'circle',
    child: SClipOval(
      child: SImageNetwork(url: 'avatar.jpg'),
    ),
  ),
)
```

### Expandable List Item
```dart
SExpansionTile(
  title: SText('Section'),
  children: [
    SListTile(title: SText('Item 1')),
    SListTile(title: SText('Item 2')),
  ],
)
```

### Floating Label Input
```dart
STextField(
  labelText: 'Email',
  filled: true,
  fillColor: '#F5F5F5',
  border: 'outline',
  prefixIcon: SIcon('email'),
)
```

### Icon + Text Button
```dart
SElevatedButton(
  onPressed: 'action()',
  child: SRow(
    mainAxisSize: 'min',
    children: [
      SIcon('add', size: 20),
      SSizedBox(width: 8),
      SText('Add Item'),
    ],
  ),
)
```

## Tips

1. **Always use `.toJsonString(pretty: true)` for debugging**
2. **Use constants for repeated values (colors, spacing)**
3. **Prefer SListViewBuilder over SListView for dynamic data**
4. **Use stateKey for form inputs that need to persist**
5. **Validate your JSON structure before sending to parser**
6. **Use semantic labels for accessibility**
7. **Keep action names descriptive and consistent**
8. **Use SConditional for loading/error states**
9. **Wrap images in SClipRRect for rounded corners**
10. **Use SSizedBox for consistent spacing**