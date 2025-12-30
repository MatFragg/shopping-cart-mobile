import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_cart/core/utils/debug_db.dart';
import 'package:shopping_cart/features/authentication/presentation/bloc/auth_event.dart';
import 'package:shopping_cart/features/cart/presentation/bloc/cart_bloc.dart';
import 'app.dart';
import 'config/injection_container.dart' as di;
import 'package:shopping_cart/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:shopping_cart/features/products/presentation/bloc/product_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();
  await debugDb('app.db');
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>()..add(CheckAuthStatus()),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => di.sl<ProductBloc>(),
        ),
        BlocProvider<CartBloc>(
          create: (context) => di.sl<CartBloc>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
