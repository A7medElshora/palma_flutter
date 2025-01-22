import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:p_p/Start.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/Splash_Scr.dart';
import 'localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    _saveLocale(locale.languageCode);
  }

  Future<void> _loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('languageCode');
    if (languageCode != null) {
      setState(() {
        _locale = Locale(languageCode);
      });
    }
  }

  Future<void> _saveLocale(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, notifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Fentie',
            theme: notifier.getLightTheme(),
            darkTheme: notifier.getDarkTheme(),
            themeMode: notifier.themeMode,
            locale: _locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('ar', ''),
            ],
            initialRoute: '/',
            routes: {
              '/': (context) => SplashScreen(),
              '/home': (context) => StartPage(),
            },
          );
        },
      ),
    );
  }
}

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeNotifier() {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isDarkMode = prefs.getBool('isDarkMode');
    if (isDarkMode != null) {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    }
  }

  ThemeData getLightTheme() {
    return ThemeData.light().copyWith(
      colorScheme: const ColorScheme.light(
        primary: Colors.green,
        surface: Colors.white,
        onSurface: Colors.black,
      ),
      scaffoldBackgroundColor: Colors.white,
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData.dark().copyWith(
      colorScheme: const ColorScheme.dark(
        primary: Colors.teal,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.black,
    );
  }
}
