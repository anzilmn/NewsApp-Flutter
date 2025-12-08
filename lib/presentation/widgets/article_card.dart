import 'package:flutter/material.dart';
import '../../domain/entities/article.dart';
// 🛑 IMPORTANT: You must import the detail page here for navigation to work!
import '../pages/article_detail/article_detail_page.dart'; 

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    // ✅ WRAP the Card in an InkWell to make it tappable
    return InkWell(
      onTap: () {
        // Navigate to the detail page when tapped
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ArticleDetailPage(article: article),
          ),
        );
      },
      child: Card(
        elevation: 2.0, // Added slight elevation for better visual
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image (if available)
              if (article.urlToImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    article.urlToImage!,
                    height: 180, 
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 180,
                        color: Colors.grey[300],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(), // Hides if image fails
                  ),
                ),
              const SizedBox(height: 10),

              // Source and Date
              Text(
                '${article.sourceName ?? 'Unknown Source'} | ${article.publishedAt?.substring(0, 10) ?? ''}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blueGrey, 
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              
              // Title
              Text(
                article.title ?? 'No Title Available',
                style: const TextStyle(
                    fontSize: 19, fontWeight: FontWeight.bold),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}