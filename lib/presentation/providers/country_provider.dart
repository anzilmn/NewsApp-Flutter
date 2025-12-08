import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';

import '../../core/error/failure.dart';
import '../../domain/usecases/base_usecase.dart';
// 🛑 REMOVE OLD Usecase import: import '../../domain/usecases/get_news_by_country.dart';
// ✅ NEW IMPORT:
import '../../domain/usecases/get_news_by_country_name.dart'; 
import '../../domain/entities/article.dart';

class CountryProvider extends ChangeNotifier {
  // 🛑 CHANGE: Inject the new Usecase
  final GetNewsByCountryName getNewsByCountryName;

  // 🛑 CHANGE: Updated Constructor
  CountryProvider({required this.getNewsByCountryName});

  // State variables
  List<Article> articles = [];
  bool isLoading = false;
  String errorMessage = '';

  // 🛑 CHANGE: Track the country NAME for the /everything search (US as default)
  String selectedCountryName = 'United States'; 

  // Method to fetch articles based on the currently selected country NAME
  Future<void> fetchNewsByCountry() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    // 🛑 CHANGE: Use the new Usecase and the new CountryNameParams
    final result = await getNewsByCountryName(CountryNameParams(selectedCountryName));

    result.fold(
      (failure) {
        // Handle failure
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

  // Method to change the country NAME and trigger a new fetch
  void setCountry(String countryName) {
    if (selectedCountryName != countryName) {
      selectedCountryName = countryName;
      fetchNewsByCountry();
      notifyListeners();
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