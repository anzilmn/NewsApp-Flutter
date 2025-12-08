// lib/domain/usecases/get_news_by_country.dart

import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../entities/article.dart';
import '../repositories/news_repository.dart';
import 'base_usecase.dart'; // Contains CountryParams

class GetNewsByCountry implements BaseUseCase<List<Article>, CountryParams> {
  final NewsRepository repository;

  GetNewsByCountry(this.repository);

  // Calls the repository method with the countryCode string
  @override
  Future<Either<Failure, List<Article>>> call(CountryParams params) async {
    return await repository.getNewsByCountry(params.countryCode);
  }
}