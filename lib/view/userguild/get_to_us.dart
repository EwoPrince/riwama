import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riwama/widgets/button.dart';
import 'package:riwama/widgets/textField.dart';
import 'package:riwama/x.dart';
import 'package:url_launcher/url_launcher.dart';

class GetToUs extends StatefulWidget {
  GetToUs({Key? key}) : super(key: key);
  static const routeName = '/GetToUs';

  @override
  State<GetToUs> createState() => _GetToUsState();
}

class _GetToUsState extends State<GetToUs> {
  TextEditingController messagecontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    DocumentReference users =
        FirebaseFirestore.instance.collection('users').doc(uid);

    return Scaffold(
      appBar: AppBar(
        title: Text('Send Message'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                'Make Complaints and Enquiries about process, and services concerning RIWAMA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                'or just write us a letter telling us about how you feel...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              child: Form(
                child: Column(
                  children: [
                    const SizedBox(height: 20.0),
                    Form(
                      key: _formKey,
                      child: expandableTextField(
                        'Dear RIWAMA',
                        Theme.of(context).primaryColor,
                        messagecontroller,
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    button(
                      context,
                      'Send Message',
                      () async {
                        final formValidate = _formKey.currentState?.validate();

                        if (!(formValidate!)) {
                          return;
                        }
                        _formKey.currentState?.save();

                        showMessage(context, 'sending message...');
                        users.update({
                          'message': messagecontroller.text,
                        }).then((device) {
                          Navigator.pop(context);
                          showUpMessage(
                              context, 'Message sent successfully', 'Success');
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    button(
                      context,
                      'Contact Consumer Services',
                      () async {
                        final Uri launchUri = Uri(
                          scheme: 'tel',
                          path: '+2347085136311',
                        );
                        try {
                          await launchUrl(launchUri);
                        } catch (error) {
                          showMessage(context, "Cannot dial");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
