import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/widgets/button.dart';
import 'package:url_launcher/url_launcher.dart';

class Billings extends ConsumerStatefulWidget {
  const Billings({super.key});
  static const routeName = '/Billings';

  @override
  ConsumerState<Billings> createState() => _BillingsState();
}

class _BillingsState extends ConsumerState<Billings> {
  final Uri TTurl = Uri.parse('https://www.riwama.com.ng');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Billing Information',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                size: 100,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 20),
              Text(
                'Billing Notice',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'The billing of this service is currently being taken care of by the Rivers State Waste Management Agency.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 40),
              button(
                context,
                'Learn More',
                () async {
                  if (!await launchUrl(
                    TTurl,
                    mode: LaunchMode.externalApplication,
                  )) {
                    throw Exception('Could not launch $TTurl');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
