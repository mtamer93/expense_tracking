import 'package:expense_tracking/google_sign_in.dart';
import 'package:expense_tracking/homePage.dart';
import 'package:expense_tracking/registerPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: height * 0.25,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/topImage.png"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, \nWelcome",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  customSizedBox(),
                  TextField(
                    decoration: customInputDecoration("Username"),
                    controller: _emailController,
                  ),
                  customSizedBox(),
                  TextField(
                    decoration: customInputDecoration("Password"),
                    controller: _passwordController,
                  ),
                  customSizedBox(),
                  Center(
                    child: TextButton(
                      onPressed: () {}, // Forgot Password onPressed
                      child: Text("Forgot Password"),
                    ),
                  ),
                  customSizedBox(),
                  Center(
                    child: Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(111, 61, 209, 1),
                          borderRadius: BorderRadius.circular(20)),
                      child: TextButton(
                        onPressed: () async {
                          String email = _emailController.text.trim();
                          String password = _passwordController.text.trim();

                          try {
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                            final userId =
                                await userCredential.user?.getIdToken();
                            print(
                                'User logged in: ${userCredential.user?.email}');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage(
                                        user: userCredential.user!,
                                        userId: userId!)));
                          } catch (e) {
                            print('Login failed: $e');
                          }
                        }, //  Login Buttonu onPressed
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                  ),
                  customSizedBox(),
                  Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text("Sign in with"),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 18, left: 18),
                                child: Divider(
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      // GOOGLE A BASILIRSA
                                      handleLoginGoogle();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 45),
                                      child: Container(
                                        height: 60.0,
                                        width: 60.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/ggl.png'),
                                            fit: BoxFit.none,
                                          ),
                                          shape: BoxShape.rectangle,
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // FACEBOOK A BASILIRSA
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 45),
                                      child: Container(
                                        height: 60.0,
                                        width: 60.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/fc.png'),
                                            fit: BoxFit.none,
                                          ),
                                          shape: BoxShape.rectangle,
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // APPLE A BASILIRSA
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 45),
                                      child: Container(
                                        height: 60.0,
                                        width: 60.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/apl.png'),
                                            fit: BoxFit.none,
                                          ),
                                          shape: BoxShape.rectangle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  customSizedBox(),
                  Row(
                    children: [
                      Text("Not register yet?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()));
                        }, // Sign Up onPressed
                        child: Text("Sign Up"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customSizedBox() => SizedBox(
        height: 20,
      );

  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
        hintText: hintText,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
          color: Colors.grey,
        )));
  }

  void handleLoginGoogle() async {
    final GoogleSignInProvider googleSignInProvider = GoogleSignInProvider();
    final User? user = await googleSignInProvider.signInWithGoogle();
    final userId = await user?.getIdToken();

    if (user != null && userId != null) {
      print('User signed in: ${user.displayName}');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    user: user,
                    userId: userId,
                  )));
    } else {
      print('Sign-in failed');
    }
  }
}
