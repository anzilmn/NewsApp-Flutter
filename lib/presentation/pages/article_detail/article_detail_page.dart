import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // <<< Import the launcher
import '../../../domain/entities/article.dart';

class ArticleDetailPage extends StatelessWidget {
  final Article article;

  const ArticleDetailPage({super.key, required this.article});

  // Function to safely launch the URL
  Future<void> _launchUrl() async {
    final url = Uri.parse(article.url!);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // Show an error if the URL can't be opened
      throw 'Could not launch ${article.url}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.sourceName ?? 'Article Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              article.title ?? 'No Title',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            
            // Image (if available)
            if (article.urlToImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  article.urlToImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                ),
              ),
            const SizedBox(height: 15),

            // Description / Content
            Text(
              article.description ?? article.content ?? 'No content available.',
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),

            // Read More Button (using the launcher function)
            if (article.url != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Call the launch function
                    _launchUrl().catchError((error) {
                      // Display a user-friendly error if launching fails
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to open link: $error')),
                      );
                    });
                  },
                  icon: const Icon(Icons.public),
                  label: const Text('Read Full Article on Web', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}