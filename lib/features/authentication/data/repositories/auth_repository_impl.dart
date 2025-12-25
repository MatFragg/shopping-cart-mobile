import 'package:dartz/dartz.dart';
import 'package:shopping_cart/features/authentication/data/datasources/auth_local_data_source.dart';
import 'package:shopping_cart/features/authentication/data/datasources/token_data_source.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo networkInfo;
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final TokenDataSource tokenDataSource;

  AuthRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
    required this.localDataSource,
    required this.tokenDataSource,
  });

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.!#%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}"
      r"[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
    );
    return emailRegExp.hasMatch(email);
  }

  @override
  Future<Either<Failure, User>> register({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String shippingAddress,
  }) async {

    if (username.trim().isEmpty ||
        email.trim().isEmpty ||
        password.trim().isEmpty ||
        firstName.trim().isEmpty ||
        lastName.trim().isEmpty) {
      return Left(ValidationFailure('Campos obligatorios incompletos'));
    }

    if (!_isValidEmail(email)) {
      return Left(ValidationFailure('Email inválido'));
    }


    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final authResult = await remoteDataSource.register(
        username: username,
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        shippingAddress: shippingAddress,
      );

      // Guardar usuario y token
      await localDataSource.cacheUser(authResult.user);
      try {
        await tokenDataSource.saveToken(authResult.token);
      } catch (_) {
        return Left(CacheFailure());
      }

      return Right(authResult.user);

    } on BadRequestException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> login({
    required String username,
    required String password,
  }) async {
    if (username.trim().isEmpty || password.trim().isEmpty) {
      return Left(ValidationFailure('Nombre de usuario y contraseña son requeridos'));
    }

    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final authResult = await remoteDataSource.login(
        username: username,
        password: password,
      );

      await localDataSource.cacheUser(authResult.user);
      try {
        await tokenDataSource.saveToken(authResult.token);
      } catch (_) {
        return Left(CacheFailure());
      }

      return Right(authResult.user);

    } on UnauthorizedException {
      return Left(AuthenticationFailure('Invalid username or password'));
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser(String token) async {
    if (token.trim().isEmpty) {
      return Left(AuthenticationFailure('Token no válido'));
    }
    try {
      // Intentar cache primero
      try {
        final cachedUser = await localDataSource.getCachedUser();
        return Right(cachedUser);
      } on CacheException {
        // Continuar al remoto
      }

      // Obtener del backend
      if (await networkInfo.isConnected) {
        final userModel = await remoteDataSource.getCurrentUser(token);
        await localDataSource.cacheUser(userModel);
        return Right(userModel);
      }

      return Left(CacheFailure());
    } on UnauthorizedException {
      return Left(AuthenticationFailure('Session expired'));
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearCache();
      try {
        await tokenDataSource.deleteToken();
      } catch (_) {
        return Left(CacheFailure());
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}