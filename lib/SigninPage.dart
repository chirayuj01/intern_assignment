import 'package:flutter/material.dart';
import 'package:flutter_app_assignment/adminPage.dart';
import 'package:flutter_app_assignment/userpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool makeVisible = false;
  String username = "";
  String password = "";

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  savelogin(String role)async{
    var prefs=await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn',true);
    prefs.setString('role',role);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: constraints.maxHeight * 0.25),
                  Text(
                    "Sign In",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter your username',
                            suffixIcon: Icon(Icons.account_circle),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                            filled: true,
                            fillColor: Color(0xFFF5FCF9),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 16.0,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                          ),
                          onSaved: (value) {
                            username = value!;
                          },
                          onChanged: (value) {
                            username = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Username cannot be empty';
                            }
                            if (value != 'user123' && value != 'admin123') {
                              return 'Invalid username';
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: TextFormField(
                            obscureText: !makeVisible,
                            obscuringCharacter: '*',
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    makeVisible = !makeVisible;
                                  });
                                },
                                child: Icon(
                                  makeVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                              hintText: 'Enter your Password',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                              filled: true,
                              fillColor: Color(0xFFF5FCF9),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 16.0,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                              ),
                            ),
                            onSaved: (value) {
                              password = value!;
                            },
                            onChanged: (value) {
                              password = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password cannot be empty';
                              }
                              if (value.length < 8) {
                                return 'Password must have more than 8 characters';
                              }
                              if (value != 'password123' &&
                                  value != 'adminpassword123') {
                                return 'Invalid password';
                              }
                              return null;
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              if ((username == 'user123' &&
                                      password == 'password123') ||
                                  (username == 'admin123' &&
                                      password == 'adminpassword123')) {
                                if (username == 'user123' &&
                                    password == 'password123'){
                                  savelogin('user');
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UserPage(
                                                name: username,
                                              )
                                      )
                                  );}
                                if (username == 'admin123' &&
                                    password == 'adminpassword123'){
                                  savelogin('admin');
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AdminPage(
                                                name: username,
                                              )
                                      )
                                  );}
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Signin Successfull',
                                         style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                      duration: Duration(seconds: 2),
                                ));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Invalid credentials entered'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 20,
                            backgroundColor: const Color(0xFF00BF6D),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 58),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            "Sign in",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
