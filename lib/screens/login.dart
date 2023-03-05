import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPageScreen extends StatefulWidget {
  @override
  State<LoginPageScreen> createState() => _LoginPageScreenState();
}

class _LoginPageScreenState extends State<LoginPageScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email_address = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login - Recipe App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Recipe App - In-Lab Activity",
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextField(
                  decoration: InputDecoration(
                      hintText: "Enter your email address...",
                      alignLabelWithHint: true),
                  onChanged: _onEmailAddressChange),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Enter your password...",
                    alignLabelWithHint: true),
                onChanged: _onPasswordChange,
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            ElevatedButton(
              // style: ButtonStyle(backgroundColor: Color.fromARGB(255, 95, 223, 57)),
              onPressed: () => _loginCallback(loginToAccount()),
              child: Text(
                "Log Me In",
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            ElevatedButton(
              style: ButtonStyle(),
              onPressed: () => _registerCallback(registerNewAccount()),
              child: Text(
                "Create an Account",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Updates the state when email changes
  _onEmailAddressChange(emailAddress) {
    setState(() {
      this.email_address = emailAddress;
    });
  }

  //Updates the state when password changes
  _onPasswordChange(password) {
    setState(() {
      this.password = password;
    });
  }

  //Handles sign in
  Future<void> registerNewAccount() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: this.email_address,
        password: this.password,
      );

      Navigator.pushNamed(context, '/home');
    } catch (error) {
      print(error);
    }
  }

  //Handles signup
  Future<void> loginToAccount() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: this.email_address,
        password: this.password,
      );
      // User signed up successfully.
      print("Authenticated");
      Navigator.pushNamed(context, '/home');
    } catch (error) {
      // Handle sign-up errors.
      print(error);
    }
  }

  // login callback
  _loginCallback(Future<void> future) {
    future.then((_) {
      print('Successfully Authenticated!');
    });
  }

  // Signup callback
  _registerCallback(Future<void> future) {
    future.then((_) {
      print('Account Created for You!');
    });
  }
}
