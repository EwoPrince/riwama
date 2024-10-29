import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/view/dashboard/land.dart';
import 'package:riwama/widgets/button.dart';
import 'package:riwama/widgets/loading.dart';
import 'package:riwama/widgets/textField.dart';
import 'package:riwama/x.dart';

class SupervisorForm extends ConsumerStatefulWidget {
  const SupervisorForm({super.key});
  static const routeName = '/SupervisorForm';

  @override
  ConsumerState<SupervisorForm> createState() => _SupervisorFormState();
}

class _SupervisorFormState extends ConsumerState<SupervisorForm> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController phonenumbercontroller = TextEditingController();
  TextEditingController dln = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Supervisor Form"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Text(
                'You have to supply us with the following details to approve your application for Supervisor previlage,',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              phoneTextField('phone number', phonenumbercontroller,
                  Theme.of(context).primaryColor, () {
                return null;
              }),
              SizedBox(height: 8),
              phoneTextField(
                  'Contractor ID Number', dln, Theme.of(context).primaryColor,
                  () {
                return null;
              }),
              Spacer(),
              _isLoading ? Loading() : button(context, 'Update', updateprofile),
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
    try {
      await ref.read(authProvider).becomeSupervisor().then((value) {
        become(context, Land.routeName, null);
        showUpMessage(context, 'Supervisor Registration sent successfully',
            'Application Summited');
      });
    } catch (e) {
      showUpMessage(context, "Error", e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }
}
