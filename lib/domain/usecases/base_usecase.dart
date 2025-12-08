// lib/domain/usecases/base_usecase.dart

import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';

// NoParams is used when a UseCase requires no input parameters (e.g., Hot News)
class NoParams {} 

// Params for filtering by category (e.g., 'technology')
class CategoryParams {
  final String category;
  const CategoryParams(this.category);
}

// Params for filtering by country (e.g., 'us', 'in')
class CountryParams {
  final String countryCode;
  const CountryParams(this.countryCode);
}

// Base UseCase definition
abstract class BaseUseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}