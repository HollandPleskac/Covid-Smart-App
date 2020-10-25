import 'package:covid_smart_app/screens/map.dart';
import 'package:flutter/material.dart';

import '../logic/auth.dart';

final _auth = Auth();

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  String feedback = '';
  final _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('sign in'),
              TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value == null || value == '') {
                    return 'Email cannot be blank';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                validator: (value) {
                  if (value == null || value == '') {
                    return 'Password cannot be blank';
                  }
                  return null;
                },
              ),
              RaisedButton(
                child: Text('Sign In'),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    String res = await _auth.signIn(
                        emailController.text, passwordController.text);

                    if (res != 'Signed in') {
                      setState(() {
                        feedback = res;
                      });
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapSample(),
                        ),
                      );
                    }
                  }
                },
              ),
              Text(
                feedback,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
