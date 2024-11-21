import 'package:flutter/material.dart';

class BillingRequest extends StatefulWidget {
  final ValueChanged<String?> requestSelected;
  BillingRequest({required this.requestSelected});

  @override
  _BillingRequestState createState() => _BillingRequestState();
}

class _BillingRequestState extends State<BillingRequest> {
  String? selectRequest;


  void _handleWarningSelected(String? description) {
    setState(() {
      selectRequest = description;
    });
    widget.requestSelected(description);
  }



  Widget _buildWarningOption(String warningText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            _handleWarningSelected(warningText);
          },
          child: Text(warningText),
        ),
        Checkbox(
          splashRadius: 30,
          value: selectRequest == warningText,
          onChanged: (val) {
            _handleWarningSelected(val! ? warningText : null);
          },
          side: BorderSide(
            width: 1,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text(
          'Each Tow service price is inflenced by the distance of your vehicle, from the pick up location to the drop off spot.',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        Text(
          'Select your Billing method below',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        Divider(),
        SizedBox(height: 12),
        _buildWarningOption('Cash'),
        SizedBox(height: 12),
        _buildWarningOption('Online Bank Transfer'),
        SizedBox(height: 12),
        _buildWarningOption('ATM Card Service'),
      ],
    );
  }
}
