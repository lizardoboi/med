import 'package:flutter/material.dart';
import 'app_theme.dart';

enum AppThemeMode {
  light,
  dark,
  highContrast,
}

class ThemeProvider with ChangeNotifier {
  AppThemeMode _themeMode = AppThemeMode.light;
  bool _isLargeText = false;
  bool _isHintsEnabled = true;
  Locale _locale = const Locale('ru'); // по умолчанию русский

  AppThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == AppThemeMode.dark;
  bool get isHighContrast => _themeMode == AppThemeMode.highContrast;

  bool get isLargeText => _isLargeText;
  bool get isHintsEnabled => _isHintsEnabled;
  Locale get locale => _locale;

  ThemeData get currentTheme {
    ThemeData base;
    switch (_themeMode) {
      case AppThemeMode.dark:
        base = AppTheme.darkTheme;
        break;
      case AppThemeMode.highContrast:
        base = AppTheme.highContrastTheme;
        break;
      case AppThemeMode.light:
      default:
        base = AppTheme.lightTheme;
    }

    // Модифицируем размеры шрифта и кнопок при необходимости
    if (_isLargeText) {
      return base.copyWith(
        textTheme: base.textTheme.copyWith(
          titleLarge: base.textTheme.titleLarge?.copyWith(fontSize: 24),
          bodyMedium: base.textTheme.bodyMedium?.copyWith(fontSize: 18),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: base.elevatedButtonTheme.style?.copyWith(
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            ),
            textStyle: MaterialStateProperty.all(
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    return base;
  }

  void setThemeMode(AppThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setLargeText(bool value) {
    _isLargeText = value;
    notifyListeners();
  }

  void setHintsEnabled(bool value) {
    _isHintsEnabled = value;
    notifyListeners();
  }

  void setLocale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }
}
