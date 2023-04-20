import 'package:ecms/screens/signUp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firebase_auth.dart';
import '../services/wrapper.dart';
import './vehicles.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final FirebaseAuthMethods _auth = FirebaseAuthMethods();
  String email = "";
  String pass = "";
  bool isPasswordVisible = false;

  void showPass() {
    isPasswordVisible = !isPasswordVisible;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String _title = 'eCMS';

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider<FirebaseAuthMethods>(
        create: (context) => FirebaseAuthMethods(),
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
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
                            await provider.loginWithEmail(
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
                        "Log In",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(6.0),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue.shade50),
                          fixedSize: MaterialStateProperty.all<Size>(
                              const Size(150, 20)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))));
                }),
                Row(
                  children: <Widget>[
                    const Text('Does not have account?'),
                    TextButton(
                      child: const Text(
                        'Sign up',
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUp(),
                          ),
                        );
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ],
            )),
      ),
    );
  }
}
