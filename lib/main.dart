// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // ✅ NEW: Localization delegates
import 'services/dependency_injection.dart' as di;
import 'presentation/pages/main_screen.dart';
import 'presentation/providers/home_provider.dart'; 
import 'presentation/providers/theme_provider.dart'; 
import 'package:get_it/get_it.dart'; 
import 'l10n/app_localizations.dart'; // ✅ NEW: Generated localization file


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init(); // Initialize GetIt dependencies
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GetIt sl = di.sl;
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<HomeProvider>()),
        ChangeNotifierProvider(create: (_) => sl<ThemeProvider>()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'News App',
            
            // 💡 LIGHT THEME (Default)
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blueGrey,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              scaffoldBackgroundColor: Colors.white,
            ),
            
            // ✅ DARK THEME
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.blueGrey,
              scaffoldBackgroundColor: Colors.black, // Deep black background
              cardColor: Colors.grey[900], // Dark card color
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.grey[900],
                foregroundColor: Colors.white,
              ),
            ),
            
            // ✅ Theme Control
            themeMode: themeProvider.themeMode,
            
            // ✅ LOCALIZATION SETUP
            supportedLocales: ThemeProvider.allLocales, // Uses the list from ThemeProvider
            locale: themeProvider.appLocale, // Uses the user's current selection
            localizationsDelegates: const [
              AppLocalizations.delegate, // Your generated delegate
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}