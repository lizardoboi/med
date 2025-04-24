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
  bool _isHintsEnabled = false;
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

    // Возвращаем тему с учётом режима подсказок
    return AppTheme.getThemeWithHintsEnabled(base, _isHintsEnabled).copyWith(
      // Модифицируем размеры шрифта и кнопок при необходимости
      textTheme: base.textTheme.copyWith(
        titleLarge: base.textTheme.titleLarge?.copyWith(fontSize: _isLargeText ? 24 : 20),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(fontSize: _isLargeText ? 18 : 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: base.elevatedButtonTheme.style?.copyWith(
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: _isLargeText ? 28 : 24, vertical: _isLargeText ? 16 : 12),
          ),
          textStyle: MaterialStateProperty.all(
            TextStyle(fontSize: _isLargeText ? 18 : 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
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
