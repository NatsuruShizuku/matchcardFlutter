import 'package:flutter/material.dart';
import 'package:flutter_application_0/theme/app_theme.dart';


class ErrorPage extends StatelessWidget {
  const ErrorPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple,
      child: Center(
        child: Text(
          'มีข้อผิดพลาดเกิดขึ้น',
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      ),
    );
  }
}