import 'package:flutter/material.dart';
import 'package:youtube/common/apis.dart';
import 'package:youtube/widgets/bottomnav.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formkey = GlobalKey<FormState>();
  bool isLogin = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final usernameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              height: 15,
            ),
            SvgPicture.asset("assets/youtube.svg"),
            SizedBox(
                width:
                    8), // Optional: Add some space between the icon and the text
            Text(
              isLogin ? 'Log In' : 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: !isLogin ? 500 : 350,
            width: 350,
            margin: EdgeInsets.only(top: 150),
            child: Form(
              key: _formkey,
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    !isLogin
                        ? TextFormField(
                            controller: usernameController,
                            key: ValueKey('Username'),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Color.fromARGB(255, 154, 151, 151),
                              hintText: "Enter Username",
                              hintStyle: TextStyle(color: Colors.black),
                              labelStyle: TextStyle(
                                  color: Colors.white), // label text color
                            ),
                            style: TextStyle(
                                color: Colors.black), // input text color
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "invalid username";
                              } else {
                                return null;
                              }
                            },
                          )
                        : Container(),
                    TextFormField(
                      controller: emailController,
                      key: ValueKey('Email'),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 154, 151, 151),
                        hintText: "Enter Email",
                        hintStyle: TextStyle(color: Colors.black),
                        labelStyle:
                            TextStyle(color: Colors.black), // label text color
                      ),
                      style: TextStyle(color: Colors.black), // input text color
                      validator: (value) {
                        if (!(value.toString().contains("@"))) {
                          return 'Invalid Email';
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      key: ValueKey('Password'),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 154, 151, 151),
                        hintText: "Enter Password",
                        hintStyle: TextStyle(color: Colors.black),
                        labelStyle:
                            TextStyle(color: Colors.black), // label text color
                      ),
                      style: TextStyle(color: Colors.black), // input text color
                      validator: (value) {
                        if (value.toString().length < 6) {
                          return 'Password is too short';
                        } else {
                          return null;
                        }
                      },
                    ),
                    if (!isLogin)
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        key: ValueKey('Confirm Password'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Color.fromARGB(255, 154, 151, 151),
                          hintText: "Reenter Password",
                          hintStyle: TextStyle(color: Colors.black),
                          labelStyle: TextStyle(
                              color: Colors.black), // label text color
                        ),
                        style:
                            TextStyle(color: Colors.black), // input text color
                        validator: (value) {
                          if (value.toString().length < 6) {
                            return 'Password is too short';
                          } else if (value != passwordController.text) {
                            return 'Passwords do not match';
                          } else {
                            return null;
                          }
                        },
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            _formkey.currentState!.save();
                            if (isLogin) {
                              await API.login(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim());

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Bottomnav()));
                            } else {
                              API.signUp(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  username: usernameController.text.trim());

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Bottomnav()));
                            }
                          }
                        },
                        child: Text(
                          isLogin ? "Log In" : "Sign Up",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromRGBO(255, 0, 79, 1)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(
                        isLogin
                            ? "Not Have an Account? Signup"
                            : "Already Signed Up? Login",
                        style: TextStyle(color: Color.fromRGBO(255, 179, 0, 1)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
