import 'package:flutter/material.dart';
import 'package:githubapp/Providers/LoginProviders/LoginProviders.dart';
import 'package:githubapp/Screens/Hompage/HomePage.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "/LoginPage";
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                  HeaderText(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  AnimationWidget(context),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  const SizedBox(
                    height: 30,
                  ),
                  _isLoading
                      ? CircularProgressIndicator()
                      : Container(
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              //Sign in with github Function call
                              var result = await Provider.of<LoginProvider>(
                                      context,
                                      listen: false)
                                  .signinusinggithub(context);
                              if (result) {
                                Navigator.of(context)
                                    .popAndPushNamed(Homepage.routeName);
                              }
                              setState(() {
                                _isLoading = false;
                              });
                            },
                            child: Text("Sign In with github"),
                          ),
                        ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Text("Powered by Vish. Copyright 2022")
            ],
          ),
        ),
      ),
    );
  }

  Container AnimationWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 6.0,
        ),
      ], color: Colors.pink.shade100, borderRadius: BorderRadius.circular(130)),
      height: MediaQuery.of(context).size.height * 0.4,
      child: Lottie.asset('assets/images/login.json'),
    );
  }

  Align HeaderText() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "GitHub Clone",
            style: TextStyle(color: Colors.black, fontSize: 30),
          ),
          Text(
            "Sign IN",
            style: TextStyle(color: Colors.black, fontSize: 60),
          ),
          Text(
            "To Get Started !",
            style: TextStyle(color: Colors.black, fontSize: 30),
          ),
        ],
      ),
    );
  }
}
