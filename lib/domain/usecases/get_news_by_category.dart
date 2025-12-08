// lib/domain/usecases/get_news_by_category.dart

import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../entities/article.dart';
import '../repositories/news_repository.dart';
import 'base_usecase.dart'; // Contains CategoryParams

class GetNewsByCategory implements BaseUseCase<List<Article>, CategoryParams> {
  final NewsRepository repository;

  GetNewsByCategory(this.repository);

  // Calls the repository method with the category string
  @override
  Future<Either<Failure, List<Article>>> call(CategoryParams params) async {
    return await repository.getNewsByCategory(params.category);
  }
}