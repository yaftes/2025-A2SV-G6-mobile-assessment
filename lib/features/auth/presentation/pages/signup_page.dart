import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g6_assessment/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:g6_assessment/features/auth/presentation/bloc/auth_event.dart';
import 'package:g6_assessment/features/auth/presentation/bloc/auth_state.dart';
import 'package:g6_assessment/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool isSelected = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 40),
          child: IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, 'sign-up');
            },
            icon: Icon(Icons.arrow_back_ios_new),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 93, 78, 252),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'ECOM',
                style: GoogleFonts.caveatBrush(
                  color: const Color.fromARGB(255, 93, 78, 252),
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 70),

          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (state is ErrorState) {
                return Center(child: Text(state.message));
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'Create your account',
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
                          'Name',
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                        SizedBox(height: 10),
                        CustomTextfield(
                          controller: _nameController,
                          hintText: 'ex: john smith',
                          labelName: 'name',
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Email',
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                        SizedBox(height: 10),
                        CustomTextfield(
                          controller: _emailController,
                          hintText: 'ex: john@gmail.com',
                          labelName: 'name',
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Password',

                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                        SizedBox(height: 10),
                        CustomTextfield(
                          controller: _passwordController,
                          hintText: '************',
                          labelName: 'password',
                          obscureText: true,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Confirm Password',

                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                        SizedBox(height: 10),
                        CustomTextfield(
                          controller: _confirmPasswordController,
                          hintText: '*******',
                          labelName: 'confirm password',
                          obscureText: true,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: isSelected,
                              onChanged: (value) {
                                setState(() {
                                  isSelected = value!;
                                });
                              },
                              activeColor: const Color.fromARGB(
                                255,
                                93,
                                78,
                                252,
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(text: 'I understood the '),
                                  TextSpan(text: 'term & policy.'),
                                ],
                              ),
                            ),
                          ],
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
                              if (formkey.currentState!.validate() &&
                                  isSelected) {
                                context.read<AuthBloc>().add(
                                  SignUpEvent(
                                    _nameController.text,
                                    _emailController.text,
                                    _passwordController.text,
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'SIGN UP',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Have an account ? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/'),
                        child: Text(
                          'SIGN IN',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 93, 78, 252),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
