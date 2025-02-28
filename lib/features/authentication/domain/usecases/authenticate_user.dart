import 'package:flutter/cupertino.dart';

import '../repositories/auth_repo_interface.dart';

class AuthenticateUser {
  final AuthRepository repository;
  AuthenticateUser(this.repository);

  Future<bool> requestAuthentication(BuildContext context) async {
    return await repository.authenticate(context);
  }
}
