import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_cart/features/authentication/presentation/bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../bloc/auth_bloc.dart';
import 'custom_text_field.dart';
import 'loading_button.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _shippingAddressController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _shippingAddressController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    if (_formKey.currentState!.validate()) {
      // Validar que las contraseñas coincidan
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      context.read<AuthBloc>().add(
        RegisterButtonPressed(
          username: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phone: _phoneController.text.trim(),
          shippingAddress: _shippingAddressController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Account Information Section
          _buildSectionTitle('Account Information'),
          const SizedBox(height: 16),

          // Username
          CustomTextField(
            controller: _usernameController,
            labelText: 'Username',
            hintText: 'Choose a username',
            prefixIcon: Icons.person_outline,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a username';
              }
              if (value.length < 3) {
                return 'Username must be at least 3 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Email
          CustomTextField(
            controller: _emailController,
            labelText: 'Email',
            hintText: 'Enter your email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@') || !value.contains('.')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Password
          CustomTextField(
            controller: _passwordController,
            labelText: 'Password',
            hintText: 'Create a password',
            prefixIcon: Icons.lock_outline,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Confirm Password
          CustomTextField(
            controller: _confirmPasswordController,
            labelText: 'Confirm Password',
            hintText: 'Re-enter your password',
            prefixIcon: Icons.lock_outline,
            obscureText: _obscureConfirmPassword,
            textInputAction: TextInputAction.next,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),

          // Personal Information Section
          _buildSectionTitle('Personal Information'),
          const SizedBox(height: 16),

          // First Name
          CustomTextField(
            controller: _firstNameController,
            labelText: 'First Name',
            hintText: 'Enter your first name',
            prefixIcon: Icons.badge_outlined,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Last Name
          CustomTextField(
            controller: _lastNameController,
            labelText: 'Last Name',
            hintText: 'Enter your last name',
            prefixIcon: Icons.badge_outlined,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Phone
          CustomTextField(
            controller: _phoneController,
            labelText: 'Phone',
            hintText: 'Enter your phone number',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Shipping Address
          CustomTextField(
            controller: _shippingAddressController,
            labelText: 'Shipping Address',
            hintText: 'Enter your shipping address',
            prefixIcon: Icons.location_on_outlined,
            maxLines: 2,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your shipping address';
              }
              return null;
            },
            onFieldSubmitted: (_) => _onRegisterPressed(),
          ),
          const SizedBox(height: 32),

          // Register button
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return LoadingButton(
                onPressed: _onRegisterPressed,
                isLoading: state is AuthLoading,
                text: 'Create Account',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}