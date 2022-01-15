import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:netflix_redesign/data/category.dart';

import '../constants.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 35, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Category', style: kSectionTitle),
          const SizedBox(height: 14),
          SizedBox(
            height: MediaQuery.of(context).size.height / 9,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: category.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 16),
                  height: MediaQuery.of(context).size.height / 9,
                  width: MediaQuery.of(context).size.width / 3 - 60,
                  decoration: BoxDecoration(
                    color: kBoxColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(category[index]['svg_url']),
                      const SizedBox(height: 4),
                      Text(category[index]['title'], style: kCategoryTitle),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
