import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/authentication/data/repositories/auth_repo_impl.dart';
import 'features/authentication/domain/BLoc/authentication_cubit.dart';
import 'features/authentication/domain/usecases/authenticate_user.dart';
import 'features/authentication/presentation/screens/login_screen.dart';


void main() {
  final authRepository = AuthRepositoryImpl();
  final authenticateUser = AuthenticateUser(authRepository);

  runApp(MyApp(authenticateUser: authenticateUser));
}

class MyApp extends StatelessWidget {
  final AuthenticateUser authenticateUser;
  MyApp({required this.authenticateUser});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationCubit(authenticateUser: authenticateUser),
      child: MaterialApp(
        home: LoginScreen(),
      ),
    );
  }
}
