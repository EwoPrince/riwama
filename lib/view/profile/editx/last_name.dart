import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/widgets/button.dart';
import 'package:riwama/widgets/loading.dart';
import 'package:riwama/widgets/textField.dart';
import 'package:riwama/x.dart';

class LastName extends ConsumerStatefulWidget {
  const LastName({super.key});
  static const routeName = '/EditLastName';

  @override
  ConsumerState<LastName> createState() => _LastNameState();
}

class _LastNameState extends ConsumerState<LastName> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController LastNamecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Last Name"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Text(
                'Your Details would be used for accountabily reasons, so give us accurate details.',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20.0,
              ),
              reusableTextField('Last Name', LastNamecontroller,
                  Theme.of(context).primaryColor, () {
                return null;
              }),
              Spacer(),
              _isLoading
                  ? Loading()
                  : button(context, 'Update', () {
                      updateprofile();
                    }),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  updateprofile() async {
    final formValidate = _formKey.currentState?.validate();
    if (!(formValidate!)) {
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    var uid = ref.read(authProvider).user!.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).update({
      'lastName': LastNamecontroller.text,
    }).then((userx) {
      showUpMessage(context, 'Last Name Updated', "");
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
    });
  }
}
