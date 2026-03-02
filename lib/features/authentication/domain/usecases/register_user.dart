import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUser implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  RegisterUser(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.register(
      username:  params.username,
      email: params.email,
      password:  params.password,
      firstName:  params.firstName,
      lastName:  params.lastName,
      phone:  params.phone,
      shippingAddress:  params.shippingAddress,
    );
  }
}

class RegisterParams extends Equatable {
  final String username;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;
  final String shippingAddress;

  const RegisterParams({
    required this.username,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.shippingAddress,
  });

  @override
  List<Object?> get props => [
    username,
    email,
    password,
    firstName,
    lastName,
    phone,
    shippingAddress,
  ];
}
