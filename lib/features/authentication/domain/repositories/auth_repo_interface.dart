import 'package:flutter/cupertino.dart';

abstract class AuthRepository {
  Future<bool> authenticate(BuildContext context);
  Future<bool> authenticateWithFallback(BuildContext context);
}
