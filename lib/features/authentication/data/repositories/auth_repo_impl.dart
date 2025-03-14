// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:local_auth/local_auth.dart';
//
// import '../../domain/repositories/auth_repo_interface.dart';
//
//
// class AuthRepositoryImpl implements AuthRepository {
//   /// Instance of `LocalAuthentication` to interact with the device's biometric authentication.
//   final LocalAuthentication auth = LocalAuthentication();
//   final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
//
//
//   /// Method to authenticate the user using biometrics.
//   ///
//   /// - First, it checks if the device supports biometric authentication.
//   /// - If the device does not support biometrics, it returns `false`.
//   /// - If biometrics are supported, it prompts the user for authentication.
//   /// - Returns `true` if authentication is successful, otherwise `false`.
//   @override
//   Future<bool> authenticate() async {
//     // Check if the device supports biometric authentication (fingerprint/Face ID).
//     bool canAuthenticate = await auth.canCheckBiometrics  || await auth.isDeviceSupported();
//
//   //   // If the device does not support biometrics, return false.
//   //   if (!canAuthenticate) return false;
//   //
//   //   // Trigger biometric authentication and return the result.
//   //   return await auth.authenticate(
//   //     localizedReason: "Authenticate to access the app", // Message displayed on the authentication prompt.
//   //     options: AuthenticationOptions(
//   //       biometricOnly: true, // Ensures that only biometrics (Face ID/Fingerprint) are used.
//   //       stickyAuth: true, // Keeps authentication active even if the app goes into the background.
//   //     ),
//   //   );
//
//     //authenticate returns a bool value
//     if (canAuthenticate) {
//       bool authenticated = await auth.authenticate(
//         localizedReason: "Authenticate to access the app",
//         options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
//       );
//
//       if (authenticated) return true;
//     }
//
//     // If biometrics fail or are unavailable, fall back to PIN/password
//     return await _authenticateWithFallback();
//   }
//
//   Future<bool> _authenticateWithFallback() async {
//     String? storedPin = await secureStorage.read(key: "user_pin");
//
//     if (storedPin != null) {
//       // Show a PIN/password input dialog (to be implemented in UI)
//       String? enteredPin = await _showPinInputDialog();
//
//       return enteredPin == storedPin;
//     }
//
//     return false;
//   }
//
//   Future<String?> _showPinInputDialog() async {
//     // TODO: Implement UI logic to prompt the user for a PIN/password
//     return null;
//   }
//
//   Future<void> storeAuthToken(String token) async {
//     await secureStorage.write(key: "auth_token", value: token);
//   }
//
//   Future<String?> getAuthToken() async {
//     return await secureStorage.read(key: "auth_token");
//   }
//
// }

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import '../../domain/repositories/auth_repo_interface.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalAuthentication auth = LocalAuthentication();
  // final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));

  /// Checks if the device supports biometric authentication.
  Future<bool> checkBiometricSupport() async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool isDeviceSupported = await auth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        return false;
      }

      List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
      return availableBiometrics.contains(BiometricType.strong);
    } catch (e) {
      print("Error checking biometrics: $e");
      return false;
    }
  }

  @override
  Future<bool> authenticate(BuildContext context) async {
    try {
      bool isBiometricSupported = await checkBiometricSupport();
      if (!isBiometricSupported) {
        return await authenticateWithFallback(context);
      }

      bool authenticated = await auth.authenticate(
        localizedReason: "Authenticate using biometrics",
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      return authenticated ? true : await authenticateWithFallback(context);
    } catch (e) {
      print("Authentication failed: $e");
      return await authenticateWithFallback(context);
    }
  }
  //
  // Future<bool> _authenticateWithFallback() async {
  //   String? storedPin = await secureStorage.read(key: "user_pin");
  //   if (storedPin != null) {
  //     String? enteredPin = await _showPinInputDialog();
  //     return enteredPin == storedPin;
  //   }
  //   return false;
  // }
  //
  // Future<String?> _showPinInputDialog() async {
  //   // TODO: Implement UI logic for PIN input
  //   return null;
  // }
@override
  Future<bool> authenticateWithFallback(BuildContext context) async {
    String? storedPin = await secureStorage.read(key: "user_pin");
    if (storedPin != null) {
      String? enteredPin = await _showPinInputDialog(context);
      return enteredPin == storedPin;
    }
    return false;
  }

  Future<String?> _showPinInputDialog(BuildContext context) async {
    TextEditingController pinController = TextEditingController();

    return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Your PIN"),
          content: TextField(
            controller: pinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            decoration: const InputDecoration(labelText: "PIN"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null), // User cancels input
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(pinController.text); // Return entered PIN
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  Future<void> storeAuthToken(String token) async {
    await secureStorage.write(key: "auth_token", value: token);
  }

  Future<String?> getAuthToken() async {
    return await secureStorage.read(key: "auth_token");
  }
}

