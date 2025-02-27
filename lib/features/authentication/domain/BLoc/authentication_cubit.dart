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
    final bool result = await authenticateUser.requestAuthentication();

    if (result) {
      emit(AuthAuthenticated()); // Emit success state if authenticated.
    } else {
      emit(AuthFailed()); // Emit failure state if authentication fails.
    }
  }
}
