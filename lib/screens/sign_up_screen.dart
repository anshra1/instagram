import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/utils/pick_image.dart';
import 'package:instagram/utils/show%20snackbar.dart';

import '../resources/auth_method.dart';
import '../utils/colors.dart';
import '../widgets/text_filed_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        userName: _usernameController.text,
        bio: _bioController.text,
        file: _image!);

    setState(() {
      _isLoading = true;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  Stack(children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                            backgroundColor: Colors.red,
                          )
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                'https://www.freedomspromise.org/wp-content/uploads/2020/01/male-silluette.jpg'),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: () => selectImage(),
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ]),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFiledInput(
                    textEditingController: _usernameController,
                    hintText: 'Enter Your Username',
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 25,
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
                  TextFiledInput(
                      textEditingController: _bioController,
                      hintText: 'Enter Your bio',
                      textInputType: TextInputType.text,
                      isPass: true),
                  const SizedBox(
                    height: 25,
                  ),
                  InkWell(
                    onTap: () => signUpUser(),
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                        color: blueColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : const Text('Sign up'),
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
