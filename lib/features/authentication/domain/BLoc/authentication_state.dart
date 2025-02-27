part of 'authentication_cubit.dart';

@immutable
sealed class AuthenticationState {}

class AuthInitial extends AuthenticationState {} // Initial state before authentication starts.

class AuthLoading extends AuthenticationState {} // State when authentication is in progress.

class AuthAuthenticated extends AuthenticationState {} // State when authentication succeeds.

class AuthFailed extends AuthenticationState {} // State when authentication fails.
