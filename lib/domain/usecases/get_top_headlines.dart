// lib/domain/usecases/get_top_headlines.dart

import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../entities/article.dart';
import '../repositories/news_repository.dart';
import 'base_usecase.dart'; // <<< Requires base_usecase.dart

class GetTopHeadlines implements BaseUseCase<List<Article>, NoParams> {
  final NewsRepository repository;

  GetTopHeadlines(this.repository);

  // Calls the repository method to get the data
  @override
  Future<Either<Failure, List<Article>>> call(NoParams params) async {
    return await repository.getTopHeadlines();
  }
}