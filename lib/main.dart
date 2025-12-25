import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_cart/core/utils/debug_db.dart';
import 'package:shopping_cart/features/authentication/presentation/bloc/auth_event.dart';
import 'app.dart';
import 'config/injection_container.dart' as di;
import 'package:shopping_cart/features/authentication/presentation/bloc/auth_bloc.dart';

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
      ],
      child: const MyApp(),
    ),
  );
}