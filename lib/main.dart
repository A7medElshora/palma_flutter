import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:p_p/Start.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/Splash_Scr.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, notifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Palma',
            theme: notifier.getLightTheme(),
            darkTheme: notifier.getDarkTheme(),
            themeMode: notifier.themeMode,
            locale: _locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('ar', ''),
      ],
            initialRoute: '/',
            routes: {
              '/': (context) => SplashScreen(), // Define the splash screen route
              '/home': (context) => StartPage(), // Define your home screen route
              
            },
          );
        },
      ),
    );
  }
}

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  ThemeData getLightTheme() {
    return ThemeData.light();
  }

  ThemeData getDarkTheme() {
    return ThemeData.dark();
  }
  // // Function to save dark mode preference
  // Future<void> _saveDarkModePreference(bool isDarkMode) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('isDarkMode', isDarkMode);
  // }
}