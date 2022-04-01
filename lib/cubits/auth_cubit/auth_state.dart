import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthCodeSentState extends AuthState {}

class AuthCodeVerifiedState extends AuthState {}
class AuthSQliteUserCreated extends AuthState {}
class AuthSQliteUserNotCreated extends AuthState {}

class AuthLoggedInState extends AuthState {
  final emailOrPhone;
  final User firebaseUser;
  AuthLoggedInState(this.firebaseUser,this.emailOrPhone);
}

class AuthLoggedOutState extends AuthState {}

class AuthErrorState extends AuthState {
  final String error;
  AuthErrorState(this.error);
}