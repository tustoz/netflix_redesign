import 'package:flutter/material.dart';

import '../constants.dart';

class Loading extends StatelessWidget {
  final EdgeInsetsGeometry padding;

  const Loading({Key? key, required this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
        ),
      ),
    );
  }
}
