import 'package:flutter/material.dart';

class DescribeRequest extends StatefulWidget {
  final ValueChanged<String?> requestSelected;
  DescribeRequest({required this.requestSelected});

  @override
  _DescribeRequestState createState() => _DescribeRequestState();
}

class _DescribeRequestState extends State<DescribeRequest> {
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
          'Add a discription for this Pick up request',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        Text(
          'Select a category, and we\'ll put a label to this request. This helps the workers manage your waste better',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        Divider(),
        SizedBox(height: 12),
        _buildWarningOption('household'),
        SizedBox(height: 12),
        _buildWarningOption('recyclables'),
        SizedBox(height: 12),
        _buildWarningOption('hazardous'),
      ],
    );
  }
}
