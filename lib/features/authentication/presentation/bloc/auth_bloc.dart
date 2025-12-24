import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_cart/features/authentication/data/datasources/token_data_source.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout_user.dart';
import '../../domain/usecases/register_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUser registerUser;
  final LoginUser loginUser;
  final GetCurrentUser getCurrentUser;
  final LogoutUser logoutUser;
  final TokenDataSource tokenDataSource;

  AuthBloc({
    required this.registerUser,
    required this.loginUser,
    required this.getCurrentUser,
    required this.logoutUser,
    required this.tokenDataSource,
  }) : super(AuthInitial()) {
    on<RegisterButtonPressed>(_onRegisterButtonPressed);
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onRegisterButtonPressed(
      RegisterButtonPressed event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    if (event.username.isEmpty || event.username.length < 3) {
      emit(const AuthValidationError(
          message: 'Username must be at least 3 characters'));
      return;
    }

    if (event.email.isEmpty || !event.email.contains('@')) {
      emit(const AuthValidationError(message: 'Invalid email address'));
      return;
    }

    if (event.password.isEmpty || event.password.length < 6) {
      emit(const AuthValidationError(
          message: 'Password must be at least 6 characters'));
      return;
    }

    if (event.firstName.isEmpty || event.lastName.isEmpty) {
      emit(const AuthValidationError(message: 'Name fields are required'));
      return;
    }

    final result = await registerUser(
      RegisterParams(
        username: event.username,
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
        phone: event.phone,
        shippingAddress: event.shippingAddress,
      ),
    );

    await result.fold(
          (failure) async {
        emit(AuthError(message: _mapFailureToMessage(failure)));
      },
          (user) async {
        // Obtener token guardado
        final token = await tokenDataSource.getToken();
        emit(AuthAuthenticated(
          user: user,
          token: token ?? '',
        ));
      },
    );
  }

  Future<void> _onLoginButtonPressed(
      LoginButtonPressed event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    if (event.username.isEmpty) {
      emit(const AuthValidationError(message: 'Username is required'));
      return;
    }

    if (event.password.isEmpty) {
      emit(const AuthValidationError(message: 'Password is required'));
      return;
    }

    final result = await loginUser(
      LoginParams(
        username: event.username,
        password: event.password,
      ),
    );

    await result.fold(
          (failure) async {
        emit(AuthError(message: _mapFailureToMessage(failure)));
      },
          (user) async {
        final token = await tokenDataSource.getToken();
        emit(AuthAuthenticated(
          user: user,
          token: token ?? '',
        ));
      },
    );
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    // Obtener token del storage
    final token = event.token ?? await tokenDataSource.getToken();

    if (token == null || token.isEmpty) {
      emit(AuthUnauthenticated());
      return;
    }

    final result = await getCurrentUser(
      GetCurrentUserParams(token: token),
    );

    result.fold(
          (failure) => emit(AuthUnauthenticated()),
          (user) => emit(AuthAuthenticated(
        user: user,
        token: token,
      )),
    );
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    final result = await logoutUser(NoParams());

    result.fold(
          (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
          (_) => emit(AuthUnauthenticated()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error. Please try again later.';
      case NetworkFailure:
        return 'No internet connection. Please check your network.';
      case CacheFailure:
        return 'Local data error. Please restart the app.';
      case AuthenticationFailure:
        return (failure as AuthenticationFailure).message;
      case ValidationFailure:
        return (failure as ValidationFailure).message;
      default:
        return 'An unexpected error occurred.';
    }
  }
}