import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {}

class NetworkFailure extends Failure {}

class CacheFailure extends Failure {}

class AuthenticationFailure extends Failure {
  final String message;

  const AuthenticationFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ValidationFailure extends Failure {
  final String message;

  const ValidationFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class InsufficientStockFailure extends Failure {
  final String message;
  final int availableStock;

  InsufficientStockFailure({
    required this.message,
    this.availableStock = 0,
  });

  @override
  List<Object?> get props => [message, availableStock];
}