import 'package:dartz/dartz.dart';

import '../../core/error/failure.dart';
import '../entities/article.dart';
import '../repositories/news_repository.dart';
import 'base_usecase.dart';

class GetNewsByCountryName implements BaseUseCase<List<Article>, CountryNameParams> {
  final NewsRepository repository;

  GetNewsByCountryName(this.repository);

  @override
  Future<Either<Failure, List<Article>>> call(CountryNameParams params) async {
    return await repository.getNewsByCountryName(params.name);
  }
}

class CountryNameParams {
  final String name;

  CountryNameParams(this.name);
}