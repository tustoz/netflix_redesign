import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:netflix_redesign/widgets/bottom_bar.dart';

void main() {
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  runApp(const NetflixRedesign());
}

class NetflixRedesign extends StatelessWidget {
  const NetflixRedesign({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Netflix Redesign',
      home: BottomBar(),
    );
  }
}
