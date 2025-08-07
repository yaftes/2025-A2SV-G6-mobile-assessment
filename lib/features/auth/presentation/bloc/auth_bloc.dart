import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g6_assessment/features/auth/domain/usecases/login_usecase.dart';
import 'package:g6_assessment/features/auth/domain/usecases/logout_usecase.dart';
import 'package:g6_assessment/features/auth/domain/usecases/signup_usecase.dart';
import 'package:g6_assessment/features/auth/presentation/bloc/auth_event.dart';
import 'package:g6_assessment/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // let's inject the usecases here
  final LoginUsecase loginUsecase;
  final LogoutUsecase logoutUsecase;
  final SignUpUsecase signUpUsecase;

  AuthBloc({
    required this.loginUsecase,
    required this.logoutUsecase,
    required this.signUpUsecase,
  }) : super(InitialState()) {
    on<LoginEvent>((event, emit) async {
      emit(LoadingState());
      final result = await loginUsecase(event.email, event.password);

      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (success) => emit(UserFetchedState(success)),
      );
    });
    on<LogoutEvent>((event, emit) async {
      emit(LoadingState());
      final result = await logoutUsecase();
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (success) => LoggedOutState(),
      );
    });
    on<SignUpEvent>((event, emit) async {
      emit(LoadingState());
      final result = await signUpUsecase(
        event.name,
        event.email,
        event.password,
      );
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (success) => emit(UserFetchedState(success)),
      );
    });
  }
}
