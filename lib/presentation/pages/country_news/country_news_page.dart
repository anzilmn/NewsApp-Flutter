import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ✅ NEW: Import localization (Adjust path as needed, assuming two directories up)
import '../../../l10n/app_localizations.dart'; 

import '../../providers/country_provider.dart';
import '../../widgets/article_card.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_state.dart';

// Keys are the full country NAME (used for API search and as the localization key)
// We only store the API key here; the display value comes from localization.
const List<String> apiCountryNames = [
  'United States',
  'India',
  'United Kingdom',
  'Canada',
  'Australia',
  'Germany',
  'France',
  'Japan',
  'Brazil',
  'Russia',
  'China',
  'South Korea',
];

class CountryNewsPage extends StatefulWidget {
  const CountryNewsPage({super.key});

  @override
  State<CountryNewsPage> createState() => _CountryNewsPageState();
}

class _CountryNewsPageState extends State<CountryNewsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch news for the default country when the page is first initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CountryProvider>(context, listen: false)
          .fetchNewsByCountry();
    });
  }

  // ⬅️ NEW HELPER: Maps the API country name (which will be your ARB key) to the localized display name.
  String _getLocalizedCountryName(String countryKey, AppLocalizations s) {
    switch (countryKey) {
      case 'United States':
        return s.countryUnitedStates;
      case 'India':
        return s.countryIndia;
      case 'United Kingdom':
        return s.countryUnitedKingdom;
      case 'Canada':
        return s.countryCanada;
      case 'Australia':
        return s.countryAustralia;
      case 'Germany':
        return s.countryGermany;
      case 'France':
        return s.countryFrance;
      case 'Japan':
        return s.countryJapan;
      case 'Brazil':
        return s.countryBrazil;
      case 'Russia':
        return s.countryRussia;
      case 'China':
        return s.countryChina;
      case 'South Korea':
        return s.countrySouthKorea;
      default:
        return countryKey; // Fallback to the English name
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Get the localization instance 's'
    final s = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        // ✅ LOCALIZED TITLE
        title: Text(s.newsByCountry),
        
        // Dropdown for selecting countries
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Consumer<CountryProvider>(
            builder: (context, provider, child) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: DropdownButton<String>(
                  value: provider.selectedCountryName,
                  isExpanded: true,
                  // We iterate over the API list, not the old map
                  items: apiCountryNames 
                      .map(
                        (countryKey) => DropdownMenuItem<String>(
                          value: countryKey, // API value (e.g., 'United States')
                          // ✅ FIX: Use the localized name for display
                          child: Text(_getLocalizedCountryName(countryKey, s)), 
                        ),
                      )
                      .toList(),
                  onChanged: (String? newCountryName) {
                    if (newCountryName != null) {
                      provider.setCountry(newCountryName);
                    }
                  },
                ),
              );
            },
          ),
        ),
      ),
      body: Consumer<CountryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoadingState();
          }

          if (provider.errorMessage.isNotEmpty) {
            return ErrorState(message: provider.errorMessage);
          }

          if (provider.articles.isEmpty) {
            return const Center(
              // NOTE: This message should also be localized (e.g., s.noArticlesFound)
              child: Text("No articles found for this country."), 
            );
          }

          return ListView.builder(
            itemCount: provider.articles.length,
            itemBuilder: (context, index) {
              final article = provider.articles[index];
              return ArticleCard(article: article);
            },
          );
        },
      ),
    );
  }
}
