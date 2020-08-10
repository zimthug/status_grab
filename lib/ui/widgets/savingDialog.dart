import 'package:flutter/material.dart';

class SavingDialog extends StatefulWidget {
  final bool progress;
  final String message;
  SavingDialog(this.progress, this.message);

  @override
  _SavingDialogState createState() => _SavingDialogState();
}

class _SavingDialogState extends State<SavingDialog> {
  @override
  Widget build(BuildContext context) {
    if (widget.progress) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: <Widget>[
                Center(
                  child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: CircularProgressIndicator()),
                ),
              ],
            );
          });
    } else {}
  }
}
