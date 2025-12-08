import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../entities/article.dart';

abstract class NewsRepository {
  // Existing method for general top/hot headlines
  Future<Either<Failure, List<Article>>> getTopHeadlines();

  // NEW: Method to get headlines filtered by a specific country code (e.g., 'us', 'in')
  Future<Either<Failure, List<Article>>> getNewsByCountry(String countryCode);

  // NEW: Method to get headlines filtered by a specific category (e.g., 'business', 'sports')
  Future<Either<Failure, List<Article>>> getNewsByCategory(String category);
  Future<Either<Failure, List<Article>>> getNewsByCountryName(String countryName);
}