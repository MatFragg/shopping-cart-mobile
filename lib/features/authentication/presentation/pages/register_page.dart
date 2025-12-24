import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/injection_container.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/register_form.dart';
import '../bloc/auth_state.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static const String routeName = '/register';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => sl<AuthBloc>(),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              // Navegar a home cuando el registro es exitoso
              Navigator.of(context).pushReplacementNamed('/home');
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state is AuthValidationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.orange,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo o icono
                    Icon(
                      Icons.shopping_cart,
                      size: 80,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 16),

                    // Título
                    Text(
                      'Create Account',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'Sign up to get started',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Formulario de registro
                    const RegisterForm(),

                    const SizedBox(height: 24),

                    // Link a login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/login');
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}