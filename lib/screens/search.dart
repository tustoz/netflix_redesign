import 'package:flutter/material.dart';
import 'package:netflix_redesign/utils/services.dart';

import 'package:netflix_redesign/widgets/home/search_bar.dart';
import 'package:netflix_redesign/constants.dart';
import 'package:netflix_redesign/widgets/search/search_list.dart';

class SearchScreen extends StatefulWidget {
  final String query;

  const SearchScreen({Key? key, required this.query}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    futureSearchMovie = fetchSearchMovie(widget.query);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SearchBar(),
            SearchList(futureSearchMovie: futureSearchMovie),
          ],
        ),
      ),
    );
  }
}
