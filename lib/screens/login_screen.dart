import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/resources/auth_method.dart';
import 'package:instagram/utils/show%20snackbar.dart';

import '../utils/colors.dart';
import '../widgets/text_filed_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    setState(() {
      _isLoading = true;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    }else{
      showSnackBar('Login Sucess', context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(),
                  ),
                  SvgPicture.asset(
                    'assets/instagram.svg',
                    height: 64,
                  ),
                  TextFiledInput(
                    textEditingController: _emailController,
                    hintText: 'Enter Your Email',
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFiledInput(
                      textEditingController: _passwordController,
                      hintText: 'Enter Your Password',
                      textInputType: TextInputType.text,
                      isPass: true),
                  const SizedBox(
                    height: 25,
                  ),
                  InkWell(
                    onTap: () => loginUser(),
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                        color: blueColor,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                      ),
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : const Text('Log in'),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text("Don't you have account?"),
                      )),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text("Sign Up"),
                      )),
                    ],
                  )
                ],
              ))),
    );
  }
}
