import 'package:biometric_authentication/features/authentication/domain/repositories/auth_repo_interface.dart';
import 'package:biometric_authentication/features/authentication/domain/usecases/authenticate_user.dart';
import 'package:biometric_authentication/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Create a mock or dummy implementation for AuthenticateUser
    AuthenticateUser authenticateUser = AuthenticateUser(FakeAuthRepository());

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(authenticateUser: authenticateUser));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

/// Fake authentication repository for testing.
class FakeAuthRepository implements AuthRepository {
  @override
  Future<bool> authenticate(BuildContext context) async {
    return true; // Always return true for testing.
  }
}
