import 'package:biometric_authentication/features/authentication/domain/BLoc/authentication_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Login with Biometrics"),
            BlocBuilder<AuthenticationCubit, AuthenticationState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return CircularProgressIndicator();
                } else if (state is AuthAuthenticated) {
                  return Text("Authenticated!");
                } else if (state is AuthFailed) {
                  return Text("Authentication Failed. Try again.");
                } else {
                  return ElevatedButton(
                    onPressed: () => context.read<AuthenticationCubit>().authenticate(context),
                    child: Text("Use Biometrics"),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
