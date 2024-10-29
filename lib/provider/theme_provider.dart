// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeProvider, bool?>((ref) {
  return ThemeProvider();
});

final themeProviderNotifier = ChangeNotifierProvider<ThemeProviderNotifier>((ref) {
  return ThemeProviderNotifier();
});

extension DarkMode on BuildContext {
  bool get isDarkMode {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.light;
  }
}


class ThemeProviderNotifier extends ChangeNotifier {
  bool? _themeMode;
  bool? get themeMode => _themeMode;
  set themeMode(bool? mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void saveThemeState(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    final String theme;
    if (_themeMode == null) {
      _themeMode = context.isDarkMode;
      theme = json.encode({"theme": _themeMode});
      await pref.setString("theme", theme);
      return;
    } else {
      theme = json.encode({"theme": _themeMode});
      await pref.setString("theme", theme);
      return;
    }
  }

  Future<bool?> onAppLaunch(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("theme")) {
      saveThemeState(context);
      return null;
    }

    final dataExtracted =
        json.decode(prefs.getString("theme")!) as Map<String, dynamic>;
    final deviceState = dataExtracted["theme"];

    if (deviceState == null) {
      saveThemeState(context);
      return null;
    }

    _themeMode = deviceState;

    return _themeMode;
  }

  bool changeMode(context, bool mode) {
    _themeMode = mode;
    saveThemeState(context);
    return _themeMode!;
  }
  
}



class ThemeProvider extends StateNotifier<bool?> {
  ThemeProvider() : super(false) ;

  void saveThemeState(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    final String theme;
    if (state == null) {
      state = context.isDarkMode;
      theme = json.encode({"theme": state});
      await pref.setString("theme", theme);
      return;
    } else {
      theme = json.encode({"theme": state});
      await pref.setString("theme", theme);
      return;
    }
  }

  Future<bool?> onAppLaunch(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("theme")) {
      saveThemeState(context);
      return null;
    }

    final dataExtracted =
        json.decode(prefs.getString("theme")!) as Map<String, dynamic>;
    final deviceState = dataExtracted["theme"];

    if (deviceState == null) {

      saveThemeState(context);
      return null;
    }

    state = deviceState;

    return state;
  }

  bool changeMode(context, bool mode) {
    state = mode;
    saveThemeState(context);
    return state!;
  }
}
