import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ✅ Import localization (Adjust path as needed)
import '../../../l10n/app_localizations.dart'; 

import '../../providers/home_provider.dart';
import '../../widgets/article_card.dart';
import '../article_detail/article_detail_page.dart'; // For navigation

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Start fetching data immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).fetchTopHeadlines();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the localization instance
    final s = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        // ✅ LOCALIZED TITLE
        title: Text(s.topHeadlines),
        backgroundColor: Colors.blueGrey,
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            // Pull-to-refresh for error state
            return RefreshIndicator(
              onRefresh: provider.fetchTopHeadlines,
              child: Center(
                child: Text('Error: ${provider.errorMessage}'),
              ),
            );
          }
          if (provider.articles.isEmpty) {
            return const Center(child: Text('No articles found.'));
          }

          // RefreshIndicator for the main list view
          return RefreshIndicator(
            onRefresh: provider.fetchTopHeadlines,
            child: ListView.builder(
              itemCount: provider.articles.length,
              itemBuilder: (context, index) {
                final article = provider.articles[index];
                
                // >>> NAVIGATION IMPLEMENTATION <<<
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ArticleDetailPage(article: article);
                        },
                      ),
                    );
                  },
                  // Reusable ArticleCard widget
                  child: ArticleCard(article: article),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
