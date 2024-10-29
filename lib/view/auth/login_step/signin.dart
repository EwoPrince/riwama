import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/states/verified_state.dart';
import 'package:riwama/view/auth/forgot.dart';
import 'package:riwama/widgets/button.dart';
import 'package:riwama/widgets/email_textfield.dart';
import 'package:riwama/widgets/loading.dart';
import 'package:riwama/x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Signin extends ConsumerStatefulWidget {
  const Signin({super.key});

  static const routeName = '/signin';

  @override
  ConsumerState<Signin> createState() => _SigninState();
}

class _SigninState extends ConsumerState<Signin> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passVisibility = true;
  bool _isLoading = false;

  xignin() async {
    final formValidate = _formKey.currentState?.validate();
    if (!(formValidate!)) {
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    await ref
        .read(authProvider)
        .loginUser(
          _emailcontroller.text,
          _passwordcontroller.text,
        )
        .then((value) {
      become(context, VerifiedState.routeName, null);

      setState(() {
        _isLoading = false;
      });
    }).onError((error, stackTrace) {
      showMessage(context, 'Error ${error.toString()}');
      setState(() {
        _isLoading = false;
      });
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
        title: Text('Log In'),
      ),
      body: SingleChildScrollView(
        child: Container(
          // color: Theme.of(context),
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
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          "Forgot Password?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                          textAlign: TextAlign.end,
                        ),
                        onPressed: () {
                          goto(
                            context,
                            Forgort.routeName,
                            null,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                _isLoading ? Loading() : button(context, 'LOGIN', xignin),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
