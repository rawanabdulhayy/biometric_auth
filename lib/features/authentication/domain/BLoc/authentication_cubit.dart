import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../usecases/authenticate_user.dart';
part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final AuthenticateUser authenticateUser;

  AuthenticationCubit({required this.authenticateUser}) : super(AuthInitial());

  Future<void> authenticate() async {
    emit(
        AuthLoading()); // Show loading state while authentication is in progress.
    Future<void> authenticate() async {
      emit(AuthLoading());
      try {
        final isAuthenticated = await authenticateUser.requestAuthentication();
        if (isAuthenticated) {
          emit(AuthAuthenticated());
        } else {
          emit(AuthFallbackRequired()); // New state for fallback authentication
        }
      } catch (e) {
        emit(AuthFailed());
      }
    }
  }
}
// // authentication_cubit.dart
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../domain/usecases/authenticate_user.dart';
// import 'authentication_state.dart';
//
// class AuthenticationCubit extends Cubit<AuthenticationState> {
//   final AuthenticateUser authenticateUser;
//
//   AuthenticationCubit(this.authenticateUser) : super(AuthInitial());
//
//   Future<void> authenticate() async {
//     emit(AuthLoading());
//     try {
//       final isAuthenticated = await authenticateUser.requestAuthentication();
//       if (isAuthenticated) {
//         emit(AuthAuthenticated());
//       } else {
//         emit(AuthFallbackRequired()); // New state for fallback authentication
//       }
//     } catch (e) {
//       emit(AuthFailed());
//     }
//   }
// }
