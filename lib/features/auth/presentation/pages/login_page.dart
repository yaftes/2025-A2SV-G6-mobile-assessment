import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:g6_assessment/core/constants/constants.dart';
import 'package:g6_assessment/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:g6_assessment/features/auth/presentation/bloc/auth_event.dart';
import 'package:g6_assessment/features/auth/presentation/bloc/auth_state.dart';
import 'package:g6_assessment/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkTokenAndLogin();
  }

  void _checkTokenAndLogin() async {
    final value = await storage.read(key: StorageKeys.accessToken);
    if (mounted && value != null && value.isNotEmpty) {
      context.read<AuthBloc>().add(LoginWithTokenEvent());
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is LoggedInState) {
              Navigator.pushNamed(context, '/home');
            }
          },
          builder: (context, state) {
            if (state is ErrorState) {
              return Center(child: Text(state.message));
            }

            if (state is LoadingState) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 93, 78, 252),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'ECOM',
                            style: GoogleFonts.caveatBrush(
                              color: const Color.fromARGB(255, 93, 78, 252),
                              fontSize: 35,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      Center(
                        child: Text(
                          'Sign into your account',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Form(
                        key: formkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email',
                              style: GoogleFonts.poppins(color: Colors.grey),
                            ),
                            SizedBox(height: 10),
                            CustomTextfield(
                              controller: _emailController,
                              hintText: 'ex : john@gmail.com',
                              labelName: 'email',
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Password',
                              style: GoogleFonts.poppins(color: Colors.grey),
                            ),
                            SizedBox(height: 10),
                            CustomTextfield(
                              controller: _passwordController,
                              hintText: '*********',
                              labelName: 'password',
                              obscureText: true,
                            ),
                            SizedBox(height: 40),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    93,
                                    78,
                                    252,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  if (formkey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                      LoginEvent(
                                        _emailController.text,
                                        _passwordController.text,
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  'SIGN IN',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account ? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/sign-up'),
                        child: Text(
                          'SIGN UP',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 93, 78, 252),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
