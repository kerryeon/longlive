import 'package:flutter/material.dart';

/// 네/아니오 선택이 가능한 알림창을 날립니다.
Future<void> showYesNoDialog({
  BuildContext context,
  String title = '알림',
  String content,
  void Function() onAccept,
  void Function() onDeny,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return WillPopScope(
        child: AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('네'),
              onPressed: () {
                if (onAccept != null) onAccept();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('아니오'),
              onPressed: () {
                if (onDeny != null) onDeny();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        onWillPop: () async {
          if (onDeny != null) onDeny();
          return true;
        },
      );
    },
  );
}
