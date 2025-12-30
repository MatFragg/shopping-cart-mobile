import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shopping_cart/core/constants/api_constants.dart';
import 'package:shopping_cart/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:shopping_cart/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:shopping_cart/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:shopping_cart/features/cart/domain/repositories/cart_repository.dart';
import 'package:shopping_cart/features/cart/domain/usecases/add_item_to_cart.dart';
import 'package:shopping_cart/features/cart/domain/usecases/clear_cart.dart';
import 'package:shopping_cart/features/cart/domain/usecases/get_active_cart.dart';
import 'package:shopping_cart/features/cart/domain/usecases/remove_cart_item.dart';
import 'package:shopping_cart/features/cart/domain/usecases/update_cart_item.dart';
import 'package:shopping_cart/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shopping_cart/features/cart/presentation/bloc/cart_event.dart';
import 'package:shopping_cart/features/products/data/datasources/product_local_data_source.dart';
import 'package:shopping_cart/features/products/data/datasources/product_remote_data_source.dart';
import 'package:shopping_cart/features/products/data/repositories/product_repository_impl.dart';
import 'package:shopping_cart/features/products/domain/repositories/product_repository.dart';
import 'package:shopping_cart/features/products/domain/usecases/create_product.dart';
import 'package:shopping_cart/features/products/domain/usecases/delete_product.dart';
import 'package:shopping_cart/features/products/domain/usecases/get_all_products.dart';
import 'package:shopping_cart/features/products/domain/usecases/get_my_products.dart';
import 'package:shopping_cart/features/products/domain/usecases/get_products_by_category.dart';
import 'package:shopping_cart/features/products/domain/usecases/search_products.dart';
import 'package:shopping_cart/features/products/domain/usecases/update_product.dart';
import 'package:shopping_cart/features/products/presentation/bloc/product_bloc.dart';
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
import 'package:path/path.dart' as p;

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

  //! External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingletonAsync<AppDatabase>(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'shopping_cart.db'));
    debugPrint('DB path: ${file.path}');
    final db = AppDatabase();
    await db.customSelect('SELECT 1').get(); // Prueba de conexión
    return db;
  });
  await sl.isReady<AppDatabase>();
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  await sl.isReady<AppDatabase>();


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

  //! Features - Products
  // Bloc
  sl.registerFactory(
        () => ProductBloc(
      getAllProducts: sl(),
      getMyProducts: sl(),
      createProduct: sl(),
      updateProduct: sl(),
      deleteProduct: sl(),
      searchProducts: sl(),
      tokenDataSource:  sl(),
      getProductsByCategory: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllProducts(sl()));
  sl.registerLazySingleton(() => GetMyProducts(sl()));
  sl.registerLazySingleton(() => CreateProduct(sl()));
  sl.registerLazySingleton(() => UpdateProduct(sl()));
  sl.registerLazySingleton(() => DeleteProduct(sl()));
  sl.registerLazySingleton(() => SearchProducts(sl()));
  sl.registerLazySingleton(() => GetProductsByCategory(sl()));



  // Repository
  sl.registerLazySingleton<ProductRepository>(
        () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      tokenDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
        () => ProductRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<ProductLocalDataSource>(
        () => ProductLocalDataSourceImpl(database: sl()),
  );

  sl.registerFactory(
        () => CartBloc(
      getActiveCart: sl(),
      addItemToCart: sl(),
      removeCartItem: sl(),
      updateCartItem: sl(),
      clearCart: sl(),
    ),
  );

// Use cases
  sl.registerLazySingleton(() => GetActiveCart(sl()));
  sl.registerLazySingleton(() => AddItemToCart(sl()));
  sl.registerLazySingleton(() => RemoveCartItem(sl()));
  sl.registerLazySingleton(() => UpdateCartItem(sl()));
  sl.registerLazySingleton(() => ClearCart(sl()));

// Repository
  sl.registerLazySingleton<CartRepository>(
        () => CartRepositoryImpl(
      remoteDataSource: sl(),
      //localDataSource: sl(),
      tokenDataSource: sl(),
      networkInfo: sl(),
    ),
  );

// Data sources
  sl.registerLazySingleton<CartRemoteDataSource>(
        () => CartRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<CartLocalDataSource>(
        () => CartLocalDataSourceImpl(database: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(sl()),
  );
}