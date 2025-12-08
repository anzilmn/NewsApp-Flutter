import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ✅ NEW: Import localization (Adjust path as needed, assuming two directories up)
import '../../../l10n/app_localizations.dart'; 

import '../../providers/category_provider.dart';
import '../../widgets/article_card.dart'; // Reusable ArticleCard
import '../../widgets/error_state.dart'; // Reusable ErrorState widget
import '../../widgets/loading_state.dart'; // Reusable LoadingState widget

// List of categories supported by News API (These are API values, should not be changed)
const List<String> newsCategories = [
  'business',
  'entertainment',
  'general',
  'health',
  'science',
  'sports',
  'technology',
];

class CategoryNewsPage extends StatefulWidget {
  const CategoryNewsPage({super.key});

  @override
  State<CategoryNewsPage> createState() => _CategoryNewsPageState();
}

class _CategoryNewsPageState extends State<CategoryNewsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch news for the default category when the page is first initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false)
          .fetchNewsByCategory();
    });
  }

  // ⬅️ NEW HELPER: Maps the API category key to the localized display name.
  String _getLocalizedCategoryName(String categoryKey, AppLocalizations s) {
    switch (categoryKey) {
      case 'business':
        return s.categoryBusiness;
      case 'entertainment':
        return s.categoryEntertainment;
      case 'general':
        return s.categoryGeneral;
      case 'health':
        return s.categoryHealth;
      case 'science':
        return s.categoryScience;
      case 'sports':
        return s.categorySports;
      case 'technology':
        return s.categoryTechnology;
      default:
        return categoryKey.toUpperCase(); // Fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Get the localization instance 's'
    final s = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        // ✅ LOCALIZED TITLE
        title: Text(s.newsByCategory),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Consumer<CategoryProvider>(
            builder: (context, provider, child) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: DropdownButton<String>(
                  value: provider.selectedCategory,
                  isExpanded: true,
                  items: newsCategories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      // ✅ FIX: Use the new helper function to display localized category name
                      child: Text(_getLocalizedCategoryName(category, s)),
                    );
                  }).toList(),
                  onChanged: (String? newCategory) {
                    if (newCategory != null) {
                      provider.setCategory(newCategory);
                    }
                  },
                ),
              );
            },
          ),
        ),
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoadingState();
          }

          if (provider.errorMessage.isNotEmpty) {
            return ErrorState(message: provider.errorMessage);
          }

          if (provider.articles.isEmpty) {
            // ⬅️ OPTIONAL FIX: Localize the "No articles found" message
            // Requires a new key like 'noArticlesFoundMessage' in your ARB files.
            return Center(
              // child: Text(s.noArticlesFoundMessage), 
              child: const Text("No articles found for this category."),
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
