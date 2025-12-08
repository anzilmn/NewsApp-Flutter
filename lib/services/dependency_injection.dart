import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../data/datasources/remote/news_remote_data_source.dart';
import '../data/datasources/remote/news_remote_data_source_impl.dart';
import '../data/repositories/news_repository_impl.dart';
import '../domain/repositories/news_repository.dart';
import '../domain/usecases/get_top_headlines.dart';
import '../domain/usecases/get_news_by_category.dart'; 
// ✅ NEW IMPORT (Corrected Usecase)
import '../domain/usecases/get_news_by_country_name.dart'; 

import '../presentation/providers/home_provider.dart';
import '../presentation/providers/category_provider.dart'; 
import '../presentation/providers/country_provider.dart'; 
// ✅ NEW IMPORT: ThemeProvider
import '../presentation/providers/theme_provider.dart'; 

final sl = GetIt.instance; // sl stands for Service Locator

void init() {
  // ----------------------------------------------------
  // 5. External (Lazy singleton)
  sl.registerLazySingleton(() => Dio());
  
  // ----------------------------------------------------
  // 4. Data Sources (Lazy singleton)
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(sl<Dio>()), 
  );

  // ----------------------------------------------------
  // 3. Data/Repositories (Lazy singleton)
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(remoteDataSource: sl()),
  );

  // ----------------------------------------------------
  // 2. Domain/Usecases (Lazy singleton)
  sl.registerLazySingleton(() => GetTopHeadlines(sl()));
  sl.registerLazySingleton(() => GetNewsByCategory(sl())); 
  // ✅ NEW: Register the new Usecase
  sl.registerLazySingleton(() => GetNewsByCountryName(sl())); 

  // ----------------------------------------------------
  // 1. Presentation/Providers 
  // Registering ThemeProvider as LazySingleton because it manages global state (prefs)
  // ✅ NEW: Register ThemeProvider as LazySingleton
  sl.registerLazySingleton(() => ThemeProvider()); 
  
  // Registering data providers as Factory (new instance on every retrieval is often safer for data fetching)
  sl.registerFactory(() => HomeProvider(getTopHeadlines: sl()));
  sl.registerFactory(() => CategoryProvider(getNewsByCategory: sl())); 
  
  // 🛑 CountryProvider now requires the new Usecase
  sl.registerFactory(() => CountryProvider(getNewsByCountryName: sl())); 
}