import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart'; 

// CORRECT IMPORTS FROM lib/presentation/pages/
import '../providers/category_provider.dart'; 
import '../providers/country_provider.dart'; 

// ✅ NEW: Import localization and service locator access
import '../../l10n/app_localizations.dart'; 
import '../../../services/dependency_injection.dart'; 

import 'home/home_page.dart';
import 'settings/settings_page.dart'; 
import 'category_news/category_news_page.dart';
import 'country_news/country_news_page.dart';

final sl = GetIt.instance; 

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // The list of pages corresponding to the navigation bar items
  // Note: These pages are created only once (in initState, but here for clarity)
  // and maintain their state across tab switches.
  final List<Widget> _pages = <Widget>[
    const HomePage(), // 0: Hot News (Uses HomeProvider injected in main.dart)

    // 1: CATEGORIES - Inject CategoryProvider locally
    ChangeNotifierProvider(
      create: (_) => sl<CategoryProvider>(), 
      child: const CategoryNewsPage(),
    ), 

    // 2: COUNTRIES - Inject CountryProvider locally
    ChangeNotifierProvider(
      create: (_) => sl<CountryProvider>(), 
      child: const CountryNewsPage(),
    ), 
    
    const SettingsPage(), // 3: Settings
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ FIX: Access AppLocalizations instance with null check
    final s = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: _pages.elementAt(_selectedIndex), // Display the selected page
      
      // ✅ FIX: Use localized strings for BottomNavigationBar labels
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          // 0: Home (Using a general headline/hot news title)
          BottomNavigationBarItem(
            icon: const Icon(Icons.flash_on), 
            label: s.topHeadlines, // Localized
          ),
          
          // 1: Category
          BottomNavigationBarItem(
            icon: const Icon(Icons.category), 
            label: s.newsByCategory, // Localized
          ),
          
          // 2: Country
          BottomNavigationBarItem(
            icon: const Icon(Icons.public), 
            label: s.newsByCountry, // Localized
          ),
          
          // 3: Settings
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings), 
            label: s.selectLanguage, // Using Select Language label as a general "Settings" label
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor, // Use theme color
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed, // Ensure all 4 items are visible
        onTap: _onItemTapped,
      ),
    );
  }
}