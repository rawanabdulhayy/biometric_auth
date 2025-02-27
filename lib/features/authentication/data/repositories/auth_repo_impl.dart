import 'package:local_auth/local_auth.dart';

import '../../domain/repositories/auth_repo_interface.dart';


class AuthRepositoryImpl implements AuthRepository {
  /// Instance of `LocalAuthentication` to interact with the device's biometric authentication.
  final LocalAuthentication auth = LocalAuthentication();

  /// Method to authenticate the user using biometrics.
  ///
  /// - First, it checks if the device supports biometric authentication.
  /// - If the device does not support biometrics, it returns `false`.
  /// - If biometrics are supported, it prompts the user for authentication.
  /// - Returns `true` if authentication is successful, otherwise `false`.
  @override
  Future<bool> authenticate() async {
    // Check if the device supports biometric authentication (fingerprint/Face ID).
    bool canAuthenticate = await auth.canCheckBiometrics;

    // If the device does not support biometrics, return false.
    if (!canAuthenticate) return false;

    // Trigger biometric authentication and return the result.
    return await auth.authenticate(
      localizedReason: "Authenticate to access the app", // Message displayed on the authentication prompt.
      options: AuthenticationOptions(
        biometricOnly: true, // Ensures that only biometrics (Face ID/Fingerprint) are used.
        stickyAuth: true, // Keeps authentication active even if the app goes into the background.
      ),
    );
  }
}
