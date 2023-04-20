import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/firebase_auth.dart';
import '../services/wrapper.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuthMethods _auth = FirebaseAuthMethods();
  String email = "";
  String pass = "";
  String name = "";
  final String _title = 'eCMS';

  bool isPasswordVisible = false;

  void showPass() {
    isPasswordVisible = !isPasswordVisible;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_title),
        automaticallyImplyLeading: true,
      ),
      body: ChangeNotifierProvider<FirebaseAuthMethods>(
        create: (context) => FirebaseAuthMethods(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Consumer<FirebaseAuthMethods>(
                builder: (context, provider, child) {
                  return TextFormField(
                    controller: provider.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Name",
                      labelText: "Name",
                      prefixIcon: Icon(Icons.person),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "abc@abc.com",
                  labelText: " Email",
                  prefixIcon: Icon(Icons.mail_outline),
                ),
                onChanged: (val) => setState(() {
                  email = val;
                }),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "Enter password here",
                  labelText: " Password",
                  prefixIcon: const Icon(Icons.password),
                  suffixIcon: IconButton(
                    icon: isPasswordVisible
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                    onPressed: () {
                      showPass();
                    },
                  ),
                ),
                obscureText: !isPasswordVisible,
                onChanged: (val) => setState(() {
                  pass = val;
                }),
              ),
              const SizedBox(height: 20),
              Consumer<FirebaseAuthMethods>(
                builder: (context, provider, child) {
                  return ElevatedButton(
                    onPressed: () async => {
                      provider.getName(),
                      await provider.signUpWithEmail(
                          email: email, password: pass, context: context),
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AuthWrapper(),
                        ),
                        (route) => false,
                      )
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(6.0),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blue.shade50),
                      fixedSize:
                          MaterialStateProperty.all<Size>(const Size(150, 20)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
