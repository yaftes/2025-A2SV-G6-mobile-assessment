import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g6_assessment/features/auth/domain/usecases/login_usecase.dart';
import 'package:g6_assessment/features/auth/domain/usecases/login_with_token_usecase.dart';
import 'package:g6_assessment/features/auth/domain/usecases/logout_usecase.dart';
import 'package:g6_assessment/features/auth/domain/usecases/signup_usecase.dart';
import 'package:g6_assessment/features/auth/presentation/bloc/auth_event.dart';
import 'package:g6_assessment/features/auth/presentation/bloc/auth_state.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final LogoutUsecase logoutUsecase;
  final SignUpUsecase signUpUsecase;
  final LoginWithTokenUsecase loginWithTokenUsecase;

  late final StreamSubscription<InternetStatus> _connectionSubscription;

  AuthBloc({
    required this.loginUsecase,
    required this.logoutUsecase,
    required this.signUpUsecase,
    required this.loginWithTokenUsecase,
  }) : super(InitialState()) {
    //
    _connectionSubscription = InternetConnection().onStatusChange.listen((
      InternetStatus status,
    ) {
      if (status == InternetStatus.connected) {
        add(ConnectEvent());
      } else {
        add(DisConnectEvent());
      }
    });

    on<LoginEvent>((event, emit) async {
      emit(LoadingState());
      final result = await loginUsecase(event.email, event.password);

      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (success) => emit(LoggedInState(success)),
      );
    });

    // login with token
    on<LoginWithTokenEvent>((event, emit) async {
      emit(LoadingState());
      final result = await loginWithTokenUsecase();
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (success) => emit(LoggedInState(success)),
      );
    });

    // logout
    on<LogoutEvent>((event, emit) async {
      emit(LoadingState());
      final result = await logoutUsecase();
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (success) => LoggedOutState(),
      );
    });

    // sign up
    on<SignUpEvent>((event, emit) async {
      emit(LoadingState());
      final result = await signUpUsecase(
        event.name,
        event.email,
        event.password,
      );
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (success) => emit(SignedUpState()),
      );
    });

    on<ConnectEvent>((event, emit) {
      emit(ConnectedState());
    });

    on<DisConnectEvent>((event, emit) {
      emit(DisConnectedState());
    });
  }
  @override
  Future<void> close() {
    _connectionSubscription.cancel();
    return super.close();
  }
}
