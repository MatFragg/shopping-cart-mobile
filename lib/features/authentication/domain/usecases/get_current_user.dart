import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUser implements UseCase<User, GetCurrentUserParams> {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, User>> call(GetCurrentUserParams params) async {
    return await repository.getCurrentUser(params.token);
  }
}

class GetCurrentUserParams extends Equatable {
  final String token;

  const GetCurrentUserParams({required this.token});

  @override
  List<Object?> get props => [token];
}