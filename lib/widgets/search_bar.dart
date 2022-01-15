import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(35, 0, 35, 40),
      child: Container(
        height: 48,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
        decoration: BoxDecoration(
          color: kTextColor.withOpacity(0.1),
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: TextField(
          style: kSearchHint.apply(color: kTextColor),
          decoration: InputDecoration(
            icon: SvgPicture.asset('assets/icons/search.svg'),
            hintText: 'Search Movies',
            hintStyle: kSearchHint,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
