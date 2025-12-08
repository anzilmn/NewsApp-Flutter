import 'package:dio/dio.dart';
import 'dart:developer'; // Used for log()
import 'news_remote_data_source.dart';
import '../../../domain/entities/article.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/error/exceptions.dart'; 

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final Dio dio;

  const NewsRemoteDataSourceImpl(this.dio);

  // Helper for API call logic, accepting a path and a map of query parameters.
  Future<List<Article>> _getArticlesFromEndpoint(String path, Map<String, dynamic> queryParams) async {
    try {
      final fullQueryParams = {
        ...queryParams,
        'apiKey': newsApiKey, 
      };
      
      final logMessage = 'API Request URL: $newsApiBaseUrl$path with parameters: $fullQueryParams';
      log(logMessage); 
      print(logMessage); // Ensure visibility in terminal

      final response = await dio.get(
        '$newsApiBaseUrl$path', 
        queryParameters: fullQueryParams, 
      );

      if (response.statusCode == 200) {
        final List<dynamic> articlesJson = response.data['articles'];

        return articlesJson.map((json) {
          // Complete JSON parsing to the Article entity
          return Article(
            author: json['author'],
            // ✅ CORRECTION MADE HERE: Removed the extra 'json:'
            title: json['title'],
            description: json['description'],
            url: json['url'],
            urlToImage: json['urlToImage'],
            publishedAt: json['publishedAt'],
            content: json['content'],
            sourceName: json['source']['name'], 
          );
        }).toList();
      } else {
        throw ServerException(message: 'Failed to fetch data with status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      final message = e.response?.data.toString() ?? e.message ?? 'Network error occurred.';
      throw ServerException(message: message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // -------------------------------------------------------------------
  // 1. Implementation for Hot/Global Headlines (UNCHANGED)
  // -------------------------------------------------------------------
  @override
  Future<List<Article>> getTopHeadlines() async {
    return _getArticlesFromEndpoint(
      '/top-headlines',
      {'country': 'us'},
    ); 
  }

  // -------------------------------------------------------------------
  // 2. Implementation for Category Filter (UNCHANGED)
  // -------------------------------------------------------------------
  @override
  Future<List<Article>> getNewsByCategory(String category) async {
    return _getArticlesFromEndpoint(
      '/top-headlines',
      {'category': category, 'country': 'us'},
    );
  }

  // -------------------------------------------------------------------
  // 3. Implementation for Country Filter (REDIRECTED TO NEW SEARCH LOGIC)
  // -------------------------------------------------------------------
  @override
  Future<List<Article>> getNewsByCountry(String countryCode) async {
    // 🛑 Redirect the old method to the new one.
    return getNewsByCountryName(countryCode); 
  }

  // -------------------------------------------------------------------
  // ✅ NEW IMPLEMENTATION: Use /everything endpoint with 'q'
  // -------------------------------------------------------------------
  @override
  Future<List<Article>> getNewsByCountryName(String countryName) async {
    // Use /everything endpoint and search (q) for the full country name.
    // Explicitly set language to English and sort by relevance.
    return _getArticlesFromEndpoint(
      '/everything',
      {
        'q': countryName, 
        'language': 'en',
        'sortBy': 'relevancy', 
      },
    );
  }
}