import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'homee.dart';
import 'signupp.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool keepLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            CheckboxListTile(
              title: Text("Keep me logged in"),
              value: keepLoggedIn,
              onChanged: (newValue) {
                setState(() {
                  keepLoggedIn = newValue ?? false;
                });
              },
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await Provider.of<AuthProvider>(context, listen: false)
                      .signIn(emailController.text, passwordController.text, keepLoggedIn: keepLoggedIn);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Login failed: ${error.toString()}")),
                  );
                }
              },
              child: Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              },
              child: Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
