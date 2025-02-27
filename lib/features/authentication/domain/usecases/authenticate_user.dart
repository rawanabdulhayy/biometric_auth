import '../repositories/auth_repo_interface.dart';

class AuthenticateUser {
  final AuthRepository repository;
  AuthenticateUser(this.repository);

  Future<bool> requestAuthentication() async {
    return await repository.authenticate();
  }
}
