import 'package:flutter/material.dart';



import '../../domain/entities/article.dart';
import '../../domain/usecases/base_usecase.dart';
import '../../domain/usecases/get_top_headlines.dart';

class HomeProvider extends ChangeNotifier {
  final GetTopHeadlines getTopHeadlines;

  HomeProvider({required this.getTopHeadlines});

  List<Article> articles = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchTopHeadlines() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await getTopHeadlines(NoParams());

    result.fold(
      (failure) {
        errorMessage = failure.message;
        articles = [];
      },
      (data) {
        articles = data;
        errorMessage = null;
      },
    );

    isLoading = false;
    notifyListeners();
  }
}