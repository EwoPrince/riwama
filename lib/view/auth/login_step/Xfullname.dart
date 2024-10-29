import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/view/auth/verify.dart';
import 'package:riwama/widgets/button.dart';
import 'package:riwama/widgets/loading.dart';
import 'package:riwama/widgets/textField.dart';
import 'package:riwama/x.dart';

class XFullName extends ConsumerStatefulWidget {
  const XFullName({super.key});
  static const routeName = '/FullName';

  @override
  ConsumerState<XFullName> createState() => _FullNameState();
}

class _FullNameState extends ConsumerState<XFullName> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstnamecontroller = TextEditingController();
  TextEditingController middlenamecontroller = TextEditingController();
  TextEditingController lastnamecontroller = TextEditingController();
  TextEditingController phonenumbercontroller = TextEditingController();
  TextEditingController dobcontroller = TextEditingController();
  TextEditingController nationalitycontroller = TextEditingController();
  TextEditingController statecontroller = TextEditingController();
  TextEditingController lgacontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Details"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Text(
                  'Help Us give you a Customized Experience,',
                  textAlign: TextAlign.start,
                ),
                Text(
                  'The following Information would be used for accountabily reasons, so give us accurate details.',
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 20),
                reusableTextField(
                  'First Name',
                  firstnamecontroller,
                  Theme.of(context).primaryColor,
                  () {
                    return null;
                  },
                ),
                SizedBox(height: 12),
                reusableTextField(
                  'Middle Name',
                  middlenamecontroller,
                  Theme.of(context).primaryColor,
                  () {
                    return null;
                  },
                ),
                SizedBox(height: 12),
                reusableTextField(
                  'Last Name',
                  lastnamecontroller,
                  Theme.of(context).primaryColor,
                  () {
                    return null;
                  },
                ),
                SizedBox(height: 12),
                phoneTextField(
                  'Phone number',
                  phonenumbercontroller,
                  Theme.of(context).primaryColor,
                  () {
                    return null;
                  },
                ),
                SizedBox(height: 12),
                reusableTextField(
                  'Date of Birth',
                  dobcontroller,
                  Theme.of(context).primaryColor,
                  () {
                    return null;
                  },
                ),
                SizedBox(height: 12),
                reusableTextField(
                  'Nationality',
                  nationalitycontroller,
                  Theme.of(context).primaryColor,
                  () {
                    return null;
                  },
                ),
                SizedBox(height: 12),
                reusableTextField(
                  'State',
                  statecontroller,
                  Theme.of(context).primaryColor,
                  () {
                    return null;
                  },
                ),
                SizedBox(height: 12),
                reusableTextField(
                  'Local Government Area',
                  lgacontroller,
                  Theme.of(context).primaryColor,
                  () {
                    return null;
                  },
                ),
                SizedBox(height: 12),
                reusableTextField(
                  'Address',
                  addresscontroller,
                  Theme.of(context).primaryColor,
                  () {
                    return null;
                  },
                ),
                SizedBox(height: 32),
                _isLoading
                    ? Loading()
                    : button(context, 'Register', () {
                        updateprofile();
                      }),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
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
    try {
      final EP = ref.read(authProvider).EPData;
      // final FN = ref.read(authProvider).FNData;
      // print('${EP['email']}, ${EP['password']}, ${FN['fullname']},}');
      await ref
          .read(authProvider)
          .registerUser(
            EP['email'],
            EP['password'],
            firstnamecontroller.text,
            middlenamecontroller.text,
            lastnamecontroller.text,
            phonenumbercontroller.text,
            dobcontroller.text,
            nationalitycontroller.text,
            statecontroller.text,
            lgacontroller.text,
            addresscontroller.text,
          )
          .then((value) {
        become(context, verify.routeName, null);
        showUpMessage(
            context, 'Registration Mail sent successfully', 'Sign up Success');
      });
    } catch (e) {
      showUpMessage(context, "Error", e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }
}
