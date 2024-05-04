// ignore_for_file: use_build_context_synchronously

import 'package:demo_project/src/config/manager/storage_manager.dart';
import 'package:demo_project/src/config/theme/app_colors.dart';
import 'package:demo_project/src/config/theme/app_text_style.dart';
import 'package:demo_project/src/constants/app_const_assets.dart';
import 'package:demo_project/src/constants/app_storage_key.dart';
import 'package:demo_project/src/module/courses/courses_screen.dart';
import 'package:demo_project/src/module/sign_up/sign_up_screen.dart';
import 'package:demo_project/src/widgets/input_text_field.dart';
import 'package:demo_project/src/widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      StorageManager.setBoolValue(key: AppStorageKey.isLogIn, value: true);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const CoursesScreen()),
          (route) => false);
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(error.message ?? ''),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(e.toString()),
      ));
    }
  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      topView(),
                      const SizedBox(
                        height: 12,
                      ),
                      emailView(),
                      const SizedBox(
                        height: 12,
                      ),
                      passwordView(),
                      const SizedBox(
                        height: 12,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {},
                          child: Text(
                            'Forget Password?',
                            style: AppTextStyle.regularText14,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      PrimaryButton(
                        text: 'Log In',
                        tColor: Colors.white,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            signIn();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Do not have an account? ',
                        style: AppTextStyle.regularText16.copyWith(
                          color: AppColors.greyColor,
                        ),
                      ),
                      TextSpan(
                        text: 'Register',
                        style: AppTextStyle.regularText16,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SignUpScreen()),
                                (route) => false);
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget topView() {
    return Column(
      children: [
        Center(
          child: Image.asset(
            AppAssets.signIn,
            height: 200,
            width: 200,
          ),
        ),
        Text(
          'Log in',
          style: AppTextStyle.regularText20.copyWith(
            fontFamily: 'poppins',
          ),
        ),
      ],
    );
  }

  Widget emailView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: AppTextStyle.regularText16,
        ),
        const SizedBox(
          height: 8,
        ),
        EmailWidget(
          hintText: 'Email',
          controller: email,
        ),
      ],
    );
  }

  Widget passwordView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: AppTextStyle.regularText16,
        ),
        const SizedBox(
          height: 8,
        ),
        PasswordWidget(
          hintText: 'Password',
          passType: 'Password',
          controller: password,
          showsuffixIcon: true,
        ),
      ],
    );
  }
}
