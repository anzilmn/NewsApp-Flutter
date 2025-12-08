import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; 
import '../../../l10n/app_localizations.dart'; 

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Helper for the "About App" dialog - updated to use AppLocalizations
  void _showAboutDialog(BuildContext context, AppLocalizations s) {
    showAboutDialog(
      context: context,
      applicationName: 'News App',
      applicationVersion: '1.0.0',
      children: [
        const Text('A simple news application built with Flutter and Clean Architecture.'),
      ]
    );
  }

  // Language Selection Dialog
  void _showLanguageDialog(BuildContext context, ThemeProvider provider) {
    // Add the null-check operator (!) here
    final s = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          // This title will be "Select Language" (s.selectLanguage)
          title: Text(s.selectLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ThemeProvider.allLocales.map((locale) {
              
              String languageName;
              switch (locale.languageCode) {
                case 'en':
                  languageName = 'English';
                  break;
                case 'hi':
                  languageName = 'हिंदी (Hindi)';
                  break;
                case 'ml':
                  languageName = 'മലയാളം (Malayalam)';
                  break;
                case 'ta':
                  languageName = 'தமிழ் (Tamil)';
                  break;
                case 'te':
                  languageName = 'తెలుగు (Telugu)';  
                  break;
                default:
                  languageName = locale.languageCode;
              }

              return ListTile(
                title: Text(languageName),
                trailing: provider.appLocale?.languageCode == locale.languageCode 
                    ? const Icon(Icons.check, color: Colors.blue) 
                    : null,
                onTap: () {
                  provider.setLocale(locale);
                  Navigator.of(dialogContext).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // Add the null-check operator (!) here
    final s = AppLocalizations.of(context)!; 

    return Scaffold(
      appBar: AppBar(
        // ✅ UPDATED: Changed AppBar title to use the generic 'language' key
        title: Text(s.selectLanguage), 
      ),
      body: ListView(
        children: [
          // --------------------
          // 🌐 Select Language
          // --------------------
          ListTile(
            leading: const Icon(Icons.language),
            // ✅ CRITICAL FIX: Changed from s.selectLanguage to s.language
            title: Text(s.language), 
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(context, themeProvider), 
          ),
          const Divider(),
          
          // --------------------
          // 🌙 Dark Mode Switch
          // --------------------
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: Text(s.darkMode), 
            trailing: Switch(
              value: themeProvider.isDarkMode, 
              onChanged: themeProvider.toggleTheme,
            ),
          ),
          const Divider(),
          
          // --------------------
          // ℹ️ About App
          // --------------------
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(s.aboutApp), 
            onTap: () => _showAboutDialog(context, s),
          ),
        ],
      ),
    );
  }
}
