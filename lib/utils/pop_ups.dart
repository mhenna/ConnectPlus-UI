import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showConfirmationPopUp(
    {BuildContext context,
    String message,
    onConfirmed,
    String successMessage,
    String successMessageTitle,
    afterSuccess}) async {
  bool confirmed = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm'),
        content: Text(message),
        actions: [
          FlatButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          FlatButton(
            child: Text('Confirm'),
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Center(child: CircularProgressIndicator());
                },
              );
              await onConfirmed();
              Navigator.of(context).pop();
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
  if (confirmed == true) {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(successMessageTitle),
          content: Text(successMessage),
          actions: [
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                afterSuccess();
              },
            ),
          ],
        );
      },
    );
    Navigator.pop(context);
  }
}

Future<void> showAfterLoadingPopUp(
    {BuildContext context,
    loadingFunction,
    String successMessage,
    String successMessageTitle,
    afterSuccess}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(child: CircularProgressIndicator());
    },
  );
  await loadingFunction();
  Navigator.of(context).pop();
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(successMessageTitle),
        content: Text(successMessage),
        actions: [
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
              afterSuccess();
            },
          ),
        ],
      );
    },
  );
  Navigator.pop(context);
}
