import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

/// 配色主题
List<AppTheme> themes = [
  _m3AppTheme('阳光橙', orangeLightColorScheme),
  _m3AppTheme('活力蓝', blueLightColorScheme),
  _m3AppTheme('南大紫', njuLightColorScheme),
  _m3AppTheme('荧光绿', greenNightColorScheme),
  _m3AppTheme('南大紫(深色)', njuDarkColorScheme),
];

const njuLightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF7A067B),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFF9A3F9B),
  onPrimaryContainer: Color(0xFF400100),
  secondary: Color(0xFFE6C390),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFF9A3F9B),
  onSecondaryContainer: Color(0xFF2C1511),
  tertiary: Color(0xFFAF2F1F),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFFDAD4),
  onTertiaryContainer: Color(0xFF400100),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFBFBFB),
  onBackground: Color(0xFF201A19),
  surface: Color(0xFFFBFBFB),
  onSurface: Color(0xFF201A19),
  surfaceVariant: Color(0xFFFFFFFF),
  onSurfaceVariant: Color(0xFF534341),
  outline: Color(0xFF857370),
  onInverseSurface: Color(0xFFFBEEEB),
  inverseSurface: Color(0xFF362F2D),
  inversePrimary: Color(0xFFFFB4A7),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFFFFFFF),
  outlineVariant: Color(0xFFD8C2BE),
  scrim: Color(0xFF000000),
);

const orangeLightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFFB6650),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFFB6650),
  onPrimaryContainer: Color(0xFF400100),
  secondary: Color(0xFFFFD800),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFFB6650),
  onSecondaryContainer: Color(0xFF2C1511),
  tertiary: Color(0xFFAF2F1F),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFFDAD4),
  onTertiaryContainer: Color(0xFF400100),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFBFBFB),
  onBackground: Color(0xFF201A19),
  surface: Color(0xFFFBFBFB),
  onSurface: Color(0xFF201A19),
  surfaceVariant: Color(0xFFFFFFFF),
  onSurfaceVariant: Color(0xFF534341),
  outline: Color(0xFF857370),
  onInverseSurface: Color(0xFFFBEEEB),
  inverseSurface: Color(0xFF362F2D),
  inversePrimary: Color(0xFFFFB4A7),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFFFFFFF),
  outlineVariant: Color(0xFFD8C2BE),
  scrim: Color(0xFF000000),
);

const blueLightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF3370FF),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFF3370FF),
  onPrimaryContainer: Color(0xFF400100),
  secondary: Color(0xFF00D6B9),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFF3370FF),
  onSecondaryContainer: Color(0xFF2C1511),
  tertiary: Color(0xFFAF2F1F),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFFDAD4),
  onTertiaryContainer: Color(0xFF400100),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFBFBFB),
  onBackground: Color(0xFF201A19),
  surface: Color(0xFFFBFBFB),
  onSurface: Color(0xFF201A19),
  surfaceVariant: Color(0xFFFFFFFF),
  onSurfaceVariant: Color(0xFF534341),
  outline: Color(0xFF857370),
  onInverseSurface: Color(0xFFFBEEEB),
  inverseSurface: Color(0xFF362F2D),
  inversePrimary: Color(0xFFFFB4A7),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFFFFFFF),
  outlineVariant: Color(0xFFD8C2BE),
  scrim: Color(0xFF000000),
);

const njuDarkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF7A067B),
  onPrimary: Color(0xFF201A19),
  primaryContainer: Color(0xFF9A3F9B),
  onPrimaryContainer: Color(0xFFE0E0E0),
  secondary: Color(0xFFE6C390),
  onSecondary: Color(0xFF201A19),
  secondaryContainer: Color(0xFF9A3F9B),
  onSecondaryContainer: Color(0xFFFFDAD4),
  tertiary: Color(0xFFFFB4A7),
  onTertiary: Color(0xFF680300),
  tertiaryContainer: Color(0xFF8D160A),
  onTertiaryContainer: Color(0xFFFFDAD4),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF181818),
  onBackground: Color(0xFFE0E0E0),
  surface: Color(0xFF181818),
  onSurface: Color(0xFFE0E0E0),
  surfaceVariant: Color(0xFF303030),
  onSurfaceVariant: Color(0xFFD8C2BE),
  outline: Color(0xFFA08C89),
  onInverseSurface: Color(0xFF201A19),
  inverseSurface: Color(0xFFEDE0DD),
  inversePrimary: Color(0xFFAF2F1F),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0x00000000),
  outlineVariant: Color(0xFF534341),
  scrim: Color(0xFF000000),
);

const greenNightColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF8261E5),
  onPrimary: Color(0xFFE4E0EE),
  primaryContainer: Color(0xFF49F552),
  onPrimaryContainer: Color(0xFFA8F58E),
  secondary: Color(0xFF646262),
  onSecondary: Color(0xFF20C73C),
  secondaryContainer: Color(0xFF8261E5),
  onSecondaryContainer: Color(0xFF8261E5),
  tertiary: Color(0xFF61E573),
  onTertiary: Color(0xFFF3F1F8),
  tertiaryContainer: Color(0xFFCFF58E),
  onTertiaryContainer: Color(0xFF8DF581),
  error: Color(0xFF8B6AEE),
  errorContainer: Color(0xFF9E81F5),
  onError: Color(0xFF8261E5),
  onErrorContainer: Color(0xFF744FE1),
  background: Color(0xFF201A19),
  onBackground: Color(0xFFEDE0DD),
  surface: Color(0xFF201A19),
  onSurface: Color(0xFF6FD97C),
  surfaceVariant: Color(0xFF494848),
  onSurfaceVariant: Color(0xFFC7FFA7),
  outline: Color(0xFFA08C89),
  onInverseSurface: Color(0xFF201A19),
  inverseSurface: Color(0xFFC7FFA7),
  inversePrimary: Color(0xFF9E81F5),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFC7FFA7),
  outlineVariant: Color(0xFF9E81F5),
  scrim: Color(0xFF000000),
);

/// 封装色彩主题
AppTheme _m3AppTheme(String title, ColorScheme colorScheme) {
  return AppTheme(
    id: title,
    description: title,
    data: ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
    ),
  );
}