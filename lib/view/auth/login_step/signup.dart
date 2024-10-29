// ignore_for_file: must_be_immutable

import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/view/auth/login_step/Xfullname.dart';
import 'package:riwama/view/auth/login_step/signin.dart';
import 'package:riwama/view/userguild/tac.dart';
import 'package:riwama/widgets/button.dart';
import 'package:riwama/widgets/email_textfield.dart';
import 'package:riwama/widgets/loading.dart';
import 'package:riwama/x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Signup extends ConsumerStatefulWidget {
  Signup({
    super.key,
  });
  static const routeName = '/signup';

  @override
  ConsumerState<Signup> createState() => _SignupState();
}

class _SignupState extends ConsumerState<Signup> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final _formKey2 = GlobalKey<FormState>();
  bool _passVisibility = true;
  bool _isLoading = false;

  xignup() async {
    final formValidate = _formKey2.currentState?.validate();
    if (!(formValidate!)) {
      return;
    }
    _formKey2.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    ref
        .read(authProvider)
        .setEmailPass(_emailcontroller.text, _passwordcontroller.text);
    goto(
      context,
      XFullName.routeName,
      null,
    );
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Rivers State Waste Management Agency',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      width: 120,
                      height: 120,
                      child: Image.asset("assets/logo.png"),
                    ),
                  ),
                ),
                Form(
                  key: _formKey2,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: emailTextField("Email", _emailcontroller,
                            Theme.of(context).primaryColor),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: TextFormField(
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passwordcontroller,
                          autofocus: false,
                          obscureText: _passVisibility,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "password field is required";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: _passVisibility
                                  ? Icon(Icons.visibility_off)
                                  : Icon(
                                      Icons.visibility,
                                      color: Theme.of(context).primaryColor,
                                    ),
                              onPressed: () {
                                _passVisibility = !_passVisibility;
                                setState(() {});
                              },
                            ),
                            labelText: "password",
                            contentPadding: EdgeInsets.all(10),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: TextFormField(
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passwordcontroller,
                          autofocus: false,
                          obscureText: _passVisibility,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "password field is required";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: _passVisibility
                                  ? Icon(Icons.visibility_off)
                                  : Icon(
                                      Icons.visibility,
                                      color: Theme.of(context).primaryColor,
                                    ),
                              onPressed: () {
                                _passVisibility = !_passVisibility;
                                setState(() {});
                              },
                            ),
                            labelText: "Confirm Password",
                            contentPadding: EdgeInsets.all(10),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: TextButton(
                          child: Text(
                            "Already have an account?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                            textAlign: TextAlign.end,
                          ),
                          onPressed: () {
                            goto(
                              context,
                              Signin.routeName,
                              null,
                            );
                          }),
                    ),
                  ],
                ),
                _isLoading ? Loading() : button(context, 'Sign Up', xignup),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "By signing up I agree to the ",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 12.0,
                      ),
                    ),
                    Text(
                      "Terms and Conditions.",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 12.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ).onTap(() {
                      goto(
                        context,
                        tac.routeName,
                        null,
                      );
                    }),
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
