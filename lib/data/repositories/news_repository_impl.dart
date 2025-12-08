import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failure.dart';
import '../../../domain/entities/article.dart';
import '../../../domain/repositories/news_repository.dart';
import '../datasources/remote/news_remote_data_source.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl({required this.remoteDataSource});

  // --- Helper function to handle common try-catch/Either logic ---
  Future<Either<Failure, List<Article>>> _executeFetch(
      Future<List<Article>> Function() fetchFunction) async {
    try {
      final remoteArticles = await fetchFunction();
      return Right(remoteArticles);
    } on DioException catch (e) {
      // Handle Dio network-specific errors
      if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.unknown) {
        return const Left(NetworkFailure());
      }
      return Left(ServerFailure(e.message ?? 'Unknown error occurred.'));
    } on ServerException catch (e) {
       // Handle custom ServerException thrown by the data source
      return Left(ServerFailure(e.message)); 
    } catch (e) {
      // Handle other unknown exceptions
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
  // -------------------------------------------------------------------


  @override
  Future<Either<Failure, List<Article>>> getTopHeadlines() async {
    return _executeFetch(() => remoteDataSource.getTopHeadlines());
  }
  
  // Implementation for fetching news by category
  @override
  Future<Either<Failure, List<Article>>> getNewsByCategory(String category) async {
    return _executeFetch(() => remoteDataSource.getNewsByCategory(category));
  }
  
  // 🛑 Implementation for fetching news by country (NOW REDIRECTS to the working search method)
  @override
  Future<Either<Failure, List<Article>>> getNewsByCountry(String countryCode) async {
    // Redirect the call to the new, working search method.
    return getNewsByCountryName(countryCode); 
  }
  
  // ✅ NEW: Implementation for fetching news by country name using /everything
  @override
  Future<Either<Failure, List<Article>>> getNewsByCountryName(String countryName) async {
    // Calls the new method on the remote data source
    return _executeFetch(() => remoteDataSource.getNewsByCountryName(countryName));
  }
}