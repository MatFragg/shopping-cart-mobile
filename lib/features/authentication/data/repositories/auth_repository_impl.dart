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
      //await localDataSource.cacheUser(authResult.user);
      //await tokenDataSource.saveToken(authResult.token);

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
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final authResult = await remoteDataSource.login(
        username: username,
        password: password,
      );

      //await localDataSource.cacheUser(authResult.user);
      //await tokenDataSource.saveToken(authResult.token);

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
    try {
      try {
        //final cachedUser = await localDataSource.getCachedUser();
       //return Right(cachedUser);
      } on CacheException {
      }

      if (await networkInfo.isConnected) {
        final userModel = await remoteDataSource.getCurrentUser(token);
        //await localDataSource.cacheUser(userModel);
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
      //await localDataSource.clearCache();
      //await tokenDataSource.deleteToken();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}