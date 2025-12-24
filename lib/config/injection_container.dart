import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shopping_cart/core/constants/api_constants.dart';
import '../core/database/app_database.dart';
import '../core/network/network_info.dart';
import '../features/authentication/data/datasources/auth_local_data_source.dart';
import '../features/authentication/data/datasources/auth_remote_data_source.dart';
import '../features/authentication/data/datasources/token_data_source.dart';
import '../features/authentication/data/repositories/auth_repository_impl.dart';
import '../features/authentication/domain/repositories/auth_repository.dart';
import '../features/authentication/domain/usecases/get_current_user.dart';
import '../features/authentication/domain/usecases/login_user.dart';
import '../features/authentication/domain/usecases/logout_user.dart';
import '../features/authentication/domain/usecases/register_user.dart';
import '../features/authentication/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {

  // Logger interceptor
  sl.registerLazySingleton<PrettyDioLogger>(() => PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
    compact: true,
    maxWidth: 90,
    logPrint: (obj) => debugPrint(obj.toString(), wrapWidth: 1024),
  ));

  sl.registerLazySingleton<Dio>(() {
    final rawBase = ApiConstants.baseUrl ?? '';
    final trimmed = rawBase.trim();

    String base;
    if (trimmed.isEmpty) {
      base = '';
    } else if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      base = trimmed;
    } else {
      base = 'http://$trimmed';
    }

    try {
      final options = BaseOptions(
        baseUrl: base,
        connectTimeout: const Duration(milliseconds: 5000),
        receiveTimeout: const Duration(milliseconds: 5000),
        contentType: 'application/json',
      );

      final dio = Dio(options);

      if (kDebugMode) {
        dio.interceptors.add(sl<PrettyDioLogger>());
      }

      return dio;
    } catch (e, st) {
      debugPrint('Error while creating Dio: $e');
      debugPrint(st.toString());
      rethrow;
    }
  });

  //! Features - Authentication

  // Bloc
  sl.registerFactory(
        () => AuthBloc(
      registerUser: sl(),
      loginUser: sl(),
      getCurrentUser: sl(),
      logoutUser: sl(),
      tokenDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl(),
      localDataSource: sl(),
      tokenDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(database: sl()),
  );

  sl.registerLazySingleton<TokenDataSource>(
        () => TokenDataSourceImpl(secureStorage: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(sl()),
  );

  //! External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => AppDatabase());
  sl.registerLazySingleton(() => const FlutterSecureStorage());

}