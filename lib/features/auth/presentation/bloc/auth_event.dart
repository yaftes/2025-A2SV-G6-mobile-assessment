abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  String email;
  String password;
  LoginEvent(this.email, this.password);
}

class SignUpEvent extends AuthEvent {
  String name;
  String email;
  String password;

  SignUpEvent(this.name, this.email, this.password);
}

class LogoutEvent extends AuthEvent {}
