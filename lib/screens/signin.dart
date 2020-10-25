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
      body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Center(
              child: Text(
                'Login',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 46,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.10,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(
                    child: Container(
                      color: Colors.green[100],
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: 'Email'),
                            validator: (value) {
                              if (value == null || value == '') {
                                return 'Email cannot be blank';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.85,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Center(
                    child: Container(
                      color: Colors.blue[100],
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: 'Password'),
                            validator: (value) {
                              if (value == null || value == '') {
                                return 'Password cannot be blank';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.85,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Center(
              child: Container(
                child: new Material(
                  child: new InkWell(
                    onTap: () async {
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
                          builder: (context) => MapScreen(),
                        ),
                      );
                    }
                  }
                    },
                    child: new Container(
                      child: Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.03,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.transparent,
                ),
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  color: Colors.pink[100],
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),
            Text(
                feedback,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ));
  }
}
