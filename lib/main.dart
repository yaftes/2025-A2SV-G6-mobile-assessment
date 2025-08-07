import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g6_assessment/app.dart';
import 'package:g6_assessment/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:g6_assessment/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (context) => getIt<AuthBloc>())],
      child: MyApp(),
    ),
  );
}
