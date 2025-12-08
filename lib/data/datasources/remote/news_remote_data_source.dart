// lib/data/datasources/remote/news_remote_data_source.dart

import '../../../domain/entities/article.dart';

abstract class NewsRemoteDataSource {
  Future<List<Article>> getTopHeadlines();
  Future<List<Article>> getNewsByCategory(String category); // New!
  Future<List<Article>> getNewsByCountry(String countryCode); // New!
  Future<List<Article>> getNewsByCountryName(String countryName);
}