import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g6_assessment/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:g6_assessment/features/auth/presentation/bloc/auth_event.dart';
import 'package:g6_assessment/features/auth/presentation/bloc/auth_state.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(
      LoginEvent(_emailController.text, _passwordController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UserDataFetchedState) {
            // : TODO navigate to home page using this data
          }
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ErrorState) {
            return Center(child: Text(state.message));
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 93, 78, 252),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'ECOM',
                        style: GoogleFonts.aBeeZee(
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
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'email is required';
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.black),
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'ex: john@gmail.com',
                            hintStyle: GoogleFonts.poppins(color: Colors.grey),
                            fillColor: const Color.fromARGB(255, 241, 239, 239),
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Password',

                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'password is required';
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.black),
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: '*********',
                            hintStyle: GoogleFonts.poppins(color: Colors.grey),
                            fillColor: const Color.fromARGB(255, 241, 239, 239),
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
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
                                borderRadius: BorderRadiusGeometry.circular(10),
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
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have an account ? ",
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextSpan(
                            onEnter: (event) {
                              // : TODO add navigate to sign up page
                            },
                            text: 'SIGN UP',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 93, 78, 252),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
