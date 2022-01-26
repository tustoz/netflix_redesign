import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants.dart';

class CategoryItem extends StatelessWidget {
  final Size size;
  final String title;
  final String svgPath;

  const CategoryItem({
    Key? key,
    required this.size,
    required this.title,
    required this.svgPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      height: size.height / 9,
      width: size.width / 3 - 60,
      decoration: BoxDecoration(
        color: kBoxColor.withOpacity(0.1),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(svgPath),
          const SizedBox(height: 4),
          Text(title, style: kCategoryTitle),
        ],
      ),
    );
  }
}
