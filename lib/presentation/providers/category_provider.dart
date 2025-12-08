import 'package:flutter/material.dart';


import '../../core/error/failure.dart';
import '../../domain/usecases/base_usecase.dart';
import '../../domain/usecases/get_news_by_category.dart';
import '../../domain/entities/article.dart';

class CategoryProvider extends ChangeNotifier {
  final GetNewsByCategory getNewsByCategory;

  CategoryProvider({required this.getNewsByCategory});

  // State variables
  List<Article> articles = [];
  bool isLoading = false;
  String errorMessage = '';

  // The currently selected category to display
  String selectedCategory = 'business'; // Default category

  // Method to fetch articles based on the currently selected category
  Future<void> fetchNewsByCategory() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    // The use case requires CategoryParams
    final result = await getNewsByCategory(CategoryParams(selectedCategory));

    result.fold(
      (failure) {
        // Handle failure (e.g., NetworkFailure, ServerFailure)
        articles = [];
        errorMessage = _mapFailureToMessage(failure);
      },
      (data) {
        // Handle success
        articles = data;
        errorMessage = '';
      },
    );

    isLoading = false;
    notifyListeners();
  }

  // Method to change the category and trigger a new fetch
  void setCategory(String category) {
    if (selectedCategory != category) {
      selectedCategory = category;
      fetchNewsByCategory();
    }
  }

  // Helper method to convert Failure to a user-friendly message
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      case NetworkFailure:
        return 'Connection Error: Please check your internet connection.';
      default:
        return 'An unknown error occurred.';
    }
  }
}